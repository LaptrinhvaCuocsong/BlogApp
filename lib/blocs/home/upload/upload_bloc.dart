import 'dart:async';
import 'package:blog_app/utils/strings.dart';

class UploadBloc {
  StreamController<String> _descriptionController = StreamController<String>.broadcast();

  Stream get descriptionStream => _descriptionController.stream;

  bool formUploadIsValid(String description) {
    bool isValid = true;
    if (description == null || description
        .trim()
        .isEmpty) {
      _descriptionController.sink.addError(Strings.descriptionIsRequired);
      isValid = false;
    } else {
      _descriptionController.sink.add('');
    }
    return isValid;
  }

  void dispose() {
    _descriptionController.close();
  }
}