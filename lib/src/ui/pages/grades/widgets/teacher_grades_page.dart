import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:identitic/src/models/class.dart';
import 'package:identitic/src/models/student.dart';
import 'package:identitic/src/models/grade.dart';
import 'package:identitic/src/models/user.dart';
import 'package:identitic/src/providers/auth_provider.dart';
import 'package:identitic/src/providers/grades_provider.dart';
import 'package:identitic/src/ui/pages/grades/widgets/grade_list_tile.dart';
import 'package:identitic/src/ui/widgets/identitic_container.dart';
import 'package:identitic/src/utils/constants.dart';
import 'package:identitic/src/services/exceptions.dart';
import 'package:provider/provider.dart';

class TeacherGradesPage extends StatelessWidget {
  TeacherGradesPage(this.classs);

  final Class classs;

  final List<Grade> grades = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificaciones', style: TextStyle(fontSize: 16),),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Student>>(
        future: _fetchStudents(),
        builder: (_, AsyncSnapshot<List<Student>> snapshot) {
          final List<Student> students = snapshot.data;
          if (snapshot.hasData) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, int i) {
                return SizedBox(height: 8);
              },
              itemCount: students.length,
              itemBuilder: (_, int i) {
                return IdentiticContainer(
                  child: GradeListTile(students[i], grades[i]),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _postGrades(
            context,
            Provider.of<AuthProvider>(context, listen: false).user,
            grades,
            classs),
        label: Row(
          children: <Widget>[
            Icon(Icons.send),
            SizedBox(width: 8),
            Text('Enviar'),
          ],
        ),
      ),
    );
  }

  Future<List<Student>> _fetchStudents() async {
    List<Student> students;

    const Map<String, String> jsonHeaders = <String, String>{
      "Content-Type": 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final http.Response response = await http.get(
        '${apiBaseUrl}teacher/class/${this.classs.id}',
        headers: jsonHeaders,
      );
      switch (response.statusCode) {
        case 200:
          {
            final Iterable<dynamic> list = json.decode(response.body)['data'];
            students = list.map((e) {
              final Student student = Student.fromJson(e);
              grades.add(Grade(idUser: student.idStudent));
              return student;
            }).toList();
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
    return students;
  }

  void _postGrades(
      BuildContext context, User user, List<Grade> grades, Class classs) async {
    await Provider.of<GradesProvider>(context, listen: false)
        .postGrades(user, grades, classs);
    Navigator.pop(context);
  }
}
