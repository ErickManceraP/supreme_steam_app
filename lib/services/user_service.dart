import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  // Create a new user profile in Firestore
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(profile.uid)
          .set(profile.toMap());
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  // Get user profile from Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc =
          await _firestore.collection(_collectionName).doc(uid).get();

      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _firestore
          .collection(_collectionName)
          .doc(uid)
          .update(updates);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Stream of user profile changes
  Stream<UserProfile?> userProfileStream(String uid) {
    return _firestore
        .collection(_collectionName)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection(_collectionName).doc(uid).delete();
    } catch (e) {
      print('Error deleting user profile: $e');
      rethrow;
    }
  }
}
