class EbookChapter {
  final int id;
  final String title;
  final String thumb;
  final String url;
  final bool isActive;

  EbookChapter({
    required this.id,
    required this.title,
    required this.thumb,
    required this.url,
    this.isActive = true,
  });

  factory EbookChapter.fromJson(Map<String, dynamic> json) {
    return EbookChapter(
      id: json['id'] as int,
      title: json['title'] as String,
      thumb: json['thumb'] as String,
      url: json['url'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumb': thumb,
      'url': url,
      'is_active': isActive,
    };
  }
}
