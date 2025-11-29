enum UserRole { serviceSeeker, serviceProvider, admin, unknown }

class User {
  final String id;
  final String username;
  final String email;
  final UserRole role;
  final String? photoURL;
  final String? phoneNumber;
  final String? businessName;
  final String? businessAddress;
  final String? serviceType;
  final String? experience;
  final String? serviceArea;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final String? receiveOrderType;
  final List<String>? documents;
  final String? ownerName;
  final String? nicNumber;
  final String? nicExpiryDate;
  final String? paymentMethod;
  final String? pricingMethod;
  final String? hourlyFee;
  final String? flatFee;
  final String? additionalInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.role = UserRole.serviceSeeker,
    this.photoURL,
    this.phoneNumber,
    this.businessName,
    this.businessAddress,
    this.serviceType,
    this.experience,
    this.serviceArea,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.receiveOrderType,
    this.documents,
    this.ownerName,
    this.nicNumber,
    this.nicExpiryDate,
    this.paymentMethod,
    this.pricingMethod,
    this.hourlyFee,
    this.flatFee,
    this.additionalInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: _stringToUserRole(json['role']),
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      serviceType: json['serviceType'],
      experience: json['experience'],
      serviceArea: json['serviceArea'],
      workingHoursStart: json['workingHoursStart'],
      workingHoursEnd: json['workingHoursEnd'],
      receiveOrderType: json['receiveOrderType'],
      documents: json['documents'] != null
          ? List<String>.from(json['documents'])
          : null,
      ownerName: json['ownerName'],
      nicNumber: json['nicNumber'],
      nicExpiryDate: json['nicExpiryDate'],
      paymentMethod: json['paymentMethod'],
      pricingMethod: json['pricingMethod'],
      hourlyFee: json['hourlyFee'],
      flatFee: json['flatFee'],
      additionalInfo: json['additionalInfo'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'role': _userRoleToString(role),
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'serviceType': serviceType,
      'experience': experience,
      'serviceArea': serviceArea,
      'workingHoursStart': workingHoursStart,
      'workingHoursEnd': workingHoursEnd,
      'receiveOrderType': receiveOrderType,
      'documents': documents,
      'ownerName': ownerName,
      'nicNumber': nicNumber,
      'nicExpiryDate': nicExpiryDate,
      'paymentMethod': paymentMethod,
      'pricingMethod': pricingMethod,
      'hourlyFee': hourlyFee,
      'flatFee': flatFee,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static UserRole _stringToUserRole(String? roleString) {
    switch (roleString?.toLowerCase()) {
      case 'user':
        return UserRole.serviceSeeker;
      case 'vendor':
      case 'reporter': // Handling legacy/alternative terms if any
        return UserRole.serviceProvider;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.serviceSeeker;
    }
  }

  static String _userRoleToString(UserRole role) {
    switch (role) {
      case UserRole.serviceSeeker:
        return 'user';
      case UserRole.serviceProvider:
        return 'vendor';
      case UserRole.admin:
        return 'admin';
      default:
        return 'user';
    }
  }
}
