import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Users {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? profileUrl;
  String? phoneNo;
  String? birthDate;
  List<dynamic>? history;
  String? gender;
  Users(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.profileUrl,
      this.phoneNo,
      this.birthDate,
      this.history,
      this.gender});

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'profileUrl': profileUrl ?? "",
      'phoneNo': phoneNo ?? "",
      'birthDate': birthDate ?? '',
      'history': history ?? [],
      'gender': gender ?? '',
    };
  }

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'],
        profileUrl: json['profileUrl'] ?? "",
        phoneNo: json['phoneNo'] ?? "",
        birthDate: json['birthDate'] ?? '',
        history: json['history'] ?? [],
        gender: json['gender'] ?? '',
      );
}
