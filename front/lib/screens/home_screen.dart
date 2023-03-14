import 'package:flutter/material.dart';
import 'package:front/models/handynote_model.dart';
import 'package:front/services/api_service.dart';

import '../widgets/handynote_widget.dart';

class MyHomeScreen extends StatelessWidget {
  MyHomeScreen({super.key});

  final Future<List<HandynoteModel>> memos = ApiService.getHandynoteList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 리스트'),
      ),
      body: FutureBuilder(
        future: memos,
        // UI
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // optimized listview
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                // ListView는 높이가 무제한이라 제한을 두기 위해 expanded를 사용
                Expanded(child: makeList(snapshot)),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<HandynoteModel>> snapshot) {
    return ListView.separated(
      //builder(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        // print(index);
        var memo = snapshot.data![index];
        return Memo(
          id: memo.id,
          title: memo.title,
          user: memo.user,
          category: memo.category,
          content: memo.content,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }
}
