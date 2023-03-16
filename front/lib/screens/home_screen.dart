import 'package:flutter/material.dart';
import 'package:front/screens/detail_screen.dart';
import 'package:front/services/api_service.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  List<dynamic> _memoList = [];

  @override
  void initState() {
    super.initState();
    loadMemos();
  }

  Future<void> loadMemos() async {
    final memoList = await HandynoteApi.getMemos();
    setState(() {
      _memoList = memoList;
    });
  }

  void _showMemoDetail(int? id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return DetailScreen(
            id: id,
          );
        },
      ),
    ).then((_) {
      loadMemos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo List'),
      ),
      body: ListView.builder(
        itemCount: _memoList.length,
        itemBuilder: (BuildContext context, int index) {
          var memo = _memoList[index];
          return ListTile(
            title: Text(memo.title),
            subtitle: Text(memo.content),
            onTap: () {
              _showMemoDetail(memo.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMemoDetail(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
