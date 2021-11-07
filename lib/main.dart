import 'package:flutter/material.dart';
import 'package:smhos_text_to_speech/Modules/HomePageModule.dart';
import 'package:smhos_text_to_speech/Modules/Startup%20Module/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salvation T-T-S',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePageModule(),
    );
  }
}
