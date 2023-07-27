import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../common/style.dart';
import '../../user/views/landing_screen.dart';

class AccountScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: colorPrimary,
        foregroundColor: colorSecondary,
        title: Text("ACCOUNT"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LandingScreen()
                    )
                );
              },
              icon: Icon(Icons.logout_outlined)
          ),
        ],
      ),
    );
  }

}