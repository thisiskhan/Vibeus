import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;
  String url;
  String id;
  String discription;
  String bio;
  String email;

  User(
      {this.uid,
      this.name,
      this.gender,
      this.interestedIn,
      this.photo,
      this.age,
      this.url,
      this.location,
      this.id,
      this.discription,
      this.email,
      this.bio});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['email'],
      url: doc['photoUrl'],
      bio: doc['bio'],
    );
  }
}
