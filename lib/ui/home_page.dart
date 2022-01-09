import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(child: Text("Center")),
    );
  }

  _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: GestureDetector(
        onTap: (){
          log('ThemeMode changed');
        },
        child: Icon(Icons.nightlight_round, size: 20),
      ),
      actions: [
        Icon(Icons.person, size: 20),
        SizedBox(width: 20)
      ],
    );
  }
}
