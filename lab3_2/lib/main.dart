import 'package:flutter/material.dart';
import 'package:lab3_2/StudentModel.dart';
import 'package:lab3_2/Database.dart';
import 'dart:math' as math;

import 'package:lab3_2/StudentModel.dart';

void main() => runApp(MyApp());

//data for tesitng
  List<Student> testStudents = [
    Student(firstName: "Андрей", lastName: "Булыгин", middleName: "Геннадьевич"),
    Student(firstName: "Никита", lastName: "Алексеев", middleName: "Евгеньевич"),
    Student(firstName: "Давид", lastName: "Геденидзе", middleName: "Темуриевич"),
    Student(firstName: "Никита", lastName: "Горак", middleName: "Сергеевич"),
    Student(firstName: "Александр", lastName: "Грачев", middleName: "Альбертович"),
    Student(firstName: "Илья", lastName: "Гусейнов", middleName: "Алексеев"),
    Student(firstName: "Екатерина", lastName: "Жарикова", middleName: "Сергеевна"),
    Student(firstName: "Владимир", lastName: "Журавлев", middleName: "Евгеньевич"),
    Student(firstName: "Алексей", lastName: "Иванов", middleName: "Дмитриевич"),
    Student(firstName: "Михаил", lastName: "Копотов", middleName: "Алеексеевич"),
    Student(firstName: "Татьяна", lastName: "Копташкина", middleName: "Алексеевна"),
    Student(firstName: "Кирилл", lastName: "Косогоров", middleName: "Станиславович"),
    Student(firstName: "Артем", lastName: "Кошкин", middleName: "Сергеевич"),
    Student(firstName: "Светлана", lastName: "Логецкая", middleName: "Алекснадровна"),
    Student(firstName: "Мурад", lastName: "Магомедов", middleName: "Магамедович"),
  ];

_showDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

_addingRows() async {
  for (var i=0; i<5; i++) {
    Student std = testStudents[math.Random().nextInt(testStudents.length)];
    await DBProvider.db.newRow(std);
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBProvider.db.deleteAll();
     _addingRows();
    return MaterialApp(
      title: 'DEMO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
        home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database test"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text("List of students"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                      PageList(),
                  ),
                );
              },
            ),
            RaisedButton(
              child: Text("Add student"),
              onPressed: () async {
                Student std = testStudents[math.Random().nextInt(testStudents.length)];
                await DBProvider.db.newRow(std);
                _showDialog(context, "Information", "Student was added");
              },
            ),
            RaisedButton(
              child: Text('Change last row'),
              onPressed: () async {
                int id = await DBProvider.db.findMaxID();
                Student std = await DBProvider.db.getRow(id);
                if (std != null) {
                  std.firstName = "Иван";
                  std.lastName = "Иванов";
                  std.middleName = "Иванович";
                  DBProvider.db.updateRow(std);
                  _showDialog(context, "Info", "Last row in the list have been updated");
                }
                else _showDialog(context, "Error", "List is empty");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageList extends StatefulWidget {
  @override
  _PageListState createState() => _PageListState();
}

class _PageListState extends State<PageList> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQFlite"),),
      body:  FutureBuilder<List<Student>>(
        future: DBProvider.db.getAllRows(),
        builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toList());
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Student item = snapshot.data[index];
                return ListTile(
                  title: item.firstName != null ? Text(item.firstName + " " + item.lastName + " " + item.middleName) : Text("null"),
                  leading: Text(item.id.toString()),
                  trailing: Text(item.time),
                  );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

