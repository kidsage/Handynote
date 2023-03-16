class HandynoteModel {
  final int id;
  final String title, user, category, content;

  HandynoteModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        user = json['user'].toString(),
        category = json['category'].toString(),
        content = json['content'];
}
