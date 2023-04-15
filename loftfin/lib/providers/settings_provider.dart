import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/waitliast_rule.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/services/log_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool byPassWaitList = false;
  List<WaitList> waitList = [];

  final TextEditingController signupPerk = TextEditingController();
  final TextEditingController refPerkController = TextEditingController();
  final TextEditingController refereeController = TextEditingController();
  final TextEditingController referralsForExtraRewards =
      TextEditingController();
  final TextEditingController extraReferralRewards = TextEditingController();

  String signup = '';
  String refPerk = '';
  String referee = '';
  String refForExtraRewards = '';
  String extraRefRewards = '';

  void updateByPassWaitList() {
    byPassWaitList = !byPassWaitList;
    notifyListeners();
  }

  void addToWaitList(WaitList item) {
    waitList.add(item);
    notifyListeners();
  }

  void removeFromWaitList(WaitList item) {
    waitList.remove(item);
    notifyListeners();
  }

  bool signError = false;
  bool refError = false;
  bool refereeError = false;
  bool refForExtraRewardsError = false;
  bool extraRefRewardsError = false;

  bool checkValidate() {
    if (signupPerk.text.trim().isEmpty) {
      signError = true;
    } else {
      if (isNumeric(signupPerk.text)) {
        signError = false;
      } else {
        signError = true;
      }
    }

    if (refPerkController.text.trim().isEmpty) {
      refError = true;
    } else {
      if (isNumeric(refPerkController.text)) {
        refError = false;
      } else {
        refError = true;
      }
    }

    if (refereeController.text.trim().isEmpty) {
      refereeError = true;
    } else {
      if (isNumeric(refereeController.text)) {
        refereeError = false;
      } else {
        refereeError = true;
      }
    }
    if (referralsForExtraRewards.text.trim().isEmpty) {
      refForExtraRewardsError = true;
    } else {
      if (isNumeric(referralsForExtraRewards.text)) {
        refForExtraRewardsError = false;
      } else {
        refForExtraRewardsError = true;
      }
    }
    if (extraReferralRewards.text.trim().isEmpty) {
      extraRefRewardsError = true;
    } else {
      if (isNumeric(extraReferralRewards.text)) {
        extraRefRewardsError = false;
      } else {
        extraRefRewardsError = true;
      }
    }

    if (signError ||
        refError ||
        refereeError ||
        refForExtraRewardsError ||
        extraRefRewardsError) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  ApiRepository apiRepository = ApiRepository();

  Future<bool> saveSettings() async {
    Map<String, dynamic> settings = {
      'refereePerks': int.parse(refereeController.text),
      'referralRewards': int.parse(refPerkController.text),
      'signupPerks': int.parse(signupPerk.text),
      'referralsForExtraRewards': int.parse(referralsForExtraRewards.text),
      'extraReferralRewards': int.parse(extraReferralRewards.text),
      'waitlistEnabled': byPassWaitList,
    };
    ApiResponse response = await apiRepository.saveSettings(settings);

    dPrint('Update user response - ${response.data}');

    if (response.isError) {
      return false;
    } else {
      Map<String, dynamic> temp = json.decode(response.data);
      return true;
    }
  }

  Future<bool> getAllSettings() async {
    ApiResponse response = await apiRepository.getAllSettings();

    dPrint('Update user response - ${response.data}');

    if (response.isError) {
      return false;
    } else {
      Map<String, dynamic> temp = response.data;

      try {
        refPerkController.text = temp['referralRewards'].toString();
        refereeController.text = temp['refereePerks'].toString();
        signupPerk.text = temp['signupPerks'].toString();
        referralsForExtraRewards.text =
            temp['referralsForExtraRewards'].toString();
        extraReferralRewards.text = temp['extraReferralRewards'].toString();

        byPassWaitList = temp['waitlistEnabled'];

        dPrint('ok... $refPerk, $referee, $signup, $byPassWaitList');

        notifyListeners();
      } catch (e) {
        dPrint('Error parsing settings - $e');
      }

      return true;
    }
  }
}
