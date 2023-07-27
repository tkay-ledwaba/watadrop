
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/strings.dart';
import '../../common/style.dart';
import '../../database/remote_database.dart';
import '../../home/views/home_screen.dart';
import '../../widgets/toast_widget.dart';
import '../models/token.dart';
import 'login_form.dart';

void showSignupForm(context) {

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late String first_name;
  late String last_name;
  late String phone;
  late String email;
  late String city;
  late String password;

  showDialog(
      context: context,
      barrierDismissible: false,
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
                              child: Text('SIGN UP',textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              onChanged: (value) {
                                first_name = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Name',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: lastnameController,
                              onChanged: (value) {
                                last_name = value.trim();
                              },
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Last Name',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                            ),
                            SizedBox(height: 8),
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
                            TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: border_radius
                                  ),
                                  labelText: 'Confirm Password',
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8)),
                              obscureText: true,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                                onPressed: () async {

                                  if (nameController.text.isEmpty){
                                    showToastWidget("Please enter name", colorFailed);
                                  } else if (lastnameController.text.isEmpty){
                                    showToastWidget("Please enter lastname", colorFailed);
                                  } else if (emailController.text.isEmpty){
                                    showToastWidget("Please enter email address", colorFailed);
                                  } else if (passwordController.text.isEmpty){
                                    showToastWidget("Please enter password", colorFailed);
                                  } else if (passwordController.text != confirmPasswordController.text){
                                    showToastWidget("Password mismatch", colorFailed);
                                  } else {

                                    try {

                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                      );

                                      final response = await http
                                          .post(Uri.parse(registerUrl),
                                        body: {
                                            'username': email,
                                            'email': email,
                                            'password': password,
                                        },
                                      );

                                      print(response);

                                      print(response.statusCode);

                                      if (response.statusCode == 200){

                                        Token token = Token.fromJson(json.decode(response.body));

                                        current_token = token.token;

                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('token', current_token);
                                        prefs.setString('email', email);

                                        setAccount(context, first_name, last_name, email);


                                      } else if (response.statusCode == 400){
                                        Navigator.pop(context);
                                        showToastWidget( "Invalid user credentials.", colorFailed);
                                      }

                                    } catch (e) {
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
                                child: Text('SIGN UP', style: TextStyle(color: Colors.white),)
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: colorAccent ,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                          showLoginForm(context);
                                        }
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(

                              child: Text("By pressing continue you consent to get calls, WhatsApp or SMS messages, including automated means from WatADrop and it's affiliates.",
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10, color: colorSecondary),
                              ),
                            )
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

void setAccount(BuildContext context, String first_name, String last_name, String email) async {

 try{
   final response_data = await http
       .post(Uri.parse(userUrl),
     body: {
       'first_name': first_name,
       'last_name': last_name,
       'email': email,
     },
   );

   print(response_data.statusCode);

   if (response_data.statusCode == 200){
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
         builder: (context) => HomeScreen()), (Route route) => false);
   } else {
     Navigator.pop(context);
     showToastWidget(response_data.body.toString(), colorFailed);
   }

 } catch (e){
   Navigator.pop(context);
   showToastWidget(e.toString(), colorFailed);
 }

}



