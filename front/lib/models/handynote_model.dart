class Note {
  int? id;
  String title, category, content, update;
  int priority, color;

  Note({
    required this.title,
    required this.category,
    required this.content,
    required this.priority,
    required this.color,
    required this.update,
  });

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        category = json['category'].toString(),
        content = json['content'],
        update = json['updated_at'],
        priority = json['priority'],
        color = json['color'];
}
