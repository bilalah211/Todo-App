import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateTask extends StatefulWidget {
  final DocumentSnapshot task;

  const UpdateTask({Key? key, required this.task}) : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  var updateTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();

    updateTaskController.text = widget.task['addTask'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                  controller: updateTaskController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFCDD2),
                      hintText: 'Update Task',
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
                    String addTask = updateTaskController.text.trim();

                    widget.task.reference.update({
                      'addTask': addTask,
                    });
                    Navigator.of(context).pop();

                  },
                  child: const Text('Update Task')),
            ],
          ),
        ),
      ),
    );
  }
}
