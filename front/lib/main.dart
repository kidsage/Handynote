import 'package:flutter/material.dart';
import 'package:front/screens/home_screen.dart';

void main() => runApp(const HandyNote());

class HandyNote extends StatelessWidget {
  const HandyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HandyNote",
      home: MyHomeScreen(),
    );
  }
}
