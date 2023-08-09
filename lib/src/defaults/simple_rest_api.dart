import 'dart:async';
import 'dart:convert';

import 'package:clean_framework_legacy/clean_framework.dart';
import 'package:http/http.dart';

import 'http_client/cross_client.dart'
    if (dart.library.io) 'http_client/io_client.dart';

/// A simple rest api where the response is generally obtained in plain string form.
class SimpleRestApi extends RestApi {
  /// The base url.
  final String baseUrl;

  /// Whether to trust self-signed certificates or not.
  ///
  /// Defaults to false.
  final bool trustSelfSigned;

  Client _httpClient;
  Map<String, String>? _headers = {'Content-type': 'application/json'};

  /// Creates a SimpleRestApi.
  SimpleRestApi(
      {this.baseUrl = 'http://127.0.0.1:8080/service/',
      this.trustSelfSigned = false,
      Client? httpClient})
      : _httpClient = httpClient ?? createHttpClient(trustSelfSigned);

  /// Sets the [headers].
  set headers(Map<String, String> headers) => _headers = headers;

  @override
  Future<RestResponse<String>> requestBinary({
    required RestMethod method,
    required String path,
    Map<String, dynamic> requestBody = const {},
  }) {
    return request(method: method, path: path, requestBody: requestBody);
  }

  @override
  Future<RestResponse<String>> request({
    required RestMethod method,
    required String path,
    Map<String, dynamic> requestBody = const {},
  }) async {
    assert(path.isNotEmpty);

    Response? response;
    Uri uri = Uri.parse(baseUrl + path);

    try {
      switch (method) {
        case RestMethod.get:
          response = await _httpClient.get(uri, headers: _headers);
          break;
        case RestMethod.post:
          response = await _httpClient.post(uri,
              headers: _headers, body: json.encode(requestBody));
          break;
        case RestMethod.put:
          response = await _httpClient.put(uri,
              headers: _headers, body: json.encode(requestBody));
          break;
        case RestMethod.delete:
          response = await _httpClient.delete(uri, headers: _headers);
          break;
        case RestMethod.patch:
          response = await _httpClient.patch(uri,
              headers: _headers, body: json.encode(requestBody));
          break;
      }

      return RestResponse<String>(
        type: getResponseTypeFromCode(response.statusCode),
        uri: uri,
        content: response.body,
      );
    } on ClientException {
      return RestResponse<String>(
        type: getResponseTypeFromCode(response?.statusCode),
        uri: uri,
        content: response?.body ?? '',
      );
    } catch (e) {
      return RestResponse<String>(
        type: RestResponseType.unknown,
        uri: uri,
        content: '',
      );
    }
  }
}
