import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modelClass/AddStudentRegistrationArguments.dart';
import 'package:hamon/ApiCredentials.dart';

class AddStudentRegistration extends StatefulWidget {
  final AddStudentRegistrationArguments addStudentRegistrationArguments;
  const AddStudentRegistration({Key key, this.addStudentRegistrationArguments})
      : super(key: key);

  @override
  _AddStudentRegistrationState createState() => _AddStudentRegistrationState();
}

class _AddStudentRegistrationState extends State<AddStudentRegistration> {
//  receives unregistered students list as well as subject id from prevoius page
//widgets displays students list and on selecting any one of them it's saved to server
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose a student"),
        ),
        body: Center(
            child: _buildSubjectList(
                widget.addStudentRegistrationArguments.studentsList)));
  }

  Widget _buildSubjectList(_studentsList) {
//    creates a listview from students list
    return new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _studentsList.length,
        itemBuilder: (BuildContext context, int index) {
          return studentCard(_studentsList[index].id, _studentsList[index].name,
              _studentsList[index].email, _studentsList[index].age);
        });
    //);
  }

  Widget studentCard(int id, String name, String email, int age) {
    //Card that displays one value of list
    return Card(
        child: ListTile(
      onTap: () {
        postStudentRegistration(id.toString()).then((value) {
          Navigator.of(context).pop();
        });
      },
      leading: Icon(
        Icons.person_add,
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

  Future<int> postStudentRegistration(String _studentId) async {
    //adds a new registration in server
    String _subjectId =
        widget.addStudentRegistrationArguments.subjectId.toString();
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String _url = "$apiUrl/registration/?api_key=$apiKey";
    var _body = {
      "subject": _subjectId,
      "student": _studentId,
    };
    final response = await http.post(_url, body: _body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return 1;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
