import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modelClass/classroomDetailsResponse.dart';
import 'dart:convert';
import 'modelClass/classRoomRegistredStudentsResponse.dart';
import 'subjectsPage.dart';
import 'modelClass/subjectsResponse.dart';
import 'modelClass/studentsResponse.dart';
import 'studentsPage.dart';
import 'AddStudentRegistration.dart';
import 'modelClass/AddStudentRegistrationArguments.dart';
import 'package:hamon/ApiCredentials.dart';

class classroomDetailPage extends StatefulWidget {
  final int id;

  const classroomDetailPage({Key key, this.id}) : super(key: key);

  @override
  _classroomDetailPageState createState() => _classroomDetailPageState();
}

class _classroomDetailPageState extends State<classroomDetailPage> {
  //shows classroom details
  //displays registered students list if a subject is assigned to class and if not user can assign a subject to class
  //user can add a new participant here

  //list of subjects from server
  List<Subjects> subjectsList;

  //list of students from server
  List<Students> studentsList;

  //list of registrations from server
  List<Registrations> registeredStudentList;

  //classroom details from server
  classroomDetailsResponse _classroomDetailsResponse;

  Widget build(BuildContext context) {
    //loads classroom details from server and shows it
    return Scaffold(
        appBar: AppBar(
          title: Text("Classrooms"),
        ),
        body: FutureBuilder(
            future: fetchClassroomData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _classroomDetailsResponse = snapshot.data;
                return Center(
                  child: _buildClassroomDetails(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Center(child: CircularProgressIndicator());
              }
              //return _buildClassroomDetails(snapshot);
            }));
  }

  Widget _buildClassroomDetails() {
    //when data from server is fetched this widgets populates it in screen
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //shows classroom name
          _nameWidget(_classroomDetailsResponse.name),

          //divider for UI enhancments
          customeDividerWidget(),

          //shows classroom layout type
          _layoutTypeWidget(_classroomDetailsResponse.layout),

          //shows size of the classroom
          _sizeWidget(_classroomDetailsResponse.size),

          //shows subjects details
          //asks user to assign a subject if it'snt assigned yet
          //shows participants if a subject is already assigned
          _subjectWidget(_classroomDetailsResponse.subject),
        ],
      ),
    );
  }

  Widget customeDividerWidget() {
    //simple divider with a padding wrapped
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Colors.black54,
      ),
    );
  }

  Widget _buildClassroomParticipantsList(int subjectId) {
    //fetch data and builds classroom participants list if a subject is assigned to this class already
    registeredStudentList = new List();
    return FutureBuilder(
        future: fetchRegisteredParticipantsData(), //fetching data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            registeredStudentList = snapshot.data.registrations;
            //filtering the students that is registered for this subject inorder to show user from a list of all registrations
            registeredStudentList.retainWhere(
                (registration) => registration.subject == subjectId);
            //checks if there are registrations or not
            if (registeredStudentList.length != 0) {
              //show registrations if there are registrations
              return _participantsListWidget(registeredStudentList);
            } else
              //telling user there are no registrations
              return Expanded(
                  child: Center(child: Text("No particpants registered")));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _nameWidget(name) {
    //Dispays name of the classroom
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w400, color: Colors.green),
      ),
    );
  }

  Widget _subjectWidget(subjectId) {
    //checks if a subject is assigned or not
    if (subjectId == -1) {
      //telling user to assign a widget
      return _addSubjectWidget();
    } else
      //showing user subject, students registered and as well as add new registrations
      return _showAndChangeSubjectWidget(subjectId);
  }

  Widget _layoutTypeWidget(layout) {
    //shows user layout type of the classroom
    return ListTile(
        leading: (Icon(
          Icons.title,
          color: Colors.green,
          size: 25,
        )),
        title: Text(
          layout,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        subtitle: Text("Type"));
  }

  Widget _sizeWidget(size) {
    //shows the size of the classroom
    return ListTile(
        leading: (Icon(
          Icons.event_seat,
          color: Colors.green,
          size: 25,
        )),
        title: Text(
          size.toString(),
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        subtitle: Text("Size"));
  }

  Widget _participantsListWidget(_registeredStudentsList) {
    //shows participants list

    return new Expanded(
      //creates list
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _registeredStudentsList.length,
          itemBuilder: (BuildContext context, int index) {
            //returns each list item
            return Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                    getStudent(_registeredStudentsList[index].student).name),
                trailing: GestureDetector(
                  onTap: (() {
                    _deleteParticipantDialog(_registeredStudentsList[index].id);
                  }),
                  child: Icon((Icons.delete), color: Colors.red),
                ),
              ),
            );
          }),
    );
  }

  Widget _addSubjectWidget() {
    //user can assign new registrations on taping this
    //tells user no subjects are assigned
    return Expanded(
        child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: _addSubjectDialog,
          child: ListTile(
            leading: Icon(
              Icons.add_circle,
              size: 30,
              color: Colors.red,
            ),
            title: Text(
              "Add Subject",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        ),
        customeDividerWidget(),
        Expanded(
            child: Center(child: Text("Add a subject to View/Add particpants")))
      ],
    ));
  }

  Widget _showAndChangeSubjectWidget(subjectId) {
    //displays subject assigned
    //users can edit their assignments on clicking
    //displays participants list if it not nul
    //asks user to add participants if it's null
    //dispays widget for adding new user
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //displays subject name & edit icon
        ListTile(
            leading: Icon(Icons.subject, size: 25, color: Colors.green),
            title: Text(
              getSubject(subjectId).name,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                _addSubjectDialog();
              },
              child: Icon(
                Icons.edit,
              ),
            ),
            subtitle: Text("Subject")),
        customeDividerWidget(),
        //widget to add a new participant
        ListTile(
          onTap: () {
            addParticipant(
              getSubject(subjectId).id,
            );
          },
          trailing: Icon(
            Icons.add_circle,
            size: 30,
            color: Colors.green,
          ),
          title: Text(
            "Add participant",
            style: TextStyle(fontSize: 20),
          ),
        ),
        //divider
        customeDividerWidget(),
        //title for participants list
        Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Text(
            "Participants",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        //shows participants list for this subject
        _buildClassroomParticipantsList(subjectId),
      ],
    ));
  }

  Future<List> getSubjectsList() async {
    //fetches subject list from server
    subjectsResponse _sr = await subjectsPage().fetchSubjectList();
    List l = _sr.subjects;
    return l;
  }

  Future<List> getStudentList() async {
    //fetches student list from server
    studentsResponse _sr = await studentsPage().fetchStudentsList();
    List l = _sr.students;
    return l;
  }

  Future<classroomDetailsResponse> fetchClassroomData() async {
    //fetches classroom details
    subjectsList = await getSubjectsList();
    studentsList = await getStudentList();
    int _id = widget.id;
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/classrooms/$_id?api_key=$apiKey";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return classroomDetailsResponse.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<classRoomRegistredStudentsResponse>
      fetchRegisteredParticipantsData() async {
    //fetches registrations from server
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/registration/?api_key=$apiKey";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return classRoomRegistredStudentsResponse
          .fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<int> deleteRegisteredItem(int _id) async {
    //deletes a registration

    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/registration/$_id?api_key=$apiKey";

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return 1;
//      response.body;

    } else {
      // If that response was not OK, throw an error.

      throw Exception('Failed to load post');
    }
  }

  _addSubjectDialog() {
    //assigning a subject to classroom in a dialogue box with a dropdown menu of subjects
    //TODO: show a selected value if there is subject already assigned
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Subjects _selectedValue;
          bool loading = false;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Choose a subject"),
                //displays dropdown menu with subjects
                content: SingleChildScrollView(
                  child: new DropdownButton<Subjects>(
                    isExpanded: true,
                    hint: Text('Please choose a value'),
                    items: subjectsList.map((Subjects value) {
                      return new DropdownMenuItem<Subjects>(
                        value: value,
                        child: new Text(value.name),
                      );
                    }).toList(),
                    onChanged: (_val) {
                      setState(() {
                        _selectedValue = _val;
                      });
                    },
                    value: _selectedValue,
                  ),
                ),
                //cancel button
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  //submit button to change assignment
                  FlatButton(
                    child: Text('SUBMIT'),
                    onPressed: () {
                      //saves change in server
                      _postSubject(_selectedValue.id.toString()).then((v) {
                        //closes dialogue
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  _deleteParticipantDialog(_id) {
    //confirms deletion of a participant and deletes it from server
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Subjects _selectedValue;
          bool loading = false;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.red),
                ),
                content:
                    Text("Are you sure you want to remove this participant?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'NO',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'YES',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      //deletes from server
                      deleteRegisteredItem(_id).then((value) {
                        //closes pop up
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  Future<int> _postSubject(_id) async {
    //add/edit the subject value in server for this classroom
    int classroomId = widget.id;
    String apiKey = ApiCredentials().getApiKey();
    String apiUrl = ApiCredentials().getapiUrl();
    String url = "$apiUrl/classrooms/$classroomId?api_key=$apiKey";

    var _body = {
      "subject": _id,
    };

    final response = await http.patch(url, body: _body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return 1;
//      response.body;

    } else {
      // If that response was not OK, throw an error.

      throw Exception('Failed to load post');
    }
  }

  Subjects getSubject(int _id) {
    //takes subject id and gives back respected subject details
    List l = new List();
    l.addAll(subjectsList);
    l.retainWhere((s) => s.id == _id);
    return l[0];
  }

  Students getStudent(int _id) {
    //takes student id and gives back respected student details
    List l = new List();
    l.addAll(studentsList);
    l.retainWhere((s) => s.id == _id);
    return l[0];
  }

  void addParticipant(int _subjectId) {
    //takes to new screen from where he can add a new participant
    //passes unregistered students list and subject id of this class to next screen
    AddStudentRegistrationArguments addStudentRegistrationArguments =
        new AddStudentRegistrationArguments(
            _subjectId, getUnregisteredStudents());

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddStudentRegistration(
                addStudentRegistrationArguments:
                    addStudentRegistrationArguments,
              )),
    );
  }

  List<Students> getUnregisteredStudents() {
    //filter's unregistered students from all students list
    List<Students> unregisteredStudentsList = new List();
    unregisteredStudentsList.addAll(studentsList);
    registeredStudentList.forEach((student) {
      unregisteredStudentsList.remove(getStudent(student.student));
    });
    return unregisteredStudentsList;
  }
}
