import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj1/login.dart';
import 'package:flutter_proj1/name_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


// void main() {
//   runApp(MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userID');
  prefs.getString('email');
  runApp(MyApp(home: userId == null ? LoginScreen() : NamePage()));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Widget home;
  MyApp({this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project',
      home: home,
    );
  }
}

