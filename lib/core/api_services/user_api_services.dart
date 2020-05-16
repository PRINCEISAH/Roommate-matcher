import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommatematcher/core/models/user.dart';

/// User collection reference
final userDBReference = Firestore.instance.collection('users');

class UserApiService {
  static Future<User> getUser(String id) async {
    DocumentSnapshot userDoc = await userDBReference.document(id).get();
    if (!userDoc.exists) {
      throw "User not found";
    }
    return User.fromSnapshot(userDoc);
  }

  static Future<void> updateUser(
      User member, Map<String, dynamic> updateData) async {
    await member.reference.updateData(updateData);
  }

  ///Create a new user
  static Future<void> saveUser(FirebaseUser user) async {
    final TransactionHandler createTransaction =
        (Transaction transaction) async {
      final DocumentSnapshot documentSnapshot =
          await transaction.get(userDBReference.document(user.uid));
      final member = User(
        name: user.displayName,
        email: user.email,
        displayPic: user.photoUrl,
      );
      await transaction.set(documentSnapshot.reference, member.toJson());
    };
    await Firestore.instance.runTransaction(createTransaction);
  }

  /// if userId or userIds are not null , the returned Users would exclude them.
  static Future<List<User>> getAllMembers(
      {String userId, List<String> userIds}) async {
    QuerySnapshot memberSnapshot;
    memberSnapshot = await userDBReference.getDocuments();
    final membersnaplist = memberSnapshot.documents;
    List<User> members;
    if (userId != null) {
      members = (membersnaplist
            ..removeWhere((docSnap) => docSnap.documentID == userId))
          .map((docSnap) => User.fromSnapshot(docSnap))
          .toList();
    } else if (userIds != null) {
      members = (membersnaplist
            ..removeWhere((docSnap) => userIds.contains(docSnap.documentID)))
          .map((docSnap) => User.fromSnapshot(docSnap))
          .toList();
    } else {
      members =
          membersnaplist.map((docSnap) => User.fromSnapshot(docSnap)).toList();
    }
    return members;
  }
}
