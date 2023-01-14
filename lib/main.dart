import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/landing_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Color(0xFFFF1E00)
            )
        ),
        home: LandingPage());
  }
}

