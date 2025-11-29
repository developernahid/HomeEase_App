class Booking {
  final String id;
  final BookedService service;
  final String name;
  final String email;
  final String? location;
  final String? contact;
  final String? comment;
  final String status; // 'Pending', 'Approved', 'Rejected'

  Booking({
    required this.id,
    required this.service,
    required this.name,
    required this.email,
    this.location,
    this.contact,
    this.comment,
    this.status = 'Pending',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      service: BookedService.fromJson(json['service'] ?? {}),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      location: json['location'],
      contact: json['contact'],
      comment: json['comment'],
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service': service.toJson(),
      'name': name,
      'email': email,
      'location': location,
      'contact': contact,
      'comment': comment,
      'status': status,
    };
  }
}

class BookedService {
  final String id;
  final String title;
  final String? description;
  final String? image;

  BookedService({
    required this.id,
    required this.title,
    this.description,
    this.image,
  });

  factory BookedService.fromJson(Map<String, dynamic> json) {
    return BookedService(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
