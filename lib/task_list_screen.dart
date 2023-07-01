import 'package:bilalahmedd/add_task_screen.dart';
import 'package:bilalahmedd/login_screen.dart';
import 'package:bilalahmedd/profile_screen.dart';
import 'package:bilalahmedd/update_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  CollectionReference? taskRef;

  @override
  void initState() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    taskRef = FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('tasks');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const AddTaskScreen();
            }));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('Welcome'),
          actions: [
            IconButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return const ProfileScreen();
              }));
            }, icon: const Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: (context),
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure to logout?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                                },
                                child: Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: taskRef!.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No Task Yet!'));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index]['addTask']),
                          subtitle:
                              Text(humanReadable(snapshot.data!.docs[index]['dt'])),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                      return UpdateTask(task: snapshot.data!.docs[index]);
                                    }));
                                  }, icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Confirmation'),
                                            content:
                                                Text('Are you sure to delete'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    if (taskRef != null) {
                                                      taskRef!
                                                          .doc(snapshot.data!
                                                                  .docs[index]
                                                              ['taskId'])
                                                          .delete();
                                                    }
                                                  },
                                                  child: Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('No'))
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      );
                    });
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
  String humanReadable (int dt){
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy hh:mm a');
    String str = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(dt));
    return str;
  }
}
