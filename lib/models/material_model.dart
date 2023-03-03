class Material {
  int? id;
  String? title;
  String? description;
  String? url;

  Material({
    this.id,
    this.title,
    this.description,
    this.url,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
