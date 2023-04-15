class LoftUser {
  String userId;
  String firstName;
  String lastName;
  String email;
  String zipcode;

  LoftUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.zipcode,
  });
  factory LoftUser.fromMap(Map<String, dynamic> json) {
    return LoftUser(
      userId: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      zipcode: json['zipcode'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userName': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'zipcode': zipcode,
    };
  }
}
