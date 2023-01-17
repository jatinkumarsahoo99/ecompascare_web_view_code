import 'package:ecompasscare/dal/core/network_response/network_response.dart';
import 'package:ecompasscare/dal/core/network_state/network_state_mixin.dart';
import 'package:ecompasscare/dal/daos/test_dao.dart';
import 'package:ecompasscare/domain/entity/accounts/test_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with NetworkStateMixin1 {
  late LocationPermission permission;

  final RxBool splashBool = true.obs;

  ///Test
  final isInitialLoaded = false.obs;
  final RxInt progress = 0.obs;

  void splashTimer() async {
    await Future.delayed(const Duration(milliseconds: 1500)).then(
      (value) {
        splashBool.value = false;
      },
    );
  }

  testApiCall() async {
    ///Need to put all the places await where needed
    await networkObserver1(() async {
      NetworkResponse<TestResponse> response =
          await TestDao.instance.testGetApi();

      /// You have the response json converted to [TestResponse]
      /// and kept in [response.body]
      /// can use it here

      /// After using [response.body] need to return [response.status]
      /// to networkObserverX, for 1 api call use [NetworkStateMixin1]
      /// for 2 api calls use [NetworkStateMixin1, NetworkStateMixin2] and so on

      return response.status;
    });
  }

  @override
  void onInit() {
    splashTimer();
    super.onInit();
  }

  @override
  void onReady() async {
    permission = await Geolocator.requestPermission();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
