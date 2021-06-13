import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:roll_master/HomePage/HomePageUser.dart';
import 'package:roll_master/Login/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    navigationScreen();
    super.initState();
  }

  navigationScreen() {
    Future.delayed(Duration(milliseconds: 2000), () async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
        if(prefs.getString("id") != null) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              settings: RouteSettings(name: '/home_page'),
              pageBuilder: (c, a1, a2) => HomePageUser(
                id: prefs.getString("id"),
              ),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              settings: RouteSettings(name: '/login'),
              pageBuilder: (c, a1, a2) => LoginPage(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        }

    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: h,
              width: w,
              color: Color(0xffb2d9ea),
            ),
            Container(
              height: h * 0.7,
              width: w,
              decoration: BoxDecoration(
                color: Color(0xfff4dcd6),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(56),
                  bottomLeft: Radius.circular(56),
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: h*0.3,),
                  Center(child: Container(
                      height: 80,
                      child: Image.asset("assets/diceeLogo.png"))),
                  SizedBox(height: 16,),
                  Text("WELCOME TO", style: TextStyle(color: Colors.black, fontSize: 24),),
                  SizedBox(height: 8,),
                  DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: true,
                      totalRepeatCount: 2,
                      animatedTexts: [
                        TyperAnimatedText('ROLL MASTER'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
/*

 */