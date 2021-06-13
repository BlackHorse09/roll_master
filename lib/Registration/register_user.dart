import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roll_master/HomePage/HomePageUser.dart';
import 'package:roll_master/Login/login_user.dart';
import 'package:roll_master/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
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
          key: scaffoldKey,
          backgroundColor: Color(0xfff4dcd6),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SingleChildScrollView(
                  child: Form(
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                    Text("SIGN UP", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),
                    SizedBox(height: 36,),
                    Container(
                      color: Colors.white,
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6),
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'First Name*', hintText: "John"),
                        controller: firstNameInputController,
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid first name.";
                          } else {
                            return null;
                          }
                        },
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
                              labelText: 'Last Name*', hintText: "Doe"),
                          controller: lastNameInputController,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid last name.";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    SizedBox(height: 16,),
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
                          closeKeyboard();
                          if (_registerFormKey.currentState.validate()) {
                            UserCredential result;
                            _showLoading(context);
                            try {
                              result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailInputController.text, password: pwdInputController.text);
                              if(result != null) {
                                Navigator.pop(context);
                                await FirebaseFirestore.instance.collection("$prod_user_doc").doc(result.user.uid).set({
                                  "uid": result.user.uid,
                                  "fname": firstNameInputController.text,
                                  "lname": lastNameInputController.text,
                                  "email": emailInputController.text,
                                  "password": pwdInputController.text,
                                  "total_chance": 10,
                                  "total_score": 0,
                                  "played_once" : false
                                });
                               firstNameInputController.clear();
                               lastNameInputController.clear();
                               emailInputController.clear();
                               pwdInputController.clear();
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("id", result.user.uid);
                               Navigator.push(context, PageRouteBuilder(
                                 settings: RouteSettings(name: '/home_page'),
                                 pageBuilder: (c, a1, a2) => HomePageUser(
                                   id: result.user.uid,
                                 ),
                                 transitionsBuilder: (c, anim, a2, child) =>
                                     FadeTransition(opacity: anim, child: child),
                                 transitionDuration: Duration(milliseconds: 500),
                               ),);
                              } else {
                                Navigator.pop(context);
                              }
                            } on FirebaseAuthException catch (error) {
                              Navigator.pop(context);
                              showCustomSnackBar(error.message);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("REGISTER", style: TextStyle(color: Colors.black, fontSize: 18),),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text("Already have an account?"),
                    SizedBox(height: 16,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageRouteBuilder(
                          settings: RouteSettings(name: '/login'),
                          pageBuilder: (c, a1, a2) => LoginPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 500),
                        ),);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("Login Here", style: TextStyle(color: Colors.black, fontSize: 18),),
                      ),
                    ),
                  ],
                ),
              )))),
    );
  }

  closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            //contentPadding: const EdgeInsets.only(left : 16, right: 0, top: 10, bottom: 10),
            content: Container(
              width: 200,
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                  ),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        }); //end showDialog()
  }

  showCustomSnackBar(String message) {
    final snackBar = SnackBar(content: Text("$message"));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

}
