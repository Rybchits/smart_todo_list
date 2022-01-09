import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_todo_list/ui/home_page.dart';
import 'package:smart_todo_list/ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart To-Do',
      theme: Themes.light,
      darkTheme: Themes.dart,
      themeMode: ThemeMode.light,

      home: const HomePage(),
    );
  }
}
