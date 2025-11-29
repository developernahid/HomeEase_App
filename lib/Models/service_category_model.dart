class ServiceCategory {
  final String id;
  final String title;
  final List<FeaturedService> featured;
  final List<String> all;

  ServiceCategory({
    required this.id,
    required this.title,
    this.featured = const [],
    this.all = const [],
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      featured: (json['featured'] as List<dynamic>?)
              ?.map((e) => FeaturedService.fromJson(e))
              .toList() ??
          [],
      all: (json['all'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class FeaturedService {
  final dynamic id; // API doc says Number, but could be String in practice
  final String title;
  final String? description;
  final String? image;

  FeaturedService({
    required this.id,
    required this.title,
    this.description,
    this.image,
  });

  factory FeaturedService.fromJson(Map<String, dynamic> json) {
    return FeaturedService(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      image: json['image'],
    );
  }
}
