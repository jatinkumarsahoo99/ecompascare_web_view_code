import 'package:ecompasscare/dal/core/network_response/network_response.dart';
import 'package:ecompasscare/domain/entity/accounts/test_response.dart';

abstract class ITestDao {
  Future<NetworkResponse<TestResponse>> testGetApi();
}
