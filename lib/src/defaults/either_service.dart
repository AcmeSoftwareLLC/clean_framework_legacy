import 'dart:convert';

import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:equatable/equatable.dart';

import 'json_service.dart';

export 'json_parse_helpers.dart';

abstract class EitherService<R extends JsonRequestModel,
    S extends JsonResponseModel> implements Service<R, S> {
  RestApi _restApi;
  String _path;
  RestMethod _method;

  final String path;

  EitherService({
    required RestMethod method,
    required this.path,
    required RestApi restApi,
  })   : assert(path.isNotEmpty),
        _path = path,
        _method = method,
        _restApi = restApi;

  @override
  Future<Either<ServiceFailure, S>> request({R? requestModel}) async {
    if (await Locator().connectivity.getConnectivityStatus() ==
        ConnectivityStatus.offline) {
      Locator().logger.debug('JsonService response no connectivity error');
      return Left(NoConnectivityServiceFailure());
    }

    Map<String, dynamic> requestJson = const {};
    if (requestModel != null) {
      requestJson = requestModel.toJson();
      if (!isRequestModelJsonValid(requestJson)) {
        Locator().logger.debug('JsonService response invalid request error');
        return Left(GeneralServiceFailure());
      }
    }

    final response = await _restApi.request(
        method: _method, path: _path, requestBody: requestJson);

    if (response.type == RestResponseType.timeOut) {
      Locator().logger.debug('JsonService response no connectivity error');
      return Left(NoConnectivityServiceFailure());
    }

    S model;

    try {
      final content = response.content.toString();
      final Map<String, dynamic> jsonResponse =
          (content.isEmpty) ? {} : json.decode(content) ?? <String, dynamic>{};

      if (response.type != RestResponseType.success) {
        return Left(onError(response.type, jsonResponse));
      }

      model = parseResponse(jsonResponse);
      return Right(model);
    } on Exception catch (e) {
      // Errors should not be handled. The app should fail since it a developer
      // mistake and should be fixed ASAP. Exceptions are not the fault of
      // any developer, so we should log them to help us find quickly on
      // production logs the problem.
      Locator()
          .logger
          .error('JsonService response parse exception', e.toString());
    }
    return Left(GeneralServiceFailure());
  }

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

  ServiceFailure onError(
      RestResponseType responseType, Map<String, dynamic> jsonResponse) {
    return GeneralServiceFailure();
  }
}

abstract class ServiceFailure extends Equatable {
  @override
  List<Object?> get props => [];
}

class GeneralServiceFailure extends ServiceFailure {}

class NoConnectivityServiceFailure extends ServiceFailure {}
