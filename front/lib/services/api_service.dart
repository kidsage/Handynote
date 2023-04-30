import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:front/models/handynote_model.dart';

class HandynoteApi {
  static const String baseUrl = 'http://127.0.0.1:8000/api/post';

  // Read(GET)
  static Future<List<Note>> getNotes() async {
    List<Note> noteInstances = [];
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> map =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> notes = map['results'];
      for (var note in notes) {
        noteInstances.add(Note.fromJson(note));
      }
      return noteInstances;
    }
    throw Error();
  }

  // Create(Post)
  static Future<http.Response> createNote(
      String title, category, content, int priority, color) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'title': title,
        'category': {'name': category},
        'content': content,
        'priority': priority,
        'color': color
      }),
    );
    return response;
  }

  // Update(Patch)
  static Future<http.Response> updateNote(
    int id,
    String title,
    String? category,
    String content,
    int priority,
    int color,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id/'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        'title': title,
        'category': {'name': category},
        'content': content,
        'priority': priority,
        'color': color
      }),
    );
    return response;
  }

  // Delete
  static Future<http.Response> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id/'));
    return response;
  }
}
