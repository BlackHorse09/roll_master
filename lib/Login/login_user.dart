import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roll_master/HomePage/HomePageUser.dart';
import 'package:roll_master/Registration/register_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffb2d9ea),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[
                        Text("LOGIN", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),
                        SizedBox(height: 36,),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 6),
                                border: InputBorder.none,
                                labelStyle: TextStyle(color: Colors.black),
                                labelText: 'Email*', hintText: "john.doe@gmail.com"),
                            controller: emailInputController,
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                          ),
                        ),
                        SizedBox(height: 16,),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 6),
                                border: InputBorder.none,
                                labelStyle: TextStyle(color: Colors.black),
                                labelText: 'Password*', hintText: "********"),
                            controller: pwdInputController,
                            obscureText: true,
                            validator: pwdValidator,
                          ),
                        ),
                        SizedBox(height: 16,),

                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (_loginFormKey.currentState.validate()) {
                                UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailInputController.text, password: pwdInputController.text);
                                if(result.user != null) {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("id", result.user.uid);
                                  Navigator.pushReplacement(context, PageRouteBuilder(
                                    settings: RouteSettings(name: '/home_page'),
                                    pageBuilder: (c, a1, a2) => HomePageUser(
                                      id: result.user.uid,
                                    ),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(opacity: anim, child: child),
                                    transitionDuration: Duration(milliseconds: 500),
                                  ),);
                                } else {

                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text("LOGIN", style: TextStyle(color: Colors.black, fontSize: 18),),
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
                        Text("Don't have an account yet?"),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterUser()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text("Register Here", style: TextStyle(color: Colors.black, fontSize: 18),),
                          ),
                        )
                      ],
                    ),
                  )))),
    );
  }
}