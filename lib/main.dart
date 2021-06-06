import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_management_system/screens/Settings.dart';
import 'package:food_management_system/screens/calender_scheduler.dart';
import 'package:food_management_system/screens/HomePage.dart';
import 'package:food_management_system/screens/LandingPage.dart';
import 'package:food_management_system/screens/SignIn.dart';
import 'package:food_management_system/screens/SignUp.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/settings': (context) => Settings(),
        '/MyCalender': (context) => MyCalender(),
        '/HomePage': (context) => HomePage(user: FirebaseAuth.instance.currentUser,),
        '/SignIn': (context) => SignIn(),
        '/SignUp': (context) => SignUp(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

