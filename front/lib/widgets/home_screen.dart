import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("HandyNote!"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("stfl widget test"),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     height: 50,
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => setState(() {}),
      // ),
    );
  }
}
