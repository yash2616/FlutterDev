import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/models/task_data.dart';

class BottomModalSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String newTaskTitle;

    return Container(
      height: 600,
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Text(
              "Add Task",
              style: TextStyle(
                fontSize: 25,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              onChanged: (value){
                newTaskTitle = value;
              },
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(height: 30,),
            FlatButton(
              onPressed: (){
                Provider.of<TaskData>(context, listen: false).addTask(newTaskTitle);
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.lightBlueAccent,
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
