import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskIsCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ToDoTile(
      {super.key,
      required this.taskName,
      required this.taskIsCompleted,
      required this.onChanged,
      required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              color: taskIsCompleted ? Colors.green.shade100 : Colors.white,
              border: Border.all(width: taskIsCompleted ? 1 : 2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              //chekcbox
              Checkbox(
                  value: taskIsCompleted,
                  activeColor: Colors.black,
                  onChanged: onChanged),
              // Task name
              Flexible(
                child: Text(
                  taskName,
                  style: TextStyle(
                      fontSize: 16,
                      decoration: taskIsCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
