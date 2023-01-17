import 'package:ecompasscare/dal/core/network_response/network_response.dart';
import 'package:ecompasscare/dal/daos/interfaces/i_account_dao.dart';
import 'package:ecompasscare/dal/services/remote_db.dart';
import 'package:ecompasscare/domain/entity/accounts/test_response.dart';
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
