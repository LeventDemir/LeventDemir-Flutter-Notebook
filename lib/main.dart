import 'package:flutter/material.dart';
import 'package:notebook/pages/update.note.dart';
import './pages/home.dart';
import 'package:notebook/pages/create-note.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/create-note': (context) => CreateNote(),
        '/update-note': (context) => UpdateNote(),
      },
    );
  }
}
