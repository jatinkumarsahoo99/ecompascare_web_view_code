import 'package:base_flutter/dal/core/network_response/network_response.dart';
import 'package:base_flutter/domain/entity/accounts/test_response.dart';

abstract class ITestDao {
  Future<NetworkResponse<TestResponse>> testGetApi();
}
