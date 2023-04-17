import 'package:flutter/material.dart';
import 'package:front/models/handynote_model.dart';
import 'package:front/screens/detail_screen.dart';
import 'package:front/screens/search_screen.dart';
import 'package:front/services/api_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:front/widgets/handynote_widget.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  List<Note> _noteList = [];

  int count = 0;
  int axisCount = 0;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final List<Note> noteList = await HandynoteApi.getNotes();
    setState(() {
      _noteList = noteList;
      count = _noteList.length;
    });
  }

  void navigateToDetail(String title, Note note) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteDetail(
                  appBarTitle: title,
                  note: note,
                )));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    Future<List<Note>> noteListFuture = HandynoteApi.getNotes();
    noteListFuture.then((noteList) {
      setState(() {
        _noteList = noteList;
        count = _noteList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: Theme.of(context).textTheme.headline5),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: _noteList.isEmpty
            ? Container()
            : IconButton(
                onPressed: () async {
                  final Note? result = await showSearch(
                    context: context,
                    delegate: NotesSearch(notes: _noteList),
                  );
                  navigateToDetail("Edit Note", result!);
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
        actions: [
          _noteList.isEmpty
              ? Container()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      axisCount = axisCount == 2 ? 4 : 2;
                    });
                  },
                  icon: Icon(
                    color: Colors.black,
                    axisCount == 2 ? Icons.list : Icons.grid_on,
                  ),
                )
        ],
      ),
      body: _noteList.isEmpty
          ? Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Click on the add button to add a new note!',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(
            'Add Note',
            Note(
              title: '',
              content: '',
              category: '',
              priority: 3,
              color: 0,
            ),
          );
        },
        tooltip: 'Add Note',
        shape: const CircleBorder(
            side: BorderSide(color: Colors.black, width: 2.0)),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget getNotesList() {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: _noteList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            navigateToDetail('Edit Note', _noteList[index]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: colors[_noteList[index].color],
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _noteList[index].title,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                      Text(
                        getPriorityText(_noteList[index].priority),
                        style: TextStyle(
                          color: getPriorityColor(_noteList[index].priority),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _noteList[index].content,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _noteList[index].update!,
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return '!!!';
      case 2:
        return '!!';
      case 3:
        return '!';
      default:
        return '!';
    }
  }
}

// API test code.
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Note List'),
//     ),
//     body: ListView.builder(
//       itemCount: _noteList.length,
//       itemBuilder: (BuildContext context, int index) {
//         var Note = _noteList[index];
//         return ListTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 Note.title,
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.visible,
//               ),
//             ],
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'updated: ${Note.update.substring(2, 10)}',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 Text(
//                   Note.content,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.visible,
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             _showNoteDetail(Note.id);
//           },
//         );
//       },
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         _showNoteDetail(null);
//       },
//       child: const Icon(Icons.add),
//     ),
//   );
// }
