import 'package:doc_appointment/appointments.dart';
import 'package:doc_appointment/home.dart';
import 'package:doc_appointment/login.dart';
import 'package:doc_appointment/profile.dart';
import 'package:flutter/material.dart';

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
      initialRoute: 'login',
      routes: {
        'login':(context)=>MyLogin(),
        'home':(context)=>HomeScreen(),
        'appointments':(context)=>MyAppointments(),
        'profile':(context)=>MyProfile()
      },
    );
  }
}