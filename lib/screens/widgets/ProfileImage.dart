import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/FirebaseStorageUtil.dart';

class ProfileImage extends StatefulWidget {
  ProfileImage();

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final data = await pickedFile.readAsBytes();

      //이미지를 파이어베이스(서버) 스토리지 저장한다. -> url 주소
      Reference? ref = await FirebaseStorageUtil().uploadData(folder: 'profileImage', fileName: pickedFile.name, data: data);
      String? url = await ref?.getDownloadURL();

      if((url??'').isNotEmpty) {
        //유저한테 이미지 주소를 저장시킨다.
        await FirebaseAuthUtil.setImageUrl(context, url);

        imageUrl = url;
        setState((){});
      }
    }
  }
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    imageUrl = FirebaseAuthUtil.getImageUrl(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _pickImage(ImageSource.gallery);
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl ?? ''),
        radius: 20,
      ),
    );
  }
}
