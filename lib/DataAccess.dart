import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'todoItem.dart';

final String todoTable = "TodoItems";

class DataAccess extends ChangeNotifier {
  static final DataAccess _instance = DataAccess._internal();
  Database _db;

  factory DataAccess() {
    return _instance;
  }

  DataAccess._internal();

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "\todo.db";

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $todoTable ( 
            id integer primary key autoincrement, 
            name text not null,
            isComplete integer not null)
            ''');
    });

    // This is just a convenience block to populate the database if it's empty.
    // We likely wouldn't use this in a real application
    if ((await getTodoItems()).length == 0) {
      insertTodo(TodoItem(name: "Todo for test", isComplete: true));
      notifyListeners();
    }
  }

  Future<List<TodoItem>> getTodoItems() async {
    var data = await _db.query(todoTable);
    var result= data.map((d) => TodoItem.fromMap(d)).toList();
    notifyListeners();
    return result;
  }

  Future insertTodo(TodoItem item) {
    return _db.insert(todoTable, item.toMap());
  }

  Future updateTodo(TodoItem item) {
    var result = _db
        .update(todoTable, item.toMap(), where: "id = ?", whereArgs: [item.id]);
    notifyListeners();
    return result;
  }

  Future deleteTodo(TodoItem item) {
    var result= _db.delete(todoTable, where: "id = ?", whereArgs: [item.id]);
    notifyListeners();
    return result;
  }
}
