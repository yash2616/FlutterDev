import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {

  TaskTile({this.taskTitle, this.isChecked, this.checkBoxToggle, this.longPressHold});

  final bool isChecked;
  final String taskTitle;
  final Function checkBoxToggle;
  final Function longPressHold;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressHold,
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkBoxToggle,
      ),
    );
  }
}