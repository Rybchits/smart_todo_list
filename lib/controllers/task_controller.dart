import 'dart:developer';

import 'package:get/get.dart';
import 'package:smart_todo_list/db/db_helper.dart';
import 'package:smart_todo_list/entities/task.dart';

class TaskController extends GetxController{
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<void> addTask({required Task task}) async{
    int lastId = await DBHelper.insert(task);
    log("Id добавленной записи: $lastId");
  }

  Future<void> getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  Future<void> delete(Task task) async{
    DBHelper.delete(task);
    getTasks();
  }

  Future<void> switchIsCompletedTask(Task task) async{
    if (task.id != null){
      DBHelper.updateIsCompletedTask(task.id!, task.isCompleted ?? false? 0 : 1);
      getTasks();
    }
  }
}