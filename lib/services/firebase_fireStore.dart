// ignore_for_file: file_names

import 'package:blood_bridge/Models/donation_model.dart';
import 'package:blood_bridge/Models/request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/user_model.dart';

class FireStoreServices {
  static final _fireStore = FirebaseFirestore.instance;

  static Future<UserModel?> getUser(String uid) async {
    final user = await _fireStore.collection('users').doc(uid).get();
    return UserModel.fromMap(user.data()!);
  }

  static String getDocumentId(String s,
      {CollectionReference<Map<String, dynamic>>? collection}) {
    if (collection == null) {
      return _fireStore.collection(s).doc().id;
    } else {
      return collection.doc().id;
    }
  }

  // save user to firebase
  static Future<String> saveUser(UserModel user) async {
    final response = await _fireStore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap())
        .then((value) => 'success')
        .catchError((error) => error.toString());
    return response;
  }

  static Future<bool> saveRequest(RequestModel state) async {
    final response = await _fireStore
        .collection('requests')
        .doc(state.id)
        .set(state.toMap())
        .then((value) => true)
        .catchError((error) => false);
    return response;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRequestStream() {
    return _fireStore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<bool> saveDonation(DonationModel state) async {
    final response = await _fireStore
        .collection('donations')
        .doc(state.id)
        .set(state.toMap())
        .then((value) => true)
        .catchError((error) => false);
    return response;
  }

  static Future<bool> updateRequestDonor(RequestModel model) async {
    var response = await _fireStore
        .collection('requests')
        .doc(model.id)
        .update(model.donorUpdateMap())
        .then((value) => true)
        .catchError((error) => false);
    return response;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDonationStream(
      String request) {
    return _fireStore
        .collection('donations')
        .where('requestId', isEqualTo: request)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> deleteRequest(String s) async {
    await _fireStore.collection('requests').doc(s).delete();
  }

  static Future<void> markRequestAsCompleted(String s) async {
    await _fireStore
        .collection('requests')
        .doc(s)
        .update({'isCompleted': true});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyDonationStream(
      String? myId) {
    return _fireStore
        .collection('donations')
        .where('donorId', isEqualTo: myId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<bool> updateDonation(
      String? id, Map<String, String?> map) async {
    var response = await _fireStore
        .collection('donations')
        .doc(id)
        .update(map)
        .then((value) => true)
        .catchError((error) => false);
    return response;
  }

  static Future<void> removeUserFromDonor(
      String? requestId, String? donorId) async {
    await _fireStore.collection('requests').doc(requestId).update({
      'donors': FieldValue.arrayRemove([donorId])
    });
  }
}
