class HandynoteModel {
  final int id;
  final String title, category, content, update;

  HandynoteModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        category = json['category'].toString(),
        content = json['content'],
        update = json['updated_at'];
}
