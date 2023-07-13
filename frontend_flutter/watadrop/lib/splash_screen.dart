
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/style.dart';
import 'home/views/home_screen.dart';
import 'user/views/landing_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen.withScreenFunction(
        backgroundColor: colorPrimary,
        splash: 'assets/images/logo.png',
        screenFunction: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //Return String
          String? token = prefs.getString('token');
          if (token != null){
            return HomeScreen();
          } else {
            return LandingScreen();
          }

        },
        splashTransition: SplashTransition.scaleTransition,
        //pageTransitionType: PageTransitionType.scale,
      ),
      bottomSheet: bottomSheetWidget(),
    );
  }

  Widget bottomSheetWidget() {
    return Container(
      width: double.infinity,
      color: colorAccent,
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('WATER ON THE DROP.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorPrimary)
          )
      ),
    );
  }


}

