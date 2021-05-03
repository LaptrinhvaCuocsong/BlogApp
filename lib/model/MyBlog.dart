import 'package:blog_app/utils/date_utils.dart';

class MyBlog {
  String _referencePath;
  String _description;
  DateTime _createTime;
  int _timestamp;

  String get referencePath => _referencePath;

  set referencePath(String newValue) {
    _referencePath = newValue;
  }

  String get description => _description;

  set description(String newValue) {
    _description = newValue;
  }

  DateTime get createTime => _createTime;

  set createTime(DateTime newValue) {
    _createTime = newValue;
    _timestamp = newValue == null ? null : newValue.millisecondsSinceEpoch;
  }

  MyBlog(this._referencePath, this._description, this._createTime);

  MyBlog.fromMap(Map<String, dynamic> map) {
    referencePath = map['reference_path'];
    description = map['description'];
    createTime = DateUtils.stringToDate(
        map['create_time'] as String, true, MyDateFormat.format3);
  }

  Map<String, dynamic> toMap() {
    return {
      'reference_path': referencePath,
      'description': description,
      'create_time':
          DateUtils.dateToString(createTime, true, MyDateFormat.format3),
      'timestamp': _timestamp
    };
  }
}
