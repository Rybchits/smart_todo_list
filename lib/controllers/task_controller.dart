import 'dart:developer';

import 'package:get/get.dart';
import 'package:smart_todo_list/db/db_helper.dart';
import 'package:smart_todo_list/entities/task.dart';

class TaskController extends GetxController{
  @override
  void onReady() {
    super.onReady();
  }

  Future<void> addTask({required Task task}) async{
    int lastId = await DBHelper.insert(task);
    log("Id добавленной записи: $lastId");
  }
}