import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> playerIDMap(String token, String playerID) async {
  // debugPrint('Token: $token, PlayerID: $playerID');
  final response = await http.post(
    Uri.parse(
      'https://ecompaascare-srv-dev.skill-mine.com/api/v1/user/player/map',
      // 'https://api.sterlingaccuris.in/api/v1/user/player/map',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
      // 'Authorization':
      //     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Vjb21wYWFzY2FyZS1zcnYtZGV2LnNraWxsLW1pbmUuY29tIiwiZXhwIjoxNjc5OTk3MDMyLCJpYXQiOjE2Nzk5MTA2MzIsImF1dGhfdGltZSI6MTY3OTkxMDYzMiwianRpIjoiZmJjOGZkZGUtOTMyZC00MjU0LWE0YmYtYjkyNDEyYTRkY2QxIiwic2lkIjoiODk3NWI3MTktYzM3MC00ZWViLTg2M2UtNTVhNzFlNmM5Y2QxIiwic3ViIjoiMDU0NGYzNjgtZWY0Yi00MzYyLTg5ZmUtMTUxYzYyNjIzZWY0IiwibW9iaWxlX251bWJlciI6Iis5MTk5MDA4ODQ2MjMiLCJuYW1lIjoiICJ9.IaHPijlcJXEYPa4W7VVanWuBk2JF8HdyvsCIEx8pH1A'
    },
    body: jsonEncode(<String, dynamic>{"player_id": playerID}),
  );
  return response.statusCode.toString();
}
