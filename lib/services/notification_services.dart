import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  // Кроссплатформенный API, предоставляет абстракцию для всех платформ. Таким образом, конфигурация платформы передается как данные.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initializeNotification() async {
    // Класс для инициализации настроек для устройств Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    // Класс для инициализации настроек для устройств ios
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    // Инициализировать настройки для платформ android и ios
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);


    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Метод для обработки нажатия на уведомление
  Future selectNotification(String? payload) async {
    if (payload == null) {
      log('Notification payload $payload');
    } else {
      log('Notification Done');
    }
    // Пока переход на другую страницу
    Get.to(() => Container(color: Colors.white));
  }

  void onDidReceiveLocalNotification( int id, String? title, String? body, String? payload) async {
    Get.dialog(Text('Hello from IOS Notification'));
  }


  // Прежде чем мы начнем использовать уведомление, мы должны получить разрешение от пользователей в iOS
  void requestIOSPermissions() {
    // Call the requestIOSPermissions() inside your initialize method
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions( alert: true, badge: true, sound: true );
  }

  // Immediate Notification
  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('Channel Id', 'My channel',
      channelDescription: 'Channel for smart ToDo List', importance: Importance.max, priority: Priority.high );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics, payload: 'It could be anything you pass' );
  }
}
