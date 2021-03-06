import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:identitic/src/models/class.dart';

import 'package:identitic/src/models/event.dart';
import 'package:identitic/src/models/user.dart';
import 'package:identitic/src/services/exceptions.dart';
import 'package:identitic/src/utils/constants.dart';

class EventsService {

  Future<List<Event>> fetchEvents() async {
    List<Event> events;

    const Map<String, String> jsonHeaders = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    try {
      final http.Response response = await http.get(
        '${apiBaseUrl}teacher/events/5',
        headers: jsonHeaders,
      );
      switch (response.statusCode) {
        case 200:
          {
            final Iterable<dynamic> list = json.decode(response.body)['data'];
            events = list.map((e) => Event.fromJson(e)).toList();
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
    return events;
  }

  Future<List<Event>> fetchAllEvents(int idClass) async {
    List<Event> allEvents;

    const Map<String, String> jsonHeaders = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    try {
      final http.Response response = await http.get(
        '${apiBaseUrl}teacher/AllEvents/1',
        headers: jsonHeaders,
      );
      switch (response.statusCode) {
        case 200:
          {
            final Iterable<dynamic> list = json.decode(response.body)['data'];
            allEvents = list.map((e) => Event.fromJson(e)).toList();
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
    return allEvents;
  }

  Future<void>postEvent(User user, Event event, Class classs) async {
    const Map<String, String> jsonHeaders = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    try {
      final http.Response response = await http.post(
        '${apiBaseUrl}teacher/postevent',
        headers: jsonHeaders,
        body: jsonEncode({
          'id_class': classs.id,
          'id_user': user.id,
          'id_subject': classs.idSubject,
          'date': event.date,
          'title': event.title,
          'ds_event': event.description,
          'event_category_id_category': event.idCategory,
        }
      ));
      debugPrint(response.body);
      switch (response.statusCode) {
        case 200:
          debugPrint(response.body);
          break;
        case 401:
          debugPrint(response.body);
          throw UnauthorizedException('UnauthorizedException: Voló todo');
        case 429:
          debugPrint(response.body);
          throw TooManyRequestsException('TooManyRequestsException: Voló todo');
      }
    } on SocketException {
      throw const SocketException('SocketException: Voló todo');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
