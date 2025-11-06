// Model class representing a user profile

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final bool notificationsEnabled;
  final bool emailUpdatesEnabled;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.notificationsEnabled = true,
    this.emailUpdatesEnabled = true,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailUpdatesEnabled: json['emailUpdatesEnabled'] ?? true,
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'notificationsEnabled': notificationsEnabled,
      'emailUpdatesEnabled': emailUpdatesEnabled,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? notificationsEnabled,
    bool? emailUpdatesEnabled,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailUpdatesEnabled: emailUpdatesEnabled ?? this.emailUpdatesEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}