import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFCDD2),
                      hintText: 'Task Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ))),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size(200, 45),
                      backgroundColor: Colors.redAccent,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  onPressed: () {
                    String addTask = taskController.text.trim();
                    int dt = DateTime.now().microsecondsSinceEpoch;
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    var taskRef = FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(uid)
                        .collection('tasks')
                        .doc();

                    taskRef.set({
                      'addTask': addTask,
                      'dt': dt,
                      'taskId': taskRef.id,

                    });

                    Fluttertoast.showToast(msg: 'Task Added');
                    Navigator.of(context).pop();


                  },
                  child: const Text('Add Task')),
            ],
          ),
        ),
      ),
    );
  }
}

