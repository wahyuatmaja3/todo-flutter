import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  // Refference our box
  final _myBox = Hive.box('myBox');

  List todoList = [];

  // Run this method if this is the 1st time ever opening this app
  void createInitialData() {
    todoList = [
      ['Do amazing things', false],
      ['Upload Flutter assignment', true],
    ];
  }

  // Load the data from database
  void loadData() {
    todoList = _myBox.get('TODOLIST');
  }

  // update the database
  void updateDatabase() {
    _myBox.put("TODOLIST", todoList);
  }
}
