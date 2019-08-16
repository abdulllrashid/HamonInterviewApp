import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modelClass/subjectsResponse.dart';
import 'dart:convert';
import 'package:hamon/ApiCredentials.dart';

class subjectsPage extends StatelessWidget {
  //fetch and disiplay subject list
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Subjects"),
        ),
        body: FutureBuilder(
          future: fetchSubjectList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: _buildSubjectList(snapshot));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _buildSubjectList(snapshot) {
    //display subject list
    List _subjectsList = snapshot.data.subjects;
    return new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _subjectsList.length,
        itemBuilder: (BuildContext context, int index) {
          //return one item of list
          return subjectCard(_subjectsList[index].id, _subjectsList[index].name,
              _subjectsList[index].teacher, _subjectsList[index].credits);
        });
    //);
  }

  Widget subjectCard(
      //return one item of widget in card with all details
      int id,
      String subjectName,
      String teacherName,
      int credits) {
    return Card(
        child: ListTile(
      leading: Icon(
        Icons.subject,
        size: 30,
      ),
      title: Text(
        subjectName,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(teacherName),
          Spacer(),
          Text("Credits: $credits")
        ],
      ),
    ));
  }

  Future<subjectsResponse> fetchSubjectList() async {
    //fetch data from server
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/subjects/?api_key=$apiKey";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return subjectsResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
