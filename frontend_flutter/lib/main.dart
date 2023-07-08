import 'package:flutter/material.dart';
import 'package:watadrop/splash_screen.dart';

import 'common/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorAccent,
      ),
      home: SplashScreen(),
    );
  }
}
