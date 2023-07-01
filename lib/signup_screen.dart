import 'package:bilalahmedd/task_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 29,
          elevation: 0,
          backgroundColor: Colors.redAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(130))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      maxRadius: 35,
                      backgroundImage: AssetImage('images/bilal.png'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Intellilogics',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 388,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFCDD2),
                            hintText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  color: Color(0xFFFFCDD2),
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide.none),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFCDD2),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFCDD2),
                            hintText: 'Password',
                            suffixIcon: Icon(Icons.visibility_off),
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        obscureText: true,
                        controller: confirmPassController,
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFCDD2),
                            hintText: 'Confirm Password',
                            suffixIcon: Icon(Icons.visibility_off),
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 48),
                              backgroundColor: const Color(0xFFEF5350),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)))),
                          onPressed: () async {
                            var fullName = fullNameController.text;
                            var email = emailController.text;
                            var pass = passController.text;
                            var confirmPass = confirmPassController.text;

                            if (fullName.isEmpty ||
                                email.isEmpty ||
                                pass.isEmpty ||
                                confirmPass.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Fill All The Fields');
                              return;
                            }
                            if (pass.length < 6) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Weak Password at least 6 digits are required');
                              return;
                            }
                            if (pass != confirmPass) {
                              Fluttertoast.showToast(
                                  msg: 'Passwords do not match');
                              return;
                            }

                            ProgressDialog progressDialog = ProgressDialog(
                                context,
                                title: Text('Signing Up'),
                                message: Text('Please Wait'));
                            progressDialog.show();

                            try {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              UserCredential userCredential =
                                  await auth.createUserWithEmailAndPassword(
                                      email: email, password: pass);
                              if (userCredential.user != null) {
                                String uid = userCredential.user!.uid;
                                int dt = DateTime.now().microsecondsSinceEpoch;

                                FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                firestore.collection('users').doc(uid).set({
                                  'fullName': fullName,
                                  'email': email,
                                  'uid': uid,
                                  'dt': dt,
                                  'profileImage': 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                                });

                                Fluttertoast.showToast(msg: 'Sign Up');
                                progressDialog.dismiss();
                                Navigator.of(context).pop();
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'email-already-in-use') {
                                Fluttertoast.showToast(
                                    msg: 'Email Already In Use');
                                progressDialog.dismiss();
                              }
                            } catch (e) {}
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(letterSpacing: 2),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
