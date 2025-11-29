class Product {
  final String id;
  final String name;
  final String nameBn;
  final String? description;
  final String? descriptionBn;
  final num price;
  final num? originalPrice;
  final String category;
  final String categoryBn;
  final String? subcategory;
  final String? subcategoryBn;
  final List<ProductImage> images;
  final num stock;
  final ProductWeight? weight;
  final String? brand;
  final String? sku;
  final List<String> tags;
  final List<String> tagsBn;
  final List<ProductSpecification> specifications;
  final bool isActive;
  final bool isFeatured;
  final ProductRating? rating;
  final ProductDiscount? discount;
  final String vendorId;

  Product({
    required this.id,
    required this.name,
    required this.nameBn,
    this.description,
    this.descriptionBn,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.categoryBn,
    this.subcategory,
    this.subcategoryBn,
    this.images = const [],
    this.stock = 0,
    this.weight,
    this.brand,
    this.sku,
    this.tags = const [],
    this.tagsBn = const [],
    this.specifications = const [],
    this.isActive = true,
    this.isFeatured = false,
    this.rating,
    this.discount,
    required this.vendorId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      nameBn: json['nameBn'] ?? '',
      description: json['description'],
      descriptionBn: json['descriptionBn'],
      price: json['price'] ?? 0,
      originalPrice: json['originalPrice'],
      category: json['category'] ?? '',
      categoryBn: json['categoryBn'] ?? '',
      subcategory: json['subcategory'],
      subcategoryBn: json['subcategoryBn'],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
      stock: json['stock'] ?? 0,
      weight: json['weight'] != null
          ? ProductWeight.fromJson(json['weight'])
          : null,
      brand: json['brand'],
      sku: json['sku'],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      tagsBn: (json['tagsBn'] as List<dynamic>?)?.cast<String>() ?? [],
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) => ProductSpecification.fromJson(e))
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      rating: json['rating'] != null
          ? ProductRating.fromJson(json['rating'])
          : null,
      discount: json['discount'] != null
          ? ProductDiscount.fromJson(json['discount'])
          : null,
      vendorId: json['vendor'] ?? '',
    );
  }
}

class ProductImage {
  final String url;
  final String? alt;

  ProductImage({required this.url, this.alt});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'] ?? '',
      alt: json['alt'],
    );
  }
}

class ProductWeight {
  final num value;
  final String unit;

  ProductWeight({required this.value, required this.unit});

  factory ProductWeight.fromJson(Map<String, dynamic> json) {
    return ProductWeight(
      value: json['value'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}

class ProductSpecification {
  final String name;
  final String value;
  final String? nameBn;
  final String? valueBn;

  ProductSpecification({
    required this.name,
    required this.value,
    this.nameBn,
    this.valueBn,
  });

  factory ProductSpecification.fromJson(Map<String, dynamic> json) {
    return ProductSpecification(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      nameBn: json['nameBn'],
      valueBn: json['valueBn'],
    );
  }
}

class ProductRating {
  final num average;
  final num count;

  ProductRating({required this.average, required this.count});

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      average: json['average'] ?? 0,
      count: json['count'] ?? 0,
    );
  }
}

class ProductDiscount {
  final String type;
  final num value;
  final DateTime? startDate;
  final DateTime? endDate;

  ProductDiscount({
    required this.type,
    required this.value,
    this.startDate,
    this.endDate,
  });

  factory ProductDiscount.fromJson(Map<String, dynamic> json) {
    return ProductDiscount(
      type: json['type'] ?? '',
      value: json['value'] ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
    );
  }
}
