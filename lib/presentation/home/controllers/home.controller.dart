import 'package:base_flutter/dal/core/network_response/network_response.dart';
import 'package:base_flutter/dal/core/network_state/network_state_mixin.dart';
import 'package:base_flutter/dal/daos/test_dao.dart';
import 'package:base_flutter/domain/entity/accounts/test_response.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with NetworkStateMixin1 {
  testApiCall() async {
    ///Need to put all the places await where needed
    await networkObserver1(() async {
      NetworkResponse<TestResponse> response =
          await TestDao.instance.testGetApi();

      ///
      /// You have the response json converted to [TestResponse]
      /// and kept in [response.body]
      /// can use it here
      ///

      ///
      /// After using [response.body] need to return [response.status]
      /// to networkObserverX, for 1 api call use [NetworkStateMixin1]
      /// for 2 api calls use [NetworkStateMixin1, NetworkStateMixin2] and so on
      ///
      return response.status;
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
