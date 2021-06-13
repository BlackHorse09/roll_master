import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roll_master/HomePage/Provider/home_page_provider.dart';
import 'package:roll_master/LeaderBoard/leader_board.dart';
import 'package:roll_master/Login/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageUser extends StatefulWidget {
  var id;
  HomePageUser({Key key, this.id}) : super(key: key);

  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> with WidgetsBindingObserver {

  CollectionReference reference = FirebaseFirestore.instance.collection("newUsers");

  List<String> options = ["Profile", "Logout"];
  SharedPreferences prefs;
  HomePageProvider homePageProvider;

  @override
  void initState() {
    super.initState();
    homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    initializePrefs();
  }

  initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: (){
        return exitApp();
      },
      child: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: reference.doc("${widget.id}").get(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
            homePageProvider.totalChance = data['total_chance'];
            homePageProvider.totalScore = data['total_score'];
            homePageProvider.fName = data['fname'];
            homePageProvider.lName = data['lname'];
            homePageProvider.userUID = data['uid'];

            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.leaderboard, color: Colors.black,),
                backgroundColor: Color(0xfff4dcd6),
                onPressed: () {
                  Navigator.push(context, PageRouteBuilder(
                    settings: RouteSettings(name: '/leader_board'),
                    pageBuilder: (c, a1, a2) => LeaderBoard(
                      id: widget.id,
                    ),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 500),
                  ),);
                },
              ),
              body: Stack(
                children: [
                  Container(
                    height: h,
                    width: w,
                    color: Color(0xffb2d9ea),
                  ),
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      height: h,
                      width: w,
                      color: Color(0xfff4dcd6),
                    ),
                  ),
                  Container(
                    width: w,
                    height: h,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ROLL MASTER", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),),
                              PopupMenuButton(
                                  itemBuilder: (BuildContext con) {
                                    return options.map((String s) {
                                      return PopupMenuItem<String>(
                                        value: s,
                                        child: Text(s),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (popData) {
                                    if(popData.toString().toLowerCase().contains("log")) {
                                      FirebaseAuth.instance
                                          .signOut()
                                          .then((result) => {
                                            prefs.clear(),
                                          Navigator.pushReplacement(context, PageRouteBuilder(
                                            settings: RouteSettings(name: '/login_page'),
                                            pageBuilder: (c, a1, a2) => LoginPage(),
                                            transitionsBuilder: (c, anim, a2, child) =>
                                                FadeTransition(opacity: anim, child: child),
                                            transitionDuration: Duration(milliseconds: 500),
                                          ),)
                                          })
                                          .catchError((err) => print(err));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext con) {
                                          return AlertDialog(
                                            title: Center(child: Text("User Details", style: TextStyle(color: Colors.black),)),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Email :", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text("${data['email']}", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Divider(color: Colors.black,),
                                                SizedBox(height: 4,),

                                                Text("First Name :", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text("${data['fname']}", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Divider(color: Colors.black,),
                                                SizedBox(height: 4,),

                                                Text("Last Name :", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text("${data['lname']}", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Divider(color: Colors.black,),
                                                SizedBox(height: 4,),

                                                Text("Total Score :", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text("${homePageProvider.totalScore}", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Divider(color: Colors.black,),
                                                SizedBox(height: 4,),

                                                Text("Total Chances Left :", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Text("${homePageProvider.totalChance}", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                SizedBox(height: 4,),
                                                Divider(color: Colors.black,),
                                                SizedBox(height: 4,),
                                              ],
                                            ),
                                          );
                                        }
                                      );
                                    }
                                  },
                                  child: Icon(Icons.more_vert_outlined, color: Colors.black, size: 24,)),
                            ],
                          ),
                        ),
                        Container(
                          width: w-32,
                          child: Consumer<HomePageProvider>(
                          builder: (BuildContext con, HomePageProvider provider, Widget child) {
                            return provider.totalChance != 0 ? Column(
                              children: [
                               Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Chances : ${provider.totalChance}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                      Text("Total Score : ${provider.totalScore}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 36,),
                                Container(
                                  width: w-32,
                                  height: 80,
                                  child: provider.count == -1 ? Image.asset("assets/diceeLogo.png") :
                                  Image.asset("assets/${provider.images[provider.count]}"),
                                ),
                                SizedBox(height: 36,),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      provider.getRandomDice();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffb71c1c),
                                          borderRadius: BorderRadius.circular(6)
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Text("ROLL A DICE", style: TextStyle(color: Colors.white, fontSize: 18),),
                                    ),
                                  ),
                                ),

                              ],
                            ) : Center(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Chances : ${provider.totalChance}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        Text("Total Score : ${provider.totalScore}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 36,),
                                  Text("You have completed your 10 chances. You can see yourself in leaderboard page competing with others!", style: TextStyle(fontSize: 16,), textAlign: TextAlign.center,),
                                ],
                              ),
                              // child: GestureDetector(
                              //   onTap: () {
                              //     provider.refresh();
                              //   },
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         color: Color(0xffb71c1c),
                              //         borderRadius: BorderRadius.circular(6)
                              //     ),
                              //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              //     child: Text("REFRESH", style: TextStyle(color: Colors.white, fontSize: 18),),
                              //   ),
                              // ),
                            );
                          }

                          ),
                        ),
                        Container()
                      ],
                    ),
                  )
                ],
              )
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        await updateData();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  exitApp() async {
    await updateData();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  updateData() async {
    if(homePageProvider.totalChance != 0) {
      print("Update happened");
      var col = reference.doc("${widget.id}").update({
        "total_chance" : homePageProvider.totalChance,
        "total_score" : homePageProvider.totalScore,
      }).catchError((onError) => print("$onError"));
    } else {
      print("Update not happened");
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print("Dispose is called");
  }

}

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/*
Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext con) {
                return options.map((String s) {
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
 */