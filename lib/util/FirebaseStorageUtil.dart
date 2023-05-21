import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageUtil {
  Reference root() {
    // return FirebaseStorage.instanceFor(bucket: "gs://kakao-clone-flutter.appspot.com/").ref();
    return FirebaseStorage.instance.ref();
  }

  Future<Reference?> uploadData({
    required String folder,
    required String fileName,
    required Uint8List data,
  }) async {
    try {
      final fileRef = root().child('${folder}/${fileName}');
      final taskSnapshot = await fileRef.putData(data);
      final returnRef = taskSnapshot.ref;
      return returnRef;
    } catch (e) {
      print('uploadBlob error: ${e}');
    }
    return null;
  }
}
