class Category {
  String? name;

  Category({
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Category(name: '');
    }
    return Category(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name ?? ''};
}

class Note {
  int? id;
  String? update;
  Category? category;
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

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      category: Category.fromJson(json['category']),
      content: json['content'],
      update: json['updated_at'],
      priority: json['priority'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category?.toJson(),
        'content': content,
        'priority': priority,
        'color': color
      };

  Map<String, dynamic> toNoCateJson() => {
        'title': title,
        'content': content,
        'priority': priority,
        'color': color
      };
}
