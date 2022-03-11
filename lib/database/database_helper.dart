import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class DatabaseHelper {
  static DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  Database? _database;

  final String tableName = "NoteTable";
  final String _columnId = "ID";
  final String _columnTitle = "Title";
  final String _columnText = "Text";
  final int _version = 1;

  Future<Database> get database async {
    if (_database != null) _database!;
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "notes.db");
    return await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE $tableName ( 
              $_columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $_columnTitle TEXT, 
              $_columnText TEXT 
              )''');
      },
    );
  }

  Future<List<Map<String, Object?>>> readAllData() async {
    Database db = await DatabaseHelper.instance.database;
    return await db.query(tableName);
  }

  Future<void> insertData(String title, String text) async {
    Database db = await DatabaseHelper.instance.database;
    db.insert(tableName, {_columnTitle: title, _columnText: text});
  }

  deleteAllData() async {
    Database db = await DatabaseHelper.instance.database;
    db.delete(tableName);
    db.execute(
        "UPDATE SQLITE_SEQUENCE SET SEQ= '$_columnId' WHERE NAME='$tableName'");
  }

  updateData(int? id, String text, String title) async {
    if (id == null) {
      print("Id number can't be null!");
    } else {
      Database db = await DatabaseHelper.instance.database;
      await db.execute(
          "UPDATE $tableName SET $_columnText = $text, $_columnTitle = $title WHERE $_columnId = $id");
    }
  }

  rawQuery(int i) async {
    Database db = await DatabaseHelper.instance.database;
    var table = await db.rawQuery(
        "SELECT $_columnTitle AS title FROM $tableName WHERE $_columnId = $i");
    var title = table[0].values.toString();
    title = title.replaceAll(title[0], "");
    title = title.replaceAll(title[title.length - 1], "");
    // Brackets which are on first index and last index in the title has been deleted.
    return title;
  }

  Future<String> lastId() async {
    Database db = await DatabaseHelper.instance.database;
    var table =
        await db.rawQuery("SELECT MAX($_columnId) AS id FROM $tableName");
    var lastId = table.last["id"];

    return lastId.toString();
  }
}
