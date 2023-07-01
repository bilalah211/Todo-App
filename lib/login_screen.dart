import 'package:bilalahmedd/signup_screen.dart';
import 'package:bilalahmedd/task_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
            Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(130),
                    )),
                child: Column(
                  children: const [
                    Spacer(),
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
                    ),
                    Spacer(),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFFCDD2),
                        hintText: 'Enter your Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Color(0xFFFFCDD2), width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Color(0xFFFFCDD2), width: 2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off),
                        filled: true,
                        fillColor: Color(0xFFFFCDD2),
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.key,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.redAccent)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none)),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                          )))
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 48),
                        backgroundColor: const Color(0xFFEF5350),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    onPressed: () async {
                      var email = emailController.text;
                      var pass = passController.text;
                      if (email.isEmpty || pass.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Provide Both Values');
                        return;
                      }
                      if (pass.length < 6) {
                        Fluttertoast.showToast(
                            msg:
                                'Weak Password at least 6 digits are required');
                        return;
                      }

                      ProgressDialog progressDialog = ProgressDialog(context,
                          title: const Text('Logging In'),
                          message: const Text('Please Wait'));
                      progressDialog.show();

                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                                email: email, password: pass);
                        if (userCredential.user != null) {
                          Fluttertoast.showToast(msg: 'Login');
                          progressDialog.dismiss();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return const TaskListScreen();
                          }));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(msg: 'Invalid User');
                          progressDialog.dismiss();
                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(msg: 'Wrong Password');
                          progressDialog.dismiss();
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: 'Something Went Wrong');
                        progressDialog.dismiss();
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const SignUpScreen();
                          }));
                        },
                        child: const Text(
                          'Sign Up?',
                          style: TextStyle(color: Colors.redAccent),
                        )),
                  ],
                ),
                const Text(
                  'Or',
                  style: TextStyle(),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.redAccent,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/g.png'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.redAccent,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/f.png'),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.redAccent,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/aa.png'),
                  ),
                ),
              ],
            )
          ])),
        ),
      ),
    );
  }
}
