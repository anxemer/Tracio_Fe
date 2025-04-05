class City {
  City({
    required this.id,
    required this.name,
    required this.type,
    required this.typeText,
    required this.slug,
  });

  final String? id;
  final String? name;
  final int? type;
  final String? typeText;
  final String? slug;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      typeText: json["typeText"],
      slug: json["slug"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "typeText": typeText,
        "slug": slug,
      };
}
