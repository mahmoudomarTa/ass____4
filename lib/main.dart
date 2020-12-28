import 'package:ass_4/DataAccess.dart';
import 'package:ass_4/my_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todoListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return DataAccess();
      },
      child: MaterialApp(
        title: 'Todo Flutter',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoListScreen(title: 'Todo List'),
      ),
    );
  }
}