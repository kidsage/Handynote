class Note {
  int? id;
  String? update;
  String? category;
  String title, content;
  int priority, color;

  Note({
    this.id,
    this.update,
    required this.title,
    this.category,
    required this.content,
    required this.priority,
    required this.color,
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
