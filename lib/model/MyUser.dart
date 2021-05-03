import 'package:blog_app/utils/strings.dart';

enum Gender {
  female,
  male,
  other
}

class MyUser {
  String id;
  String email;
  String password;
  String phoneNumber;
  Gender gender;

  MyUser(this.id, this.email, this.password, this.phoneNumber, this.gender);

  MyUser.createUser(String id, String email, String password, String phoneNumber, int gender) {
    this.id = id;
    this.email = email;
    this.password = password;
    this.phoneNumber = phoneNumber;
    this.gender = _getGender(gender);
  }

  MyUser.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.email = map["email"];
    this.phoneNumber = map["phone_number"];
    this.gender = _getGender(map["gender"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "email": email,
      "phone_number": phoneNumber,
      "gender": genderToInt(gender)
    };
  }

  Gender _getGender(int gender) {
    if (gender == 0) {
      return Gender.female;
    } else if (gender == 1) {
      return Gender.male;
    } else {
      return Gender.other;
    }
  }

  static String genderToString(Gender gender) {
    if (gender == Gender.female) {
      return Strings.female;
    } else if (gender == Gender.male) {
      return Strings.male;
    } else {
      return Strings.other;
    }
  }

  static Gender intToGender(int index) {
    if (index == 0) {
      return Gender.female;
    } else if (index == 1) {
      return Gender.male;
    } else {
      return Gender.other;
    }
  }

  static int genderToInt(Gender gender) {
    if (gender == Gender.female) {
      return 0;
    } else if (gender == Gender.male) {
      return 1;
    } else {
      return 2;
    }
  }
}