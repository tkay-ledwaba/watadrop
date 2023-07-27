import 'package:flutter/material.dart';

import '../../about/screens/about_screen.dart';
import '../../account/views/account_screen.dart';
import '../../common/style.dart';
import '../../settings/screens/settings_screen.dart';

Widget DrawerWidget(context, user_data){
  double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.5,
    child: Drawer(
      backgroundColor: colorPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('${user_data!.first_name.toString()} ${user_data!.last_name.toString()}'.toUpperCase(),
                      style: TextStyle(
                          color: colorSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Edit Profile",
                    style: TextStyle(
                        color: colorAccent,
                        fontSize: 10
                    ),
                  ),
                )
              ],
            ),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=>AccountScreen())
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            height: 2,
            color: colorSecondary,
          ),

          ListTile(
            leading: Icon(Icons.help_center, color: colorSecondary),
            title: Text("Help",
                style: TextStyle(
                    color: colorSecondary
                )),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: colorSecondary),
            title: Text("Settings",
                style: TextStyle(
                    color: colorSecondary
                )
            ),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=>SettingsScreen())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: colorSecondary),
            title: Text("About",
                style: TextStyle(
                    color: colorSecondary
                )),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=>AboutScreen())
              );
            },
          ),


        ],
      ),
    ),
  );
}