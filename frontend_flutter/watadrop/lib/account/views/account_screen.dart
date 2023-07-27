import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watadrop/database/remote_database.dart';
import 'package:watadrop/widgets/progress_widget.dart';


import '../../common/style.dart';
import '../../user/models/user.dart';
import '../../user/views/landing_screen.dart';

class AccountScreen extends StatefulWidget {
  final User current_user;
  const AccountScreen({super.key, required this.current_user});

  @override
  _AccountScreenState createState() =>
      _AccountScreenState();
}


class _AccountScreenState extends State<AccountScreen> {
  /// form variable
  late String name;
  late String lastname;
  late String email;
  late String phone;
  late String address;
  late String password;

  final nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameTextController.text = widget.current_user.first_name;
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
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: nameTextController,
                  onChanged: (value) {
                    name = value;
                  },
                  cursorColor: colorSecondary,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: border_radius
                      ),
                      labelText: 'Name',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(8)
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

}