import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_management_system/Constants.dart';
import 'package:food_management_system/screens/HomePage.dart';
import 'package:food_management_system/screens/SignIn.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error ${streamSnapshot.error}"),
                  ),
                );
              }

              if (streamSnapshot.connectionState == ConnectionState.active) {
                // Get the user
                // User _user = (streamSnapshot.data);

                User? _user = FirebaseAuth.instance.currentUser;
                print("User = $_user");
                // If the user is null, we're not logged in
                if (_user == null) {
                  // user not logged in, head to login
                  return SignIn();
                } else {
                  // The user is logged in, head to homepage
                  return HomePage(user: _user);
                }
              }

              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(
            child: Text(
              "Initializing the app...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
