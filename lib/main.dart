import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_todo_list/services/theme_services.dart';
import 'package:smart_todo_list/ui/home_page.dart';
import 'package:smart_todo_list/ui/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart To-Do',
      theme: Themes.light,
      darkTheme: Themes.dart,
      themeMode: ThemeService().themeMode,

      home: const HomePage(),
    );
  }
}
