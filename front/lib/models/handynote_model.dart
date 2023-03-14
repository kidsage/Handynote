class HandynoteModel {
  final String id, title, user, category, content;

  HandynoteModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'],
        user = json['user'].toString(),
        category = json['category'].toString(),
        content = json['content'];
}
