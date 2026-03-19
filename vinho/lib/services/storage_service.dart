import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String> uploadImage(String path, File file, String folder) async {
    try {
      final ref = _storage.ref().child('$folder/$path');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Upload error: $e');
      rethrow;
    }
  }

  // Upload bytes (web)
  Future<String> uploadBytes(String path, Uint8List bytes, String folder) async {
    try {
      final ref = _storage.ref().child('$folder/$path');
      final uploadTask = await ref.putData(bytes);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Upload bytes error: $e');
      rethrow;
    }
  }

  // Delete file
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      print('Delete error: $e');
    }
  }
}

