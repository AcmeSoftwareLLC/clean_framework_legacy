import 'dart:convert';

import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

export 'json_parse_helpers.dart';

abstract class JsonResponseModel extends ServiceResponseModel
    with EquatableMixin {
  JsonResponseModel();

  @override
  bool get stringify => true;

  // I have to find yet a way to force this constructor on implementation
  // JsonResponseModel.fromJson(Map<String, dynamic> json);
}

abstract class JsonRequestModel extends ServiceRequestModel {
  Map<String, dynamic> toJson();
}

abstract class JsonService<
    R extends JsonRequestModel,
    S extends JsonResponseModel,
    H extends JsonServiceResponseHandler<S>> implements Service<R, S> {
  RestApi _restApi;
  RestMethod _method;
  H _handler;
  String? _resolvedPath;

  final String path;

  @visibleForTesting
  String? get resolvedPath => _resolvedPath;

  JsonService({
    required H handler,
    required RestMethod method,
    required this.path,
    required RestApi restApi,
  })   : assert(path.isNotEmpty),
        _handler = handler,
        _method = method,
        _restApi = restApi;

  @override
  Future<void> request({R? requestModel}) async {
    if (await Locator().connectivity.getConnectivityStatus() ==
        ConnectivityStatus.offline) {
      _handler.onNoConnectivity();
      return;
    }

    Map<String, dynamic> requestJson = {};
    if (requestModel != null) {
      requestJson = requestModel.toJson();
      if (!isRequestModelJsonValid(requestJson)) {
        _handler.onInvalidRequest(requestJson);
        return;
      }
    }

    if (RegExp(r'{(\w+)}').hasMatch(path) && requestModel == null) {
      // If a service has a variable in the path, request data is required
      _handler.onInvalidRequest(null);
      return;
    }

    final pathUri = Uri.parse(path);

    final injectedQueryParams = pathUri.queryParameters.map(
      (k, v) => MapEntry(
        k,
        _isVariable(v) ? requestJson[_removeWrapper(v)]?.toString() : v,
      ),
    );
    if (injectedQueryParams.containsValue(null)) {
      // Some query parameter variables where not substituted by request fields
      _handler.onInvalidRequest(requestJson);
      return;
    }

    var _pathSubstitutionSuccess = true;
    final injectedPath = pathUri.path.replaceAllMapped(
      RegExp(r'%7B(\w+)%7D'),
      (match) {
        final value = requestJson[match.group(1)];
        if (value == null) _pathSubstitutionSuccess = false;
        return value?.toString() ?? '';
      },
    );
    if (!_pathSubstitutionSuccess) {
      // Some path segment variables where not substituted by request fields
      _handler.onInvalidRequest(requestJson);
      return;
    }

    _resolvedPath = Uri(
      path: injectedPath,
      queryParameters: injectedQueryParams.isEmpty ? null : injectedQueryParams,
    ).toString();

    final response = await _restApi.request(
      method: _method,
      path: _resolvedPath!,
      requestBody: requestJson,
    );

    if (response.type == RestResponseType.timeOut) {
      _handler.onNoConnectivity();
      return;
    } else if (response.type != RestResponseType.success) {
      if (!onError(response, _handler)) {
        _handler.onError(response.type, response.content.toString());
        return;
      }
    }

    S model;

    try {
      final content = response.content.toString();
      final Map<String, dynamic> jsonResponse =
          (content.isEmpty) ? {} : json.decode(content) ?? <String, dynamic>{};
      model = parseResponse(jsonResponse);
    } on Error catch (e) {
      Locator().logger.debug('JsonService response parse error', e.toString());
      _handler.onInvalidResponse(response.content.toString());
      return;
    } on Exception catch (e) {
      Locator()
          .logger
          .debug('JsonService response parse exception', e.toString());
      _handler.onInvalidResponse(response.content.toString());
      return;
    }

    _handler.onSuccess(model);
  }

  /// Checks whether the [value] is path variable or not.
  bool _isVariable(String value) => RegExp(r'^{(\w+)}$').hasMatch(value);

  /// Removes the bracket wrapper of [value]. i.e. {something} -> something
  String _removeWrapper(String value) => value.substring(1, value.length - 1);

  bool isRequestModelJsonValid(Map<String, dynamic> json) {
    try {
      if (json.isEmpty || _jsonContainsNull(json)) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool _jsonContainsNull(Map<String, dynamic> json) {
    bool containsNull = false;
    List values = json.values.toList();
    for (int i = 0; i < values.length; i++) {
      if (values[i] is Map)
        containsNull = _jsonContainsNull(values[i]);
      else if (values[i] == null) containsNull = true;
      if (containsNull) break;
    }
    return containsNull;
  }

  S parseResponse(Map<String, dynamic> jsonResponse);

  bool onError(RestResponse response, JsonServiceResponseHandler<S> handler) {
    return false;
  }
}

abstract class JsonServiceResponseHandler<S extends JsonResponseModel>
    extends ServiceResponseHandler<S> {
  void onMissingPathData(Map<String, dynamic> requestJson);
  void onInvalidRequest(Map<String, dynamic>? requestJson);
  void onInvalidResponse(String response);
  void onError(RestResponseType responseType, String response);
}

class EmptyJsonResponseModel extends JsonResponseModel {
  @override
  List<Object?> get props => [];
}
