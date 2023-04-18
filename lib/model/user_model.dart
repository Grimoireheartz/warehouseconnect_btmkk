// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String firstname;
  final String lastname;
  final String email;
  final String phone_number;
  final String companyname;
  final String password;
  final String user_type;
  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone_number,
    required this.companyname,
    required this.password,
    required this.user_type,
  });

  UserModel copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? phone_number,
    String? companyname,
    String? password,
    String? user_type,
  }) {
    return UserModel(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phone_number: phone_number ?? this.phone_number,
      companyname: companyname ?? this.companyname,
      password: password ?? this.password,
      user_type: user_type ?? this.user_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone_number': phone_number,
      'companyname': companyname,
      'password': password,
      'user_type': user_type,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      email: map['email'] as String,
      phone_number: map['phone_number'] as String,
      companyname: map['companyname'] as String,
      password: map['password'] as String,
      user_type: map['user_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(firstname: $firstname, lastname: $lastname, email: $email, phone_number: $phone_number, companyname: $companyname, password: $password, user_type: $user_type)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.phone_number == phone_number &&
        other.companyname == companyname &&
        other.password == password &&
        other.user_type == user_type;
  }

  @override
  int get hashCode {
    return firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        phone_number.hashCode ^
        companyname.hashCode ^
        password.hashCode ^
        user_type.hashCode;
  }
}
