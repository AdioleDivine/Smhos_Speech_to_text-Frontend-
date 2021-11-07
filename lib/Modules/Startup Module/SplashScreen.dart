// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/salvationpng.png",
              height: 130,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Text to Speech",
              style: GoogleFonts.montserrat(fontSize: 40),
            )
          ],
        ),
      ),
    );
  }
}
