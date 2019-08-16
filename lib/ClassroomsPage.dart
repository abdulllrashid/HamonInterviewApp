import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modelClass/classroomResponse.dart';
import 'dart:convert';
import 'classroomDetailPage.dart';
import 'package:hamon/ApiCredentials.dart';

class classroomsPage extends StatelessWidget {
  //fetche and display's list of classrooms and it's detials'
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Classrooms"),
        ),
        body: FutureBuilder(
          future: fetchSubjectList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: _buildClassroomList(snapshot));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _buildClassroomList(snapshot) {
    //builds classroom list on fetching data from server
    List _classroomList = snapshot.data.classrooms;
    return new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _classroomList.length,
        itemBuilder: (BuildContext context, int index) {
          //returns each classroom details item
          return classroomCardWidget(
              context,
              _classroomList[index].id,
              _classroomList[index].name,
              _classroomList[index].layout,
              _classroomList[index].size);
        });
    //);
  }

  Widget classroomCardWidget(
      //returns each classroom details item
      BuildContext context,
      int id,
      String name,
      String layout,
      int size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => classroomDetailPage(id: id)),
        );
      },
      child: Card(
          child: ListTile(
        leading: Icon(
          Icons.class_,
          size: 30,
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 30,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Row(
          children: <Widget>[Text(layout), Spacer(), Text("Size: $size")],
        ),
      )),
    );
  }

  Future<classroomResponse> fetchSubjectList() async {
    //fetches classroom list from server
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/classrooms/?api_key=$apiKey";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return classroomResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
