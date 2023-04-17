import 'package:flutter/material.dart';
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
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  late int _color;
  late int _priority;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
    _categoryController.text = widget.note.category;
    _color = widget.note.color;
    _priority = widget.note.priority;
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
          backgroundColor: colors[_color],
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
                _titleController.text.isEmpty
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
          color: colors[_color],
          child: Column(
            children: [
              PriorityPicker(
                onTap: (index) {
                  setState(() {
                    _color = index;
                  });
                  isEdited = true;
                  widget.note.color = index;
                },
                selectedIndex: 3 - widget.note.priority,
              ),
              ColorPicker(
                onTap: (index) {
                  setState(() {
                    _color = index;
                  });
                },
                selectedIndex: widget.note.color,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  maxLength: 255,
                  controller: _titleController,
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Title'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 255,
                    controller: _contentController,
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
    final title = _titleController.text;
    final content = _contentController.text;
    final category = _categoryController.text;

    if (widget.note.id != null) {
      await HandynoteApi.updateNote(
        widget.note.id!,
        title,
        category,
        content,
        _priority,
        _color,
      );
    } else {
      await HandynoteApi.createNote(
          title, category, content, _priority, _color);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> deleteNote() async {
    moveToLastScreen();

    await HandynoteApi.deleteNote(widget.note.id!);
    if (!mounted) return;
    Navigator.pop(context);
    moveToLastScreen();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    widget.note.title = _titleController.text;
  }

  void updateContent() {
    isEdited = true;
    widget.note.content = _contentController.text;
  }
}
