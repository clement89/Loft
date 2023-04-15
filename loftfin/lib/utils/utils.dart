class Utils {
  // LoftUser get currentUser {
  //   return _currentUser;
  // }
  //
  // set currentUser(LoftUser user){
  //   _currentUser = user;
  // }

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
  }

  String getClearPhoneNumber(String num) {
    num = num.replaceAll(' ', '');
    num = num.replaceAll('+', '');
    num = num.replaceAll('(', '');
    num = num.replaceAll(')', '');
    num = num.replaceAll('-', '');

    return num;
  }

  Map<String, dynamic> removeEmptyFields(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = <String, dynamic>{};

    map.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        newMap[key] = value;
      }
    });

    return newMap;
  }
}
