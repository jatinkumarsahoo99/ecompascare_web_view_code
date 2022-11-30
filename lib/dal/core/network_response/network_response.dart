part 'network_status.dart';

///This class is for returning Entity class as [body] and NetworkStatus as [status]
///from the RemoteDaos to the Use Cases or the controller
class NetworkResponse<T> {
  ///this is to store the status of a api call when its executed
  final NetworkStatus status;

  ///this is to catch the api response as json and convert it to RichData([T] : Entity class)
  final T? body;

  ///this constructor is to be used by outside world to construct
  ///a object of [NetworkResponse] class by supplying
  ///[status] of type [NetworkStatus] and [body] of type [T]
  const NetworkResponse({
    required this.status,
    required this.body,
  });

  ///this constructor is to construct a object of [NetworkResponse]
  ///class by supplying [body] of type [T] and [status] is set up as NO INTERNET
  NetworkResponse.offline({
    required this.body,
  }) : status = const NetworkStatus.noInternet();

  // factory NetworkResponse.fromResponse({required Response response}) {
  //   dynamic x = T;
  //   return NetworkResponse(status: response.status, body: x.fromJson(response.body!));
  // }
}
