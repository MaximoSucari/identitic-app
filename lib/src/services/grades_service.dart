import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:identitic/src/models/class.dart';
import 'package:identitic/src/models/grade.dart';
import 'package:identitic/src/models/user.dart';
import 'package:identitic/src/services/exceptions.dart';
import 'package:identitic/src/utils/constants.dart';

class GradesService {
  Future<List<Grade>> fetchGrades() async {
    List<Grade> grades;

    const Map<String, String> jsonHeaders = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    try {
      final http.Response response = await http.get(
        '${apiBaseUrl}student/marks/2',
        headers: jsonHeaders,
      );
      switch (response.statusCode) {
        case 200:
          {
            final Iterable<dynamic> list = json.decode(response.body)['data'];
            grades = list.map((e) => Grade.fromJson(e)).toList();
            break;
          }
        case 401:
          throw UnauthorizedException('UnauthorizedException: Voló todo');
        case 429:
          throw TooManyRequestsException('TooManyRequestsException: Voló todo');
      }
    } on SocketException {
      throw const SocketException('SocketException: Voló todo');
    } catch (e) {
      throw Exception(e);
    }
    return grades;
  }

  Future<void> postGrades(User user, List<Grade> grades, Class classs) async {
    Map<String, dynamic> params = {
      "info": <String, dynamic>{
        "id_class": classs.id,
        "id_subject": classs.idSubject,
        "id_teacher": user.id //user.id
      },
      "marks": [
      for (int i = 1; i < grades.length; i++)
      <String, dynamic>{
        "id_student": grades[i].idUser,
        "mark": grades[i].value,
        "term": grades[i].term?? 1,
      },
      ]
     };

    try {
      final http.Response response = await http.post(
          '{$apiBaseUrl}teacher/uploadMark',
          headers: {
            "Content-Type": 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(params)
      );
      debugPrint(json.encode(params));
      debugPrint(response.body);
      switch (response.statusCode) {
        case 200:
          {
            debugPrint(response.body);
            break;
          }
        case 401:
          throw UnauthorizedException('UnauthorizedException: Voló todo');
        case 429:
          throw TooManyRequestsException('TooManyRequestsException: Voló todo');
      }
    } on SocketException {
      throw const SocketException('SocketException: Voló todo');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}