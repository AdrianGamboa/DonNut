import 'package:flutter/material.dart';
import 'screens/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Don-Nut',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const MyHomePage(title: 'Don-Donut'),
      },
    );
  }
}
