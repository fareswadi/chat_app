import 'package:chat_app/loginpage.dart';
import 'package:chat_app/searchPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat app',
      debugShowCheckedModeBanner: false,
      home:Login()
    );
  }
}


/*
* BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Color(0xFF0F52BA),
                  Color(0xFF6593F5),
                  Color(0xFF4682B4),
                ],
                    stops: [
                  0.33,
                  0.66,
                  0.99
                ])),*/