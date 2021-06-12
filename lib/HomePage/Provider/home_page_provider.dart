import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomePageProvider extends ChangeNotifier {
  List<String> images = ["dice1.png", "dice2.png", "dice3.png", "dice4.png", "dice5.png", "dice6.png"];
  int totalChance = 0;
  int totalScore = 0;
  int count = -1;
  String userUID = "";
  String fName = "";
  String lName = "";
  Random random = new Random();
  CollectionReference reference = FirebaseFirestore.instance.collection("newUsers");
  CollectionReference leader = FirebaseFirestore.instance.collection("leaderBoard");


  getRandomDice() async {
    count = random.nextInt(images.length);
    if(totalChance != 0) {
      totalChance = totalChance - 1;
    }
    totalScore = totalScore + count + 1;
    print(totalScore);
    if(totalChance == 0) {
      await updateScore();
      await addToLeaderBoard();
    }
    notifyListeners();
  }

  updateScore() async {
    var col = reference.doc("$userUID").update({
      "total_chance" : totalChance,
      "total_score" : totalScore,
    }).catchError((onError) => print("$onError"));
  }

  addToLeaderBoard() async {
    leader.add({
      "fname" : fName,
      "lname" : lName,
      "uid" : userUID,
      "total_score" : totalScore
    });
  }

  refresh() {
    totalChance = 10;
    totalScore = 0;
    count = -1;
    notifyListeners();
  }


}