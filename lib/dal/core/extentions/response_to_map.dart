import 'package:ecompasscare/dal/core/network_response/network_response.dart';
import 'package:dio/dio.dart';

///This extension is for enhancing the existing class [Response] class
///from dio package like it gives a getter [status] of class [NetworkStatus]
///and a body of type Map as dio gives [data] of type [dynamic]
extension ResponseToMap on Response {
  ///This getter [body] is of type Map<String, dynamic>? as
  ///dio package gives [data] of type [dynamic]
  ///it is easy to work with Map when json coming from back-end
  Map<String, dynamic>? get body {
    if (data is Map<String, dynamic>?) {
      return data as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  ///This getter of type bool is for knowing body is null or not
  ///this is helpful not writing the same condition "body == null" again and again
  bool get hasNullBody {
    return body == null;
  }

  ///as Dio package gives [statusCode], [statusMessage] separately with the response
  ///this getter will take those and convert to [NetworkStatus]
  ///and give it as a getter [status]
  NetworkStatus get status {
    var status = NetworkStatus(
      statusCode: statusCode ?? -101,
      statusMessage: statusMessage ?? body?['message'] ?? 'Unexpected Error',
    );
    return status;
  }
}
