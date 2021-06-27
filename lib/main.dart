import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Library',
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
