import 'dart:developer';

import 'package:smart_todo_list/entities/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async{
    if (_db != null) {
      return;
    }
    
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          log("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)",
          );
        }
      );
    } catch (e){
      log(e.toString());
    }
  }

  static Future<int> insert(Task task) async {
    log("insert function ");
    // Возвращает id последней добавленной записи
    return await _db?.insert(_tableName, task.toJson()) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> query() async{
    log("query function called");
    return await _db?.query(_tableName) ?? [];
  }

  static Future<void> delete(Task task) async{
    await _db?.delete(_tableName, where: "id=?", whereArgs: [task.id]);
  }

  static Future<void> updateIsCompletedTask(int idTask, int isCompletedValue) async{
    await _db?.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [isCompletedValue, idTask]);
  }
}