import 'package:flutter/material.dart';

void main() => runApp(const HandyNote());

class HandyNote extends StatelessWidget {
  const HandyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HandyNote",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}
