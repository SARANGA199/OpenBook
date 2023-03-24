import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  String uid;
  String email;
  String firstName;
  String lastName;
  String age;
  String mobile;

  UserAccount(this.uid, this.email, this.firstName, this.lastName, this.age,
      this.mobile);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'mobile': mobile
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> data) {
    return UserAccount(data['uid'], data['email'], data['firstName'],
        data['lastName'], data['age'], data['mobile']);
  }

  factory UserAccount.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserAccount(
        data['uid'],
        data['email'] ?? '',
        data['firstName'] ?? '',
        data['lastName'] ?? '',
        data['age'] ?? '',
        data['mobile']);
  }
}
