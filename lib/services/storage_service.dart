// Firebase Storage service for image uploads

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  // Upload book cover image
  Future<String> uploadBookImage(File imageFile, String userId) async {
    try {
      final fileName = '${_uuid.v4()}.jpg';
      final ref = _storage.ref().child('book_covers/$userId/$fileName');
      
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }

  // Delete image from storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Image might not exist, ignore error
    }
  }
}