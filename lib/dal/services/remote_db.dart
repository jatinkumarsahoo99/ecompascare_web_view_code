import 'dart:convert';
import 'package:ecompasscare/infrastructure/config.dart';
import 'package:http/http.dart' as http;

Future<String> playerIDMap(String token, String playerID) async {
  // debugPrint('Token: $token, PlayerID: $playerID');
  final response = await http.post(
    Uri.parse(ConfigEnvironments.env['baseAPI'] + '/v1/user/player/map'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, dynamic>{"player_id": playerID}),
  );
  return response.statusCode.toString();
}
