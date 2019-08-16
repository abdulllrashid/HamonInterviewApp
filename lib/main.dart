import 'package:flutter/material.dart';
import 'subjectsPage.dart';
import 'classroomsPage.dart';
import 'studentsPage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Hamon',
    home: HomeScreen(),
    theme: ThemeData(primarySwatch: Colors.green),
  ));
}

class HomeScreen extends StatelessWidget {
  //This widgets shows homescreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Center(
            child: Column(
          //Hamon App Title and cards arranged downwards App title container taking the rest of space what is occupied by cards heights which is half of screen width
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //title widget starts here
            new Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Hamon App",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 36),
                ),
              ),
            ),

//            Cards starts from here
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      homeScreenCard(context, 'Classrooms', classroomsPage())
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      homeScreenCard(context, 'Students', studentsPage()),
                      homeScreenCard(context, 'Subjects', subjectsPage())
                    ],
                  ),
                ],
              ),
            )
          ],
        )));
  }

  Widget homeScreenCard(BuildContext context, String name, targetScreen) {
    //one single card item
    return Expanded(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(2.5),
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 2,
          child: Card(
              elevation: 5.0,
              child: Center(
                  child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ))),
        ),
      ),
    ));
  }
}
