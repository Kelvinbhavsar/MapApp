import 'dart:async';

import 'package:MapApp/home.dart';
import 'package:flutter/material.dart';
import 'package:MapApp/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userLoged =  false;
  @override
  void initState() {
    super.initState();
    getUserData();
    Timer(
        Duration(seconds: 4),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => userLoged ? Home() : Login())));
  }
  getUserData() async {
    await SharedPreferences.getInstance().then((value){
      print(value.getInt('userLogged'));
       if (value.getInt('userLogged') ?? 0 == 1 ){
         userLoged = true;
       }
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
          child: Image.asset('assets/images/splashScreen.png',fit: BoxFit.cover)),
    );
  }
}
