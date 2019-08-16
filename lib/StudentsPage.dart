import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modelClass/studentsResponse.dart';
import 'dart:convert';
import 'package:hamon/ApiCredentials.dart';

class studentsPage extends StatelessWidget {
  //fetches and displays students list
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Students"),
        ),
        body: FutureBuilder(
          future: fetchStudentsList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: _buildStudentsList(snapshot));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _buildStudentsList(snapshot) {
    //display's student list
    List _studentsList = snapshot.data.students;
    return new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _studentsList.length,
        itemBuilder: (BuildContext context, int index) {
          //returns a widget item display one item of list
          return studentCardWidget(
              _studentsList[index].id,
              _studentsList[index].name,
              _studentsList[index].email,
              _studentsList[index].age);
        });
    //);
  }

  Widget studentCardWidget(int id, String name, String email, int age) {
    //returns a card item display one item of list
    return Card(
        child: ListTile(
      leading: Icon(
        Icons.person,
        size: 30,
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      subtitle: Row(
        children: <Widget>[Text(email), Spacer(), Text("Age: $age")],
      ),
    ));
  }

  Future<studentsResponse> fetchStudentsList() async {
    //fetches list data from server
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/students/?api_key=$apiKey";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return studentsResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
