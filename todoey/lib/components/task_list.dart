import 'package:flutter/material.dart';
import 'package:todoey/components/task_tile.dart';
import 'package:todoey/models/task_data.dart';
import 'package:provider/provider.dart';


class TaskList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child){
        return ListView.builder(
          itemBuilder: (context, index){
            final currentTask = taskData.tasks[index];
            return TaskTile(
              taskTitle: currentTask.name,
              isChecked: currentTask.isDone,
              checkBoxToggle: (value){
                taskData.updateTask(currentTask);
              },
              longPressHold: (){
                taskData.deleteTask(currentTask);
              },
            );
          },
          itemCount: taskData.tasks.length,
        );
      },
    );
  }
}