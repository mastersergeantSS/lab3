import 'dart:io';
import 'package:path/path.dart';
import 'StudentModel.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instatiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "lab3.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
    onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Students ("
      "id INTEGER PRIMARY KEY,"
      "FIO TEXT,"
      "time TEXT"
      ")");
    }
    );
  }

  findMaxID() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) as id FROM Students");
    int id = table.first["id"];
    if (id == null) id = 0;
    return id;
  }

  newRow(Student newStudent) async {
    final db = await database;
    //get the biggest id in the table
    int id = await findMaxID();
    var time = DateTime.now();
    var formatter = new DateFormat('H:m dd MMMM');
    String formattedTime = formatter.format(time);
    //insert to the table using the new id
    var raw = await db.rawInsert(
      'INSERT Into Students (id,FIO,time) VALUES (?,?,?)',
      [id+1, newStudent.fio, formattedTime]);
    print(raw);
    return raw;
  }

  getRow(int id) async {
    final db = await database;
    var res = await db.query("Students", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Student.fromMap(res.first) : null;
  }

  Future<List<Student>> getAllRows() async {
    final db = await database;
    var res = await db.query("Students");
    List<Student> list =
      res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  getBlockedRows() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Students WHERE blocked=1");
    List<Student> list = 
      res.isNotEmpty ? res.toList().map((c) => Student.fromMap(c)) : null;
    return list;
  }

  updateRow(Student newStudent) async {
    final db = await database;
    var res = await db.update("Students", newStudent.toMap(),
      where: "id = ?", whereArgs: [newStudent.id]);
    print(res);
    return res;
  }


  deleteRow(int id) async {
    final db = await database;
    db.delete("Students", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.delete("Students");
  }


}