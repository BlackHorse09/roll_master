import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageUser extends StatefulWidget {
  var id;
  HomePageUser({Key key, this.id}) : super(key: key);

  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {

  CollectionReference reference = FirebaseFirestore.instance.collection("newUsers");
  List<String> test = ["1", "2", "3", "4", "5", "6"];

  @override
  void initState() {
    super.initState();
    //getData();
  }

  getData() async {
    var data = await reference.doc("${widget.id}").get();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext con) {
                return ["Profile, Logout"].map((String s) {
                  return PopupMenuItem<String>(
                    value: s,
                    child: Text(s),
                  );
                }).toList();
              },
              onSelected: (data) {
                if(data.toString().toLowerCase().contains("log")) {
                  FirebaseAuth.instance
                      .signOut()
                      .then((result) =>
                      Navigator.pop(context))
                      .catchError((err) => print(err));
                }
              },
              child: Icon(Icons.more_vert_outlined,)),
        ],
        title: Text("Home Data"),
      ),
      body: Column(
        children: [
          SizedBox(height: 16,),
          GestureDetector(
            onTap: () {
              Random random = new Random();
              int res = random.nextInt(test.length);
              print(test[res]);
            },
            child: Container(
              width: w,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Text("Get"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
