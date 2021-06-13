import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roll_master/HomePage/HomePageUser.dart';
import 'package:roll_master/Login/login_user.dart';

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
                        onTap: () {
                          closeKeyboard();
                          if (_registerFormKey.currentState.validate()) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                                .then((currentUser) => FirebaseFirestore.instance
                                .collection("newUsers")
                                .doc(currentUser.user.uid)
                                .set({
                              "uid": currentUser.user.uid,
                              "fname": firstNameInputController.text,
                              "lname": lastNameInputController.text,
                              "email": emailInputController.text,
                              "password": pwdInputController.text,
                              "total_chance": 10,
                              "total_score": 0,
                            })
                                .then((result) => {
                              firstNameInputController.clear(),
                              lastNameInputController.clear(),
                              emailInputController.clear(),
                              pwdInputController.clear(),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePageUser(
                                            id: currentUser.user.uid,
                                          )))
                            })
                                .catchError((err) => print(err)))
                                .catchError((err) => print(err));
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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

}
