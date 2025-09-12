import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'firebase_service.g.dart';

class FirebaseService {
  // Firestore instance
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  
  // Firebase Storage instance
  static FirebaseStorage get storage => FirebaseStorage.instance;
  
  // Helper methods for common Firestore operations
  static CollectionReference<Map<String, dynamic>> collection(String path) {
    return firestore.collection(path);
  }
  
  static DocumentReference<Map<String, dynamic>> document(String path) {
    return firestore.doc(path);
  }
  
  // Helper methods for Firebase Storage
  static Reference storageRef(String path) {
    return storage.ref(path);
  }
  
  // Batch operations
  static WriteBatch batch() {
    return firestore.batch();
  }
  
  // Server timestamp
  static FieldValue get serverTimestamp => FieldValue.serverTimestamp();
  
  // Array operations
  static FieldValue arrayUnion(List<Object?> elements) => FieldValue.arrayUnion(elements);
  static FieldValue arrayRemove(List<Object?> elements) => FieldValue.arrayRemove(elements);
  
  // Increment/decrement
  static FieldValue increment(num value) => FieldValue.increment(value);
}

// Riverpod providers for Firebase services
@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(Ref ref) {
  return FirebaseStorage.instance;
}