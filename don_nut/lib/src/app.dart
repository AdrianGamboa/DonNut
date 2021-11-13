import 'screens/recover_password.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Don-Nut',
      theme: ThemeData(fontFamily: 'Segoe UI'),
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const MyHomePage(title: 'Don-Donut'),
        "/login": (BuildContext context) => const LoginPage(),
        "/register": (BuildContext context) => const RegisterPage(),
        "/recoverPass": (BuildContext context) => const RecoverPassPage()
      },
    );
  }
}
