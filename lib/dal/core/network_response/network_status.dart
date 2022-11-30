part of 'network_response.dart';

///This class is a custom Network Status, this will store only the status parameters we will need
class NetworkStatus {
  ///this is the status code got from the network call
  final int statusCode;

  ///this is the status message got from the network call
  final String statusMessage;

  ///this is the status of the network call whether it is an Error or Not
  final bool isError;

  ///this is the status of the network call whether it is for no internet or not
  final bool isOffline;

  ///This constructor sets initially the [statusCode] to be 200,
  ///i.e, success if no parameter is passed
  const NetworkStatus.init({
    this.statusCode = 200,
    this.statusMessage = 'success',
  })  : isError = (statusCode < 200) || (statusCode >= 300),
        isOffline = false;

  ///This constructor sets  the [statusCode] to be 502,
  ///i.e, no internet if no parameter is passed
  const NetworkStatus.noInternet({
    this.statusCode = 502,
    this.statusMessage = 'no_internet',
  })  : isError = true,
        isOffline = true;

  ///This constructor sets status according to the parameter passed
  ///both [statusCode] and [statusMessage] variables are required
  ///and isError is calculated according to the statusCode
  const NetworkStatus({
    required this.statusCode,
    required this.statusMessage,
  })  : isError = (statusCode < 200) || (statusCode >= 300),
        isOffline = statusCode == 502;
}
