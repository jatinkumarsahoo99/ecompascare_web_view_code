import 'package:base_flutter/dal/core/network_response/network_response.dart';
import 'package:base_flutter/dal/daos/interfaces/i_account_dao.dart';
import 'package:base_flutter/dal/services/remote_db.dart';
import 'package:base_flutter/domain/entity/accounts/test_response.dart';
import 'package:dio/dio.dart';

class TestDao implements ITestDao {
  TestDao._();

  static final instance = TestDao._();

  @override
  Future<NetworkResponse<TestResponse>> testGetApi() async {
    final Response response = await RemoteDB.instance.get('/path');
    return NetworkResponse(
      status: response.status,
      body:
          response.body == null ? null : TestResponse.fromJson(response.body!),
    );
  }
}
