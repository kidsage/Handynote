import 'package:flutter/material.dart';
import 'package:front/models/handynote_model.dart';

class NotesSearch extends SearchDelegate<Note> {
  final List<Note> notes;
  List<Note> filteredNotes = [];
  NotesSearch({
    required this.notes,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
        hintColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headline6: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ));
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        splashRadius: 22,
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(
            context); // close에서 수정 > result값을 null로 주는 방식이 안먹히는듯..? 역시 템플릿 ㅡㅡ
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                Icons.search,
                size: 50,
                color: Colors.black,
              ),
            ),
            Text(
              'Enter a note to search.',
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
      );
    } else {
      filteredNotes = [];
      getFilteredList(notes);
      if (filteredNotes.isEmpty) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'No results found',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredNotes[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  filteredNotes[index].content,
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () {
                  close(context, filteredNotes[index]);
                },
              );
            },
          ),
        );
      }
    }
  }

  List<Note> getFilteredList(List<Note> note) {
    for (int i = 0; i < note.length; i++) {
      if (note[i].title.toLowerCase().contains(query) ||
          note[i].content.toLowerCase().contains(query)) {
        filteredNotes.add(note[i]);
      }
    }
    return filteredNotes;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                Icons.search,
                size: 50,
                color: Colors.black,
              ),
            ),
            Text(
              'Enter a note to search.',
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
      );
    } else {
      filteredNotes = [];
      getFilteredList(notes);
      if (filteredNotes.isEmpty) {
        return Container(
          color: Colors.white,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                'No results found',
                style: TextStyle(color: Colors.black),
              )
            ],
          )),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredNotes[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                subtitle: Text(
                  filteredNotes[index].content,
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                onTap: () {
                  close(context, filteredNotes[index]);
                },
              );
            },
          ),
        );
      }
    }
  }
}
