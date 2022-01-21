import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_todo_list/entities/repeat_enum.dart';
import 'package:smart_todo_list/ui/theme.dart';

class Task {

  static List<Color> availableColors = [bluishClr, yellowClr, pinkClr];

  int? id;
  String? title;
  String? note;
  bool? isCompleted;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? indexColor;
  RepeatEnum? repeat;
  int? remind;

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.indexColor,
    this.isCompleted,
    this.remind,
    this.repeat,
  });

  Task.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'] != 0;
    date = DateTime.parse(json['date']);
    startTime = TimeOfDay.fromDateTime(DateTime.parse(json['startTime']));
    endTime = TimeOfDay.fromDateTime(DateTime.parse(json['endTime']));
    indexColor = json['color'];
    remind = json['remind'];
    repeat = RepeatEnum.values[json['repeat'] ?? 0];
  }

  Map<String, dynamic> toJson(){
    var data = <String, dynamic>{};
    var now = DateTime.now();

    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted ?? false? 1 : 0;
    data['date'] = date?.toIso8601String() ?? DateTime.now().toIso8601String();
    data['startTime'] = DateTime(now.year, now.month, now.day, startTime?.hour ?? 0, startTime?.minute ?? 0).toIso8601String();
    data['endTime'] = DateTime(now.year, now.month, now.day, endTime?.hour ?? 0, endTime?.minute ?? 0).toIso8601String();
    data['color'] = indexColor;
    data['repeat'] = repeat?.index;
    data['remind'] = remind;
    return data;
  }

  static String timeOfDayToString(TimeOfDay value){
    return DateFormat('hh:mm a').format(DateTime(0, 1, 1, value.hour, value.minute)).toString();
  }
}