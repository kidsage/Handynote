import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  late TabController _tabController;

  late String title;
  late String text;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      loadMemo(widget.id!);
      title = _titleController.text;
      text = _contentController.text;
    }
    _tabController = TabController(length: 2, vsync: this);
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
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: deleteMemo,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: saveMemo,
            icon: const Icon(Icons.save),
          ),
        ],
        bottom: TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text("Edit"),
            ),
            Tab(
              child: Text("Preview"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: '제목을 입력해주세요.',
                      border: InputBorder.none,
                    ),
                    onChanged: (String title) {
                      setState(() {
                        this.title = title;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: '내용을 입력해주세요.',
                      border: InputBorder.none,
                    ),
                    onChanged: (String text) {
                      setState(() {
                        this.text = text;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MarkdownBody(data: text),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
