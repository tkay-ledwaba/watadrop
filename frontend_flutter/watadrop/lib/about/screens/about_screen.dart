import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close)),
        title: Text("About"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: Image.asset('assets/images/logo.png'),
          ),
          Text("Watadrop is an on demand water-delivery app. "),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            color: colorSecondary,
          ),
          ListTile(
            title: Text("Rate us"),
          ),
          Divider(
            height: 1,
            color: colorSecondary,
          ),
          ListTile(
            title: Text("Legal"),
          ),
          ListTile(
            title: Text("Term of Use"),
          ),
          ListTile(
            title: Text("Privacy Policy"),
          ),
          SizedBox(
            height: 32,
          ),

          Align(
            child: Text("Version: 1.0.0"),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

}