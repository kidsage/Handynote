import 'package:flutter/material.dart';
import 'package:front/models/handynote_model.dart';
import 'package:front/widgets/handynote_widget.dart';

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
  final TextEditingController _contentontroller = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  late int _color;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _contentontroller.text = widget.note.content;
    _categoryController.text = widget.note.category;
    _color = widget.note.color;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        isEdited ? showDiscardDialog(context) : moveToLastScreen();
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
                    : _save();
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
              const Padding(padding: EdgeInsets.all(16.0))
            ],
          ),
        ),
      ),
    );
  }
}
