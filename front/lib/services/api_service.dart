import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/models/handynote_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/post';

  static Future<List<HandynoteModel>> getHandynoteList() async {
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
}
