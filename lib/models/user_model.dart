class UserModel {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? referredBy;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final UserProfile profile;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.referredBy,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      referredBy: json['referred_by']?.toString(),
      emailVerifiedAt: json['email_verified_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'referred_by': referredBy,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile': profile.toJson(),
    };
  }
}

class UserProfile {
  final int id;
  final String userId;
  final String profileUrl;
  final int pinCode;
  final double wallet;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    required this.profileUrl,
    required this.pinCode,
    required this.wallet,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      profileUrl: json['profile_url']?.toString() ?? '',
      pinCode: json['pin_code'] ?? 0,
      wallet: (json['wallet'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_url': profileUrl,
      'pin_code': pinCode,
      'wallet': wallet,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
