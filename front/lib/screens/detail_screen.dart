import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/models/handynote_model.dart';
import 'package:front/widgets/handynote_widget.dart';

import '../services/api_service.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail({
    super.key,
    required this.appBarTitle,
    required this.note,
  });

  @override
  State<NoteDetail> createState() => NoteDetailState();
}

class NoteDetailState extends State<NoteDetail> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  late int color;
  late int priority;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    categoryController.text = widget.note.category;
    color = widget.note.color;
    priority = widget.note.priority;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        isEdited ? showDiscardDialog(context) : moveToLastScreen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            widget.appBarTitle,
            style: Theme.of(context).textTheme.headline5,
          ),
          backgroundColor: colors[color],
          leading: IconButton(
              splashRadius: 22,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                isEdited ? showDiscardDialog(context) : moveToLastScreen();
              }),
          actions: [
            IconButton(
              splashRadius: 22,
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ),
              onPressed: () {
                titleController.text.isEmpty
                    ? showEmptyTitleDialog(context)
                    : saveNote();
              },
            ),
            IconButton(
              splashRadius: 22,
              icon: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () {
                showDeleteDialog(context);
              },
            )
          ],
        ),
        body: Container(
          color: colors[color],
          child: Column(
            children: [
              PriorityPicker(
                onTap: (index) {
                  setState(() {
                    color = index;
                  });
                  isEdited = true;
                  widget.note.color = index;
                },
                selectedIndex: 3 - widget.note.priority,
              ),
              ColorPicker(
                onTap: (index) {
                  setState(() {
                    color = index;
                  });
                },
                selectedIndex: widget.note.color,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  maxLength: 100,
                  controller: titleController,
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Title'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 255,
                    controller: contentController,
                    style: Theme.of(context).textTheme.bodyText1,
                    onChanged: (value) {
                      updateContent();
                    },
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Content'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text("Are you sure you want to discard changes?",
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Title is empty!",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text('The title of the note cannot be empty.',
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text("Okay",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text("Are you sure you want to delete this note?",
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                deleteNote();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveNote() async {
    final title = titleController.text;
    final content = contentController.text;
    final category = categoryController.text;

    if (widget.note.id != null) {
      await HandynoteApi.updateNote(
        widget.note.id!,
        title,
        category,
        content,
        priority,
        color,
      );
    } else {
      await HandynoteApi.createNote(title, category, content, priority, color);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> deleteNote() async {
    await HandynoteApi.deleteNote(widget.note.id!);
    moveToLastScreen();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    widget.note.title = titleController.text;
  }

  void updateContent() {
    isEdited = true;
    widget.note.content = contentController.text;
  }
}
