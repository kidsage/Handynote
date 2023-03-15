import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/models/handynote_model.dart';

class HandynoteApi {
  static const String baseUrl = 'http://127.0.0.1:8000/api/post';

  // Read(GET)
  static Future<List<HandynoteModel>> getMemo() async {
    List<HandynoteModel> noteInstances = [];
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> map = jsonDecode(response.body);
      final List<dynamic> notes = map['results'];
      for (var note in notes) {
        noteInstances.add(HandynoteModel.fromJson(note));
      }
      return noteInstances;
    }
    throw Error();
  }

  // Create(Post)
  static Future<http.Response> createMemo(
      String title, user, category, content) async {
    final response = await http.post(Uri.parse(baseUrl), body: {
      'title': title,
      'user': user,
      'category': category,
      'content': content,
    });
    return response;
  }

  // Update(Patch)
  static Future<http.Response> updateMemo(
      int id, String title, category, content) async {
    final response = await http.patch(Uri.parse('$baseUrl/$id/'), body: {
      'title': title,
      'category': category,
      'content': content,
    });
    return response;
  }

  // Delete
  static Future<http.Response> deleteMemo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id/'));
    return response;
  }
}
