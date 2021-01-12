import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vibeus/models/user.dart';

class UserProfileReppository {
  final Firestore _firestore;

  UserProfileReppository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future getUsweInfo(userId) async {
    User user = User();

    await _firestore.collection('users').document(userId).get().then((user) {
     
    });
  }

  Future<void> editProfile(File profielPhoto, String userId, String yourname,
      String bio, String gender, DateTime age, GeoPoint location) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(profielPhoto);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').document(userId).setData({
          'uid': userId,
          'photoUrl': url,
          'yourname': yourname,
          'bio': bio,
          "location": location,
          'age': age
        });
      });
    });
    
  }
}
