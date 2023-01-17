import 'dart:developer';
import 'package:ecompasscare/infrastructure/config.dart';
import 'package:dio/dio.dart';
import 'interfaces/i_remote_db.dart';
import 'local_storage.dart';

export 'package:ecompasscare/dal/core/extentions/response_to_map.dart';

enum _RestApiMethod { get, put, post, patch, delete }

class RemoteDB implements IRemoteDB {
  static final RemoteDB instance = RemoteDB._();

  RemoteDB._();

  var dio = Dio(BaseOptions(baseUrl: ConfigEnvironments.env['url'] ?? ''));

  Future<Map<String, String>> getHeader() async {
    String? bToken = LocalStorage.instance.readString('kIdToken');
    final Map<String, String> headers = {
      'Authorization': bToken ?? "",
      'Content-Type': 'application/json',
    };
    return headers;
  }

  Future<Response<Map<String, dynamic>?>> _restApi<T>(
    String path, {
    String? baseUrl,
    required String apiVersion,
    required _RestApiMethod apiMethod,
    dynamic body = const {},

    ///[attachToken] is for defining whether to attach token in the header or not
    bool attachToken = true,
  }) async {
    try {
      if (baseUrl != null) {
        ///if user chooses to send a different base url
        dio.options.baseUrl = baseUrl + apiVersion;
      } else {
        ///if user chooses to send a different base url
        dio.options.baseUrl =
            (ConfigEnvironments.env['url'] ?? '') + apiVersion;
      }

      ///logging the POST endpoint and PAYLOAD
      log('${dio.options.baseUrl}$path', name: '$apiMethod');
      if (body is! FormData) log(body.toString(), name: "PAYLOAD");

      ///checking if the internet is connected or not
      // if (!(await isInternetConnected())) {
      // showSnackBar('NO INTERNET CONNECTION', isError: null);
      // return null;
      // }

      ///Hitting the POST request
      Response<Map<String, dynamic>?> response;

      Options? options =
          attachToken ? Options(headers: await getHeader()) : null;
      switch (apiMethod) {
        case _RestApiMethod.get:
          response = await dio.get(path, options: options);
          break;
        case _RestApiMethod.put:
          response = await dio.put(path, data: body, options: options);
          break;
        case _RestApiMethod.post:
          response = await dio.post(path, data: body, options: options);
          break;
        case _RestApiMethod.patch:
          response = await dio.patch(path, data: body, options: options);
          break;
        case _RestApiMethod.delete:
          response = await dio.delete(path, data: body, options: options);
          break;
      }

      ///logging the RESPONSE details
      if (ConfigEnvironments.env['api_logs'] is bool) {
        if (ConfigEnvironments.env['api_logs'] as bool) {
          log('${response.data}', name: "RESPONSE");
          log('${response.statusCode}', name: "RESPONSE STATUS CODE");
        }
      }
      return response;
    } on DioError catch (e) {
      ///if exception show the error
      log('${e.response?.data}', name: 'DIO EXCEPTION');
      if (e.response is Response<Map<String, dynamic>?>) {
        return e.response as Response<Map<String, dynamic>?>;
      } else {
        return Response<Map<String, dynamic>?>(
          requestOptions: RequestOptions(path: path),
          statusCode: -101,
          statusMessage: 'Unexpected Error',
        );
      }
    }
  }

  @override
  Future<Response<Map<String, dynamic>?>> delete<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    bool attachToken = true,
  }) async {
    return await _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.delete,
    );
  }

  @override
  Future<Response<Map<String, dynamic>?>> get<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    bool attachToken = true,
  }) async {
    return await _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.get,
    );
  }

  @override
  Future<Response<Map<String, dynamic>?>> patch<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    bool attachToken = true,
  }) async {
    return await _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.patch,
    );
  }

  @override
  Future<Response<Map<String, dynamic>?>> post<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    bool attachToken = true,
  }) async {
    return await _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.post,
    );
  }

  @override
  Future<Response<Map<String, dynamic>?>> put<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    bool attachToken = true,
  }) async {
    return await _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.put,
    );
  }
}

Future<Response<Map<String, dynamic>?>> simulateLocalResponse(
    Map<String, dynamic>? result,
    {bool isError = false}) async {
  await Future.delayed(const Duration(seconds: 1));
  return Response<Map<String, dynamic>?>(
    requestOptions: RequestOptions(path: 'path'),
    data: result,
    statusCode: isError ? 502 : 200,
    statusMessage: isError ? 'error' : 'success',
  );
}
