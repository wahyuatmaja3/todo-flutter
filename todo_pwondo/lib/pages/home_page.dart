import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_pwondo/data/database.dart';
import 'package:todo_pwondo/util/dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_pwondo/util/my_button.dart';
import 'package:todo_pwondo/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Refference the hive box
  final _myBox = Hive.box('myBox');

  final _controller = TextEditingController();

  ToDoDatabase db = ToDoDatabase();

  List taskCompleted = [];

  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    taskIsCompleted();
    db.updateDatabase();
  }

  void taskCompletedCheckboxChanged(bool? value, int index) {
    setState(() {
      taskCompleted[index][1] = !taskCompleted[index][1];
    });
    taskIsCompleted();
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: InputBorder.none,
                      hintText: "Add new task",
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: saveNewTask,
                  child: Icon(
                    Icons.add,
                  ),
                  minWidth: 50,
                )
              ],
            ),
          ),
        );
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return DialogBox(
    //       controller: _controller,
    //       onSave: saveNewTask,
    //     );
    //   },
    // );
  }

  void deleteTask(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Hapus task"),
            content: new Text(
                "Apakah kamu yakin ingin menghapus ${db.todoList[index][0]}"),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5)),
            actions: <Widget>[
              new MaterialButton(
                child: Text("batal"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new MaterialButton(
                child: new Text("Iya"),
                onPressed: () {
                  setState(() {
                    db.todoList.removeAt(index);
                    db.todoList.removeAt(index);
                  });
                  db.updateDatabase();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void taskIsCompleted() {
    db.todoList.asMap().forEach((index, element) {
      print(element);
      if (element[1] == true) {
        if (!taskCompleted.contains(element)) {
          setState(() {
            taskCompleted.add(element);
          });
        }
      } else if (element[1] == false) {
        setState(() {
          taskCompleted.removeWhere((element) => element[1] == false);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // if this is the 1st time ever opening this app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // There already exist data
      db.loadData();
    }
    taskIsCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Todo',
          style: TextStyle(
              fontFamily: "Lemon tuesday",
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        elevation: 0,
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: db.todoList.length,
            itemBuilder: (context, index) {
              if (db.todoList[index][1] == false) {
                return ToDoTile(
                  taskName: db.todoList[index][0],
                  taskIsCompleted: db.todoList[index][1],
                  onChanged: (value) => checkboxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              } else {
                return Expanded(
                  child: SizedBox(),
                );
              }
            },
          ),
          if (!(taskCompleted.isEmpty)) _taskCompletedHeader(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: taskCompleted.length,
            itemBuilder: (context, index) {
              return ToDoTile(
                taskName: taskCompleted[index][0],
                taskIsCompleted: taskCompleted[index][1],
                onChanged: (value) =>
                    taskCompletedCheckboxChanged(value, index),
                deleteFunction: (context) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: new Text("Hapus task"),
                          content: new Text(
                              "Apakah kamu yakin ingin menghapus ${taskCompleted[index][0]}"),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5)),
                          actions: <Widget>[
                            new MaterialButton(
                              child: Text("batal"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            new MaterialButton(
                              child: new Text("Iya"),
                              onPressed: () {
                                setState(() {
                                  taskCompleted.removeAt(index);
                                });
                                db.updateDatabase();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _taskCompletedHeader() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(
            "Completed",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: Colors.black45,
        ),
      ],
    );
  }
}
