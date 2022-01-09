import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_todo_list/services/notification_services.dart';
import 'package:smart_todo_list/services/theme_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotificationService notifyHelper;

  @override
  void initState() {
    notifyHelper = NotificationService()..initializeNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const Center(child: Text("Center")),
    );
  }

  _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: 'Тема приложения была изменена!',
              body: Get.isDarkMode? 'Была активирована светлая тема!' : 'Была активирована темная тема!');
        },
        child: const Icon(Icons.nightlight_round, size: 20),
      ),
      actions: const [
        Icon(Icons.person, size: 20),
        SizedBox(width: 20)
      ],
    );
  }
}
