import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../async_json_string_converter.dart';
import '../cancellation_exception.dart';
import '../debug_util.dart';
import 'http_status.dart';
import 'json_client.dart';
import 'network_result.dart';

class NetworkHelper {
  final Map<String, Completer> _runningCompleterMap = {};
  static final NetworkHelper _instance = NetworkHelper._internal();

  factory NetworkHelper() => _instance;

  NetworkHelper._internal();

  Future<NetworkResult<G, E>> _createNetworkResultFromResponse<G, E>(
    Response response,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
  ) async {
    NetworkResult<G, E> networkResult;
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (jsonProcessor != null) {
        try {
          G object = await jsonProcessor.fromJson(response.body);
          networkResult = NetworkResult.good(object, HttpStatus.fromResponse(response));
        } on Error catch (err) {
          debugUtil.log(err.toString());
          networkResult = NetworkResult.malformed(response.body, HttpStatus.fromResponse(response), Exception(err.toString()));
        } catch (e) {
          debugUtil.log(e.toString());
          networkResult = NetworkResult.malformed(response.body, HttpStatus.fromResponse(response), e as Exception);
        }
      } else {
        networkResult = NetworkResult.good(response.body as G, HttpStatus.fromResponse(response));
      }
    } else {
      if (errorJsonProcessor != null) {
        try {
          E object = await errorJsonProcessor.fromJson(response.body);
          networkResult = NetworkResult.httpError(object, HttpStatus.fromResponse(response));
        } on Error catch (err) {
          networkResult =
              NetworkResult.httpErrorMalformed(response.body, HttpStatus.fromResponse(response), Exception(err.toString()));
        } catch (e) {
          networkResult = NetworkResult.httpErrorMalformed(response.body, HttpStatus.fromResponse(response), e as Exception);
        }
      } else {
        networkResult = NetworkResult.httpError(response.body as E, HttpStatus.fromResponse(response));
      }
    }
    return networkResult;
  }

  Future<NetworkResult> _doAsync<P, G, E>(
    String method,
    Uri url,
    Map<String, String>? headerMap,
    P? data,
    AsyncJsonStringConverter<P>? requestJsonProcessor,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
    Duration timeout,
    String? username,
    String? password,
    String? token,
    String? tag,
  ) async {
    NetworkResult<G, E> networkResult;
    JsonClient jsonClient = JsonClient();
    Completer<Response> completer = Completer();
    if (tag != null) {
      _runningCompleterMap[tag] = completer;
    } else {
      _runningCompleterMap[url.toString()] = completer;
    }
    headerMap ??= {};
    if (token != null) {
      headerMap["Authorization"] = "Bearer $token";
    } else if (username != null && password != null) {
      final credentials = "$username:$password";
      final encodedCredentials = utf8.fuse(base64).encode(credentials);
      headerMap["Authorization"] = "Basic $encodedCredentials";
    }
    try {
      Future<Response>? futureResponse;
      switch (method) {
        case "GET":
          {
            futureResponse = jsonClient.get(url, headers: headerMap).timeout(timeout);
          }
          break;
        case "POST":
          {
            futureResponse = jsonClient
                .post(url, headers: headerMap, body: data != null ? await requestJsonProcessor!.toJson(data) : null)
                .timeout(timeout);
          }
          break;
        case "PUT":
          {
            futureResponse = jsonClient
                .put(url, headers: headerMap, body: data != null ? await requestJsonProcessor!.toJson(data) : null)
                .timeout(timeout);
          }
          break;
        case "PATCH":
          {
            futureResponse = jsonClient
                .patch(url, headers: headerMap, body: data != null ? await requestJsonProcessor!.toJson(data) : null)
                .timeout(timeout);
          }
          break;
        case "DELETE":
          {
            futureResponse = jsonClient.delete(url, headers: headerMap).timeout(timeout);
          }
          break;
      }
      futureResponse?.then((response) {
        if (!completer.isCompleted) {
          completer.complete(response);
        }
      }, onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
        return null;
      });
      Response response = await completer.future;
      networkResult = await _createNetworkResultFromResponse(response, jsonProcessor, errorJsonProcessor);
    } on Error catch (err) {
      networkResult = NetworkResult.badRequestData(Exception(err.toString()));
    } on TimeoutException catch (e) {
      networkResult = NetworkResult.timeout(e.duration);
    } on CancellationException {
      networkResult = NetworkResult.cancelled();
    } catch (e) {
      networkResult = NetworkResult.ioError(e as Exception);
    } finally {
      if (tag != null) {
        _runningCompleterMap.remove(tag);
      } else {
        _runningCompleterMap.remove(url);
      }
      jsonClient.close();
    }
    debugUtil.log(networkResult.toString());
    return networkResult;
  }

  Future<NetworkResult> getAsync<G, E>(
    String url, {
    Map<String, String>? headerMap,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
    Duration timeout = const Duration(seconds: 10),
    String? username,
    String? password,
    String? token,
    String? tag,
  }) {
    return _doAsync(
      "GET",
      Uri.parse(url),
      headerMap,
      null,
      null,
      jsonProcessor,
      errorJsonProcessor,
      timeout,
      username,
      password,
      token,
      tag,
    );
  }

  Future<NetworkResult> postAsync<P, G, E>(
    String url, {
    Map<String, String>? headerMap,
    P? data,
    AsyncJsonStringConverter<P>? requestJsonProcessor,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
    Duration timeout = const Duration(seconds: 10),
    String? username,
    String? password,
    String? token,
    String? tag,
  }) {
    return _doAsync(
      "POST",
      Uri.parse(url),
      headerMap,
      data,
      requestJsonProcessor,
      jsonProcessor,
      errorJsonProcessor,
      timeout,
      username,
      password,
      token,
      tag,
    );
  }

  Future<NetworkResult> putAsync<P, G, E>(
    String url, {
    Map<String, String>? headerMap,
    P? data,
    AsyncJsonStringConverter<P>? requestJsonProcessor,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
    Duration timeout = const Duration(seconds: 10),
    String? username,
    String? password,
    String? token,
    String? tag,
  }) {
    return _doAsync(
      "PUT",
      Uri.parse(url),
      headerMap,
      data,
      requestJsonProcessor,
      jsonProcessor,
      errorJsonProcessor,
      timeout,
      username,
      password,
      token,
      tag,
    );
  }

  Future<NetworkResult> patchAsync<P, G, E>(
    String url, {
    Map<String, String>? headerMap,
    P? data,
    AsyncJsonStringConverter<P>? requestJsonProcessor,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
    Duration timeout = const Duration(seconds: 10),
    String? username,
    String? password,
    String? token,
    String? tag,
  }) {
    return _doAsync(
      "PATCH",
      Uri.parse(url),
      headerMap,
      data,
      requestJsonProcessor,
      jsonProcessor,
      errorJsonProcessor,
      timeout,
      username,
      password,
      token,
      tag,
    );
  }

  Future<NetworkResult> deleteAsync<G, E>(
    String url, {
    Map<String, String>? headerMap,
    AsyncJsonStringConverter<G>? jsonProcessor,
    AsyncJsonStringConverter<E>? errorJsonProcessor,
    Duration timeout = const Duration(seconds: 10),
    String? username,
    String? password,
    String? token,
    String? tag,
  }) {
    return _doAsync(
      "DELETE",
      Uri.parse(url),
      headerMap,
      null,
      null,
      jsonProcessor,
      errorJsonProcessor,
      timeout,
      username,
      password,
      token,
      tag,
    );
  }

  void cancel(String tag) {
    Completer? completer = _runningCompleterMap[tag];
    if (completer != null && !completer.isCompleted) {
      completer.completeError(const CancellationException());
    }
  }
}

NetworkHelper networkHelper = NetworkHelper();
