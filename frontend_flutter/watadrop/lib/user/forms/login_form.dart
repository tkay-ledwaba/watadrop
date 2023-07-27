import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watadrop/user/forms/signup_form.dart';


import '../../common/strings.dart';
import '../../common/style.dart';
import '../../database/remote_database.dart';
import '../../home/views/home_screen.dart';
import '../../widgets/toast_widget.dart';
import '../models/token.dart';
import '../models/user.dart';

void showLoginForm(context) {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String email;
  late String password;

  showDialog(
      context: context,
      builder: (context){

        return ScaffoldMessenger(
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  shape: RoundedRectangleBorder( //<-- SEE HERE
                      side: BorderSide(
                        color: Colors.black,
                      )),
                  content: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: colorSecondary)
                              ),
                              child: Text('LOGIN',textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            SizedBox(height: 16),

                            TextField(
                              controller: emailController,
                              onChanged: (value) {
                                email = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Email Address',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),

                            SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              onChanged: (value) {
                                password = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Password',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                              obscureText: true,
                            ),
                            SizedBox(height: 8),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorAccent
                                ),
                              ),
                            ),
                            SizedBox(height: 8),


                            ElevatedButton(
                                onPressed: () async {
                                  if (emailController.text.isEmpty){
                                    showToastWidget("Please enter email address.", colorFailed);
                                  } else if (passwordController.text.isEmpty){
                                    showToastWidget( "Please enter password.", colorFailed);
                                  } else {

                                    try{
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                    );

                                      final response = await http
                                          .post(Uri.parse(loginUrl),
                                        headers: <String, String>{
                                          'Content-Type': 'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode(
                                            UserLogin(
                                                username: email,
                                                password: password
                                            ).toDatabaseJson()),
                                      );

                                      print(response.statusCode);

                                      if (response.statusCode == 200){

                                        Token token = Token.fromJson(json.decode(response.body));

                                        current_token = token.token;

                                        print(current_token);

                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('token', token.token);
                                        prefs.setString('email', email);
                                        current_email = email;

                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                            builder: (context) => HomeScreen()), (Route route) => false);

                                      } else if (response.statusCode == 400){
                                        Navigator.pop(context);
                                        showToastWidget( "Invalid user credentials.", colorFailed);
                                      }

                                    } catch(e){
                                      Navigator.pop(context);
                                      showToastWidget(e.toString(), colorFailed);
                                    }


                                  }

                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50), // NEW
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                child: Text('Login', style: TextStyle(color: Colors.white),)
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(text: "Don't have an account? ", style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: colorAccent ,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                          showSignupForm(context);
                                        }
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },)
        );
      }
  );

}
