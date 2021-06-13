import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roll_master/HomePage/HomePageUser.dart';
import 'package:roll_master/Utils/constants.dart';

class LeaderBoard extends StatefulWidget {
  var id;
  LeaderBoard({Key key, this.id}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  CollectionReference collectionReference;
  double h,w;
  @override
  void initState() {
    collectionReference = FirebaseFirestore.instance.collection("$prod_leader_doc");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.orderBy("total_score", descending: true).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            List<QueryDocumentSnapshot> data = snapshot.data.docs;
            return Stack(
              children: [
                Container(
                  height: h,
                  width: w,
                  color: Color(0xfff4dcd6),
                ),
                ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: h,
                    width: w,
                    color: Color(0xffb2d9ea),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16,),
                      Center(
                        child: Text("LEADER BOARD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                      ),
                      SizedBox(height: 16,),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xff964b00),
                        child: Center(child: Icon(FontAwesomeIcons.medal, size: 36, color: Color(0xffffd700),)),
                      ),
                      Column(
                        children: data.map((e) {
                          int index = data.indexOf(e);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                SizedBox(height: 16,),
                                Card(
                                  color: index == 0 ? Color(0xff964b00) : Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${e['fname']} ${e['lname']}", style: TextStyle(fontSize: 16, color: index == 0 ? Color(0xffffd700) : Colors.black,),),
                                        Text("${e['total_score']}", style: TextStyle(fontSize: 16, color: index == 0 ? Color(0xffffd700) : Colors.black,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList()
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
/*
Scaffold(
      body: Stack(
        children: [
          Container(
            height: h,
            width: w,
            color: Color(0xfff4dcd6),
          ),
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: h,
              width: w,
              color: Color(0xffb2d9ea),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [

              ],
            ),
          )
        ],
      ),
    );
 */