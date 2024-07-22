import 'package:baatein/chatpage.dart';
import 'package:baatein/forgot_pass.dart';
import 'package:baatein/home.dart';
import 'package:baatein/signin.dart';
import 'package:baatein/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions
    (
      apiKey: "AIzaSyDrzGP5lkCsBDEmElhoicoP0TPeE4VyPsE", 
      appId: "1:723597685206:android:ee3fa6c6a5d7530e71f477", 
      messagingSenderId: "723597685206",
      projectId: "chatapp-eead0",
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

