class Note {
  final int id;
  final String title, category, content, update;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      title = newTitle;
    }
  }

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        category = json['category'].toString(),
        content = json['content'],
        update = json['updated_at'];
}
