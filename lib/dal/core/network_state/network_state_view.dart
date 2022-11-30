import 'package:base_flutter/dal/core/network_response/network_response.dart';
import 'package:base_flutter/dal/core/network_state/network_state_mixin.dart';
import 'package:base_flutter/infrastructure/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///This class is for wrap-ing those widgets where some api call will be happening
///It is mandatory to Wrap this class Obx or run setState((){})
///when [networkState] or [networkStatus] is changed
///Then only this class will work in desired behaviour
class NetworkStateView extends StatelessWidget {
  ///This constructor is combination of
  ///NetworkStateView.fullScreenOnly & NetworkStateView.snackBarOnly
  ///i.e, when you wrap a view with this widget this will
  ///show error in snack-bar and in full screen as well
  const NetworkStateView({
    Key? key,
    required this.networkState,
    required this.networkStatus,
    required this.child,
    this.showNoInternetWarningOnly = false,
  }) : super(key: key);

  ///This constructor is for showing error in full screen view
  ///this is useful when opening any screen and calling GET api
  ///and showing state in full Scaffold => Loading or No Internet or Something Went Wrong
  ///wrap that view with this widget and pass the same networkState coming from
  ///networkObserver of the NetworkStateMixin
  const NetworkStateView.fullScreenOnly({
    Key? key,
    required this.networkState,
    required this.child,
    this.showNoInternetWarningOnly = false,
  })  : networkStatus = const NetworkStatus.init(),
        super(key: key);

  ///This constructor is for showing error message in a snack-bar only
  ///this is useful when POST/PATCH etc api is getting hit on tap of a button,
  ///wrap that button with this widget and pass the same networkStatus coming from
  ///networkObserver of the NetworkStateMixin
  const NetworkStateView.snackBarOnly({
    Key? key,
    required this.networkStatus,
    required this.child,
  })  : networkState = NetworkState.success,
        showNoInternetWarningOnly = false,
        super(key: key);

  ///Let's say some api call is going on through a networkObserver then
  ///this variable will tell the widget tree
  ///what is the state of that api call : notStarted, loading, error, noInternet, success
  final NetworkState networkState;

  ///When an api call is completed through a networkObserver
  ///this variable will have the status(statusCode, statusMessage) of the same api call
  final NetworkStatus networkStatus;

  final bool showNoInternetWarningOnly;

  final Widget child;

  Widget buildChild() {
    switch (networkState) {
      case NetworkState.notStarted:
        return const ErrorWidget(text: 'NOT YET STARTED');
      case NetworkState.loading:
        return const LoadingWidget();
      case NetworkState.error:
        return const ErrorWidget();
      case NetworkState.noInternet:
        if (!showNoInternetWarningOnly) {
          return const ErrorWidget(text: 'NO INTERNET CONNECTION');
        } else {
          return child;
        }
      case NetworkState.success:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(10.milliseconds).then((value) {
      ///for showing snack-bar checking networkStatus is ERROR
      if (networkStatus.isError) {
        ///first check if the device is connected to Internet or no
        if (!networkStatus.isOffline) {
          ///if Internet is connected then showing error message came from remote
          showSnackBar(networkStatus.statusMessage, isError: true);
        } else {
          ///if Internet is NOT connected then showing NO INTERNET CONNECTION
          if (showNoInternetWarningOnly) {
            showSnackBar('NO INTERNET CONNECTION', isError: null);
          }
        }
      }
    });
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: buildChild()),
          if (showNoInternetWarningOnly && networkStatus.isOffline)
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.grey.shade600),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              child: const Text(
                'You are offline',
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    this.image,
    this.text,
  }) : super(key: key);
  final Widget? image;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) image!,
            Text(text ?? 'SOMETHING WENT WRONG'),
          ],
        ),
      ),
    );
  }
}
