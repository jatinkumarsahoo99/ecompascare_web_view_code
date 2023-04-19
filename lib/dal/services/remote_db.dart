import 'dart:convert';
import 'package:ecompasscare/domain/entity/file_details.dart';
import 'package:ecompasscare/infrastructure/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<String> playerIDMap(String token, String playerID) async {
  // debugPrint('Token: $token, PlayerID: $playerID');
  final response = await http.post(
    Uri.parse(ConfigEnvironments.env['baseAPI'] + '/v1/user/player/map'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
      // 'Authorization':
      //     'Bearer yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Vjb21wYWFzY2FyZS1zcnYtZGV2LnNraWxsLW1pbmUuY29tIiwiZXhwIjoxNjgxOTc3MzA5LCJpYXQiOjE2ODE4OTA5MDksImF1dGhfdGltZSI6MTY4MTg5MDkwOSwianRpIjoiMTc0MTMwODMtNzQ3Yy00NGQyLTk0ZDEtY2YxMjRlY2U0MmYzIiwic2lkIjoiY2FjOGU5MDYtY2MyZC00MTI5LWI3OWMtNDUzMzJmOGYyMDgwIiwic3ViIjoiMDU0NGYzNjgtZWY0Yi00MzYyLTg5ZmUtMTUxYzYyNjIzZWY0IiwibW9iaWxlX251bWJlciI6Iis5MTk5MDA4ODQ2MjMiLCJuYW1lIjoiU2lkICJ9.0E-P43LFuiq0b_YoWgbHCHbRWkLIIWk7LkOS3FLMAc'
    },
    body: jsonEncode(<String, dynamic>{"player_id": playerID}),
  );
  debugPrint(response.body.toString());
  return response.statusCode.toString();
}

Future<FileDetails> fileDetailsAPI(String token, String fileID) async {
  // debugPrint('Token: $token, FileID: $fileID');
  Response response = await http.get(
    Uri.parse(
        ConfigEnvironments.env['baseAPI'] + '/v1/document/details/' + fileID),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
      // 'Authorization':
      //     'Bearer yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Vjb21wYWFzY2FyZS1zcnYtZGV2LnNraWxsLW1pbmUuY29tIiwiZXhwIjoxNjgxOTc3MzA5LCJpYXQiOjE2ODE4OTA5MDksImF1dGhfdGltZSI6MTY4MTg5MDkwOSwianRpIjoiMTc0MTMwODMtNzQ3Yy00NGQyLTk0ZDEtY2YxMjRlY2U0MmYzIiwic2lkIjoiY2FjOGU5MDYtY2MyZC00MTI5LWI3OWMtNDUzMzJmOGYyMDgwIiwic3ViIjoiMDU0NGYzNjgtZWY0Yi00MzYyLTg5ZmUtMTUxYzYyNjIzZWY0IiwibW9iaWxlX251bWJlciI6Iis5MTk5MDA4ODQ2MjMiLCJuYW1lIjoiU2lkICJ9.0E-P43LFuiq0b_YoWgbHCHbRWkLIIWk7LkOS3FLMAc'
    },
  );
  debugPrint(response.body.toString());
  return FileDetails.fromJson(json.decode(response.body.toString()));
}
