import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/home_page.dart';

import '../constants.dart';
import 'admin/admin.dart';
import 'auth/login_page.dart';
import 'map.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamBuilder can check the login state live
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamSnapshot) {
                // If stream snapshot has error
                if (streamSnapshot.hasError) {
                  Scaffold(
                    body: Center(
                      child: Text("Error: ${streamSnapshot.error}"),
                    ),
                  );
                }

                // Connection state active - Do the user login check inside the if statement
                if (streamSnapshot.connectionState == ConnectionState.active) {
                  // Get the user
                  User? _user = streamSnapshot.data;

                  // If the user is null, we are not logged in
                  if (_user == null) {
                    // user not logged in, head to login
                    return LoginPage();
                  } else {
                    // The user is logged in, head to homepage
                    return
                        //CurrentLocationScreen();
                        HomePage();
                  }
                }

                // Checking the auth state - Loading
                return const Scaffold(
                  body: Center(
                    child: Text("Checking Authentication...",
                        style: Constants.regularHeading),
                  ),
                );
              });
        }
        // Connecting to Firebase - Loading
        return const Scaffold(
          body: Center(
            child: Text("Initializing app...", style: Constants.regularHeading),
          ),
        );
      },
    );
  }
}
