import 'package:flutter/material.dart';
import 'package:lab3n/StudentModel.dart';
import 'package:lab3n/Database.dart';
import 'dart:math' as math;

import 'package:lab3n/StudentModel.dart';

void main() => runApp(MyApp());

//data for tesitng
  List<Student> testStudents = [
    Student(fio: "Булыгин Андрей Геннадьевич"),
    Student(fio: "Алексеев Никита Евгеньевич"),
    Student(fio: "Геденидзе Давид Темуриевич"),
    Student(fio: "Горак Никита Сергеевич"),
    Student(fio: "Грачев Александр Альбертович"),
    Student(fio: "Гусейнов Илья Алексеев"),
    Student(fio: "Жарикова Екатерина Сергеевна"),
    Student(fio: "Журавлев Владимир Евгеньевич"),
    Student(fio: "Иванов Алексей Дмитриевич"),
    Student(fio: "Копотов Михаил Алеексеевич"),
    Student(fio: "Копташкина Татьяна Алексеевна"),
    Student(fio: "Косогоров Кирилл Станиславович"),
    Student(fio: "Кошкин Артем Сергеевич"),
    Student(fio: "Логецкая Светлана Алекснадровна"),
    Student(fio: "Магомедов Мурад Магамедович"),
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
                  std.fio = "Иванов Иван Иванович";
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
                  title: item.fio != null ? Text(item.fio) : Text("null"),
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