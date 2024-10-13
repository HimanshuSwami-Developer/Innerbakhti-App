class FileItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String audioUrl;
  final String author;
  final String slogun;

  FileItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.audioUrl,
    required this.author,
    required this.slogun,
  });

  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
      audioUrl: json['audio'],
      author: json['author'],
      slogun: json['slogun'],
    );
  }
}