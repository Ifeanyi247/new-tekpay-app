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
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      referredBy: json['referred_by'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      profile: UserProfile.fromJson(json['profile']),
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
      id: json['id'],
      userId: json['user_id'],
      profileUrl: json['profile_url'],
      pinCode: json['pin_code'],
      wallet: (json['wallet'] as num).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
