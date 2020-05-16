import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String displayPic;
  final String email;
  final String phone;

  final String userId;

  /// This property is use to get the DBreference for easy update on the user later
  final DocumentReference reference;

  User(
      {this.name,
      this.displayPic,
      this.email,
      this.phone,
      this.userId,
      this.reference});

  User.fromJson(Map<String, dynamic> json, {this.userId, this.reference})
      : name = json['name'],
        displayPic = json['displayPic'] ?? "",
        phone = json['phone'] ?? "",
        email = json['email'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data,
            reference: snapshot.reference, userId: snapshot.documentID);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['name'] = name;
    map['displayPic'] = displayPic;
    map['phone'] = phone;
    map['email'] = email;
    return map;
  }

  @override
  String toString() {
    return 'Member{name: $name, displayPic: $displayPic, email: $email, phone: $phone, memberId: $userId, reference: $reference}';
  }

  @override
  List<Object> get props => [name, displayPic, email, phone, userId, reference];
}
