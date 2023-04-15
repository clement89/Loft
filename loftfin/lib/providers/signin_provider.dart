import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/loft_user.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/services/service_locator.dart';
import 'package:loftfin/utils/app_settings.dart';
import 'package:loftfin/utils/utils.dart';

class SignInProvider with ChangeNotifier {
  ApiRepository apiRepository = serviceLocator<ApiRepository>();

  bool isSignUp = false;

  final textName = TextEditingController();
  final textLastName = TextEditingController();
  final textEmail = TextEditingController();
  final textPhone = TextEditingController();
  final textZip = TextEditingController();
  final textRfCode = TextEditingController();

  bool isNameError = false;
  bool isLastNameError = false;
  bool isPhoneError = false;
  bool isEmailError = false;
  bool isAnyErrors = false;
  bool isZipError = false;
  bool zipMismatchError = false;

  String otpString = '';

  bool isUserUpdated = false;
  String signUpError = '';

  bool isCreating = false;

  late LoftUser loftUser;

  void resetFieldValues() {
    textName.text = '';
    textLastName.text = '';
    textZip.text = '';
    textEmail.text = '';
    textRfCode.text = '';

    isNameError = false;
    isLastNameError = false;
    isPhoneError = false;
    isEmailError = false;
    isAnyErrors = false;
    isZipError = false;
    zipMismatchError = false;
    // notifyListeners();
  }

  bool checkValidate() {
    if (textName.text.trim().isEmpty) {
      isNameError = true;
    } else {
      isNameError = false;
    }

    if (textLastName.text.trim().isEmpty) {
      isLastNameError = true;
    } else {
      isLastNameError = false;
    }
    if (textZip.text.trim().isEmpty) {
      isZipError = true;
    } else {
      isZipError = false;
    }
    if (textEmail.text.trim().isEmpty ||
        !Utils().validateEmail(textEmail.text.trim())) {
      isEmailError = true;
    } else {
      isEmailError = false;
    }

    if (!validatePhoneNumber()) {
      isPhoneError = true;
    } else {
      if (textPhone.text.length < 7) {
        isPhoneError = true;
      } else {
        isPhoneError = false;
      }
    }
    if (isNameError ||
        isLastNameError ||
        isEmailError ||
        isPhoneError ||
        isZipError) {
      isAnyErrors = true;
      notifyListeners();
      return false;
    } else {
      isAnyErrors = false;
      notifyListeners();
      return true;
    }
  }

  /////........

  bool validatePhoneNumber() {
    if (textPhone.text.trim().isEmpty &&
        !Utils().isPhoneNoValid(textPhone.text)) {
      isPhoneError = true;
      notifyListeners();
      return false;
    } else {
      isPhoneError = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> validateUserData() async {
    String num = Utils().getClearPhoneNumber(textPhone.text);

    loftUser = LoftUser(
      userId: '',
      firstName: textName.text,
      lastName: textLastName.text,
      email: textEmail.text,
      zipcode: textZip.text,
    );

    Map<String, dynamic> userMap = Utils().removeEmptyFields(loftUser.toMap());

    ApiResponse response = await apiRepository.validateUserInfo(userMap);

    if (response.isError) {
      return false;
    } else {
      Map<String, dynamic> temp = json.decode(response.data);

      dPrint('check user exist - $temp');

      if (temp['status'] == 'Failed') {
        signUpError = temp['reason'];

        return false;
      }
      signUpError = '';
      return true;
    }
  }

  Future<bool> createUser() async {
    if (!isCreating) {
      isCreating = true;

      ApiResponse response =
          await apiRepository.registerUser(AppSettings.instance.currentUser);
      isCreating = false;
      if (response.isError) {
        return false;
      } else {
        try {
          Map<String, dynamic> data = json.decode(response.data);

          if (data['status'] == 'Success') {
            signUpError = '';
            return true;
          } else {
            signUpError = data['reason'];
            return false;
          }
        } catch (e) {
          dPrint('Error - $e');
          signUpError = 'Something went wrong';
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<bool> checkUserExists() async {
    if (!isCreating) {
      isCreating = true;

      ApiResponse response = await apiRepository.checkUserExists();
      isCreating = false;
      if (response.isError) {
        return false;
      } else {
        try {
          // Map<String, dynamic> data = json.decode(response.data);
          Map<String, dynamic> data = response.data;
          if (data['status'] == 'true') {
            signUpError = '';
            return true;
          } else {
            signUpError = data['reason'];
            return false;
          }
        } catch (e) {
          dPrint('Error - $e');
          signUpError = 'Something went wrong';
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getWelcomeData() async {
    ApiResponse apiResponse = await apiRepository.getWelcomeData();

    if (!apiResponse.isError) {
      dynamic temp = apiResponse.data!;
      return temp['data'];
    } else {
      return [];
    }
  }
}
