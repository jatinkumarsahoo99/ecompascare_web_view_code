import 'package:dio/dio.dart';

abstract class IRemoteDB {
  Future<Response?> post<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });

  Future<Response?> get<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    bool attachToken = true,
  });

  Future<Response?> put<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });

  Future<Response?> patch<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });

  Future<Response?> delete<T>(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });
}
