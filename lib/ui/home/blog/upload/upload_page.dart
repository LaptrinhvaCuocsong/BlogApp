import 'package:blog_app/blocs/home/upload/upload_bloc.dart';
import 'package:blog_app/firebase/my_firebase_firestore.dart';
import 'package:blog_app/firebase/my_firebase_storage.dart';
import 'package:blog_app/model/MyBlog.dart';
import 'package:blog_app/ui/dialog/loading_dialog.dart';
import 'package:blog_app/ui/dialog/msg_dialog.dart';
import 'package:blog_app/ui/dialog/my_dialog.dart';
import 'package:blog_app/utils/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blog_app/extensions/IntExtension.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _imagePicker = ImagePicker();
  PickedFile _imageFile;

  double get _imageHeight => 300.scaleH(context);
  UploadBloc _uploadBloc = UploadBloc();
  bool _formIsValid = false;
  MyBlog _blogUpload = MyBlog(null, null, null);
  TextEditingController _descriptionController = TextEditingController();
  Widget _descriptionTfWidget;

  double get _minHeightBody {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return mediaQueryData.size.height - mediaQueryData.padding.top;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _descriptionController.addListener(() {
      _validate();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _descriptionController.dispose();
    _uploadBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.uploadPageTitle),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_library_rounded),
        onPressed: _onPressedSelectPhotoLibraryBtn,
      ),
      body: defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder(
              future: _retrieveLostData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasError) {
                  _buildBody();
                }
                return _buildEmptyBody();
              },
            )
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_imageFile != null) {
      return _buildFormUploadBlog();
    } else {
      return _buildEmptyBody();
    }
  }

  Widget _buildFormUploadBlog() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _minHeightBody),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: _imageHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(_imageFile.path)))),
              ),
              SizedBox(height: 16.scaleH(context)),
              _buildDescriptionTfWidget(),
              SizedBox(height: 30.scaleH(context)),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: _buildUploadBtn(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionTfWidget() {
    if (_descriptionTfWidget == null) {
      _descriptionTfWidget = Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: StreamBuilder(
          stream: _uploadBloc.descriptionStream,
          builder: (context, snapshot) {
            return TextField(
              decoration: InputDecoration(
                  labelText: Strings.descriptionTfLabel,
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null),
              maxLines: 5,
              textInputAction: TextInputAction.done,
              controller: _descriptionController,
            );
          },
        ),
      );
    }

    return _descriptionTfWidget;
  }

  Widget _buildUploadBtn() {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: ElevatedButton(
          onPressed: _onPressedUploadBtn,
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.only(top: 12, bottom: 12))),
          child: Text(
            Strings.uploadBtn,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  void _onPressedUploadBtn() {
    if (!_formIsValid) {
      return;
    }
    LoadingDialog.show(context, null);
    MyFirebaseStorage.instance.uploadImage(File(_imageFile.path), (imageRef) {
      _uploadImageSuccess(imageRef);
    }, (msg) {
      LoadingDialog.dismiss(context);
      MsgDialog.show(context, Strings.uploadBlogIsFailed);
    });
  }

  void _uploadImageSuccess(String imageRef) {
    _blogUpload.referencePath = imageRef;
    _blogUpload.createTime = DateTime.now();
    MyFirebaseFirestore.instance.createBlog(_blogUpload, () {
      LoadingDialog.dismiss(context);
      MyDialog.show(
          context, Strings.uploadBlogSuccess, [Strings.okBtn], [_reset]);
    }, (msg) {
      LoadingDialog.dismiss(context);
      MsgDialog.show(context, msg);
    });
  }

  void _reset() {
    _blogUpload.description = null;
    _blogUpload.createTime = null;
    _blogUpload.referencePath = null;
    _formIsValid = false;
    _descriptionController.text = '';
    setState(() {
      _imageFile = null;
    });
  }

  void _validate() {
    String description = _descriptionController.text;
    _blogUpload.description = description;
    _formIsValid = _uploadBloc.formUploadIsValid(description);
  }

  Widget _buildEmptyBody() {
    return Center(
      child: Text(
        Strings.selectImageText,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }

  void _onPressedSelectPhotoLibraryBtn() {
    _getImageFromPhoto();
  }

  void _getImageFromPhoto() async {
    try {
      final pickedFile = await _imagePicker.getImage(
          source: ImageSource.gallery,
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: _imageHeight,
          imageQuality: 95);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null || response.isEmpty) {
      return;
    }
    if (response.file == null || response.type != RetrieveType.image) {
      return;
    }
    _imageFile = response.file;
  }
}
