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
        foregroundColor: colorPrimary,
        backgroundColor: colorAccent,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close)),
        title: Text("About"),
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Text("Watadrop is an on demand water-delivery app.\n"
                "This mobile app aims top help individuals keep hydrated by on-demand water delivery and access to safe drinking water."
            ),
          ],
        ),
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