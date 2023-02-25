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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HandyNote'),
        backgroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
        child: Column(
          children: const [Text('Hello')],
        ),
      ),
    );
  }
}
