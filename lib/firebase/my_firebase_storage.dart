import 'dart:io';
import 'package:blog_app/utils/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class MyFirebaseStorage {
  static final instance = MyFirebaseStorage._();

  final _firebaseStorage = FirebaseStorage.instance;
  final _imageRootRef = 'images';

  MyFirebaseStorage._();

  /*
  Image storage
  - images
    - image_path
   */

  String _newImageReferencePath(String uuid) => '$_imageRootRef/$uuid.jpg';
  String _imageReferencePath(String refPath) => '$_imageRootRef/$refPath.jpg';

  void uploadImage(File file, Function(String) onSuccess,
      Function(String) onUploadImageFailed) {
    String uuid = Uuid().v1();
    String imageRef = _newImageReferencePath(uuid);
    _firebaseStorage.ref(imageRef).putFile(file).then((snapshot) {
      onSuccess(uuid);
    }).catchError((Object e) => onUploadImageFailed(Strings.uploadImageIsFailed));
  }

  void downloadImage(String imageReferencePath, Function(File) onSuccess,
      Function(String) onDownloadImageFailed) async {
    getApplicationDocumentsDirectory().then((directory) {
      File downloadToFile = File('${directory.path}/$imageReferencePath');
      _firebaseStorage
          .ref(_imageReferencePath(imageReferencePath))
          .writeToFile(downloadToFile)
          .then((snapshot) {
        onSuccess(downloadToFile);
      }).catchError((Object e) => onDownloadImageFailed(Strings.downloadImageIsFailed));
    }).catchError((Object e) => onDownloadImageFailed(Strings.downloadImageIsFailed));
  }
}
