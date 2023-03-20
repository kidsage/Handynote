import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/models/handynote_model.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final int? id;

  const DetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      loadMemo(widget.id!);
    }
  }

  Future<void> loadMemo(int id) async {
    final response = await http.get(Uri.parse('${HandynoteApi.baseUrl}/$id'));
    final HandynoteModel memo =
        HandynoteModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    _titleController.text = memo.title;
    _contentController.text = memo.content;
    _categoryController.text = memo.category;
  }

  Future<void> saveMemo() async {
    final title = _titleController.text;
    final content = _contentController.text;
    final category = _categoryController.text;

    if (widget.id != null) {
      await HandynoteApi.updateMemo(widget.id!, title, category, content);
    } else {
      await HandynoteApi.createMemo(title, category, content);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> deleteMemo() async {
    await HandynoteApi.deleteMemo(widget.id!);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Create Memo' : 'Edit Memo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Content',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveMemo,
              child: Text(widget.id == null ? 'Create' : 'Save'),
            ),
            if (widget.id != null) const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: deleteMemo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
