import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:roll_master/Utils/constants.dart';

class HomePageProvider extends ChangeNotifier {
  List<String> images = ["dice1.png", "dice2.png", "dice3.png", "dice4.png", "dice5.png", "dice6.png"];
  int totalChance = 0;
  int totalScore = 0;
  int count = -1;
  String userUID = "";
  String fName = "";
  String lName = "";
  bool playedOnce = false;
  Random random = new Random();
  CollectionReference reference = FirebaseFirestore.instance.collection("$prod_user_doc");
  CollectionReference leader = FirebaseFirestore.instance.collection("$prod_leader_doc");


  getRandomDice() async {
    count = random.nextInt(images.length);
    if(totalChance != 0) {
      totalChance = totalChance - 1;
    }
    totalScore = totalScore + count + 1;
    print(totalScore);
    if(totalChance == 0) {
      await addToLeaderBoard();
      await updateScore();
    }
    notifyListeners();
  }

  updateScore() async {
    reference.doc("$userUID").update({
      "total_chance" : totalChance,
      "total_score" : totalScore,
      "played_once" : true,
    }).catchError((onError) => print("$onError"));
  }

  addToLeaderBoard() async {

    if(!playedOnce) {
      leader.doc("$userUID").set({
      "fname" : fName,
      "lname" : lName,
      "uid" : userUID,
      "total_score" : totalScore
      });
    } else {
      leader.doc("$userUID").update({
        "total_score" : totalScore
      });
    }
  }

  refresh() {
    totalChance = 10;
    totalScore = 0;
    count = -1;
    playedOnce = true;
    notifyListeners();
  }


}