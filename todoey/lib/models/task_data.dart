import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:todoey/models/task.dart';

class TaskData extends ChangeNotifier{

  List<Task> tasks = [
    Task(name: "Task 1"),
    Task(name: "Task 2"),
    Task(name: "Task 3"),
    Task(name: "Task 4"),
  ];

  void addTask(String newTaskTitle){
    tasks.add(Task(name: newTaskTitle));
    notifyListeners();
  }

  void updateTask(Task task){
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task){
    this.tasks.remove(task);
    notifyListeners();
  }

}