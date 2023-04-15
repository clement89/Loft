import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/perk.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/services/log_service.dart';

class PerksProvider with ChangeNotifier {
  final displayName = TextEditingController();
  final vendorWebsite = TextEditingController();
  final vendorName = TextEditingController();
  final perkAmount = TextEditingController();
  // final count = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final order = TextEditingController();
  final transactionKeywords = TextEditingController();

  String imageName = '';

  bool isNameError = false;
  bool isWebsiteError = false;
  bool vendorNameError = false;
  bool perkAmountError = false;
  // bool countError = false;
  bool startDateError = false;
  bool enDateError = false;
  bool orderError = false;
  bool imageError = false;

  bool transactionKeywordsError = false;

  bool isUpdating = false;

  List<Perk> perkList = [];

  void resetFields() {
    isNameError = false;
    isWebsiteError = false;
    vendorNameError = false;
    perkAmountError = false;
    // countError = false;
    startDateError = false;
    enDateError = false;
    orderError = false;
    imageError = false;
    transactionKeywordsError = false;
    displayName.text = "";
    vendorWebsite.text = "";
    vendorName.text = "";
    perkAmount.text = "";
    // count.text = "";
    startDate.text = "";
    endDate.text = "";
    order.text = "";
    transactionKeywords.text = "";
  }

  void setFields(Perk? perk) {
    displayName.text = perk!.displayName;
    vendorWebsite.text = perk.vendorWebsite;
    vendorName.text = perk.vendorName;
    perkAmount.text = perk.amount.toString();
    // count.text = perk.count.toString();
    startDate.text = perk.startDate;
    endDate.text = perk.endDate;
    order.text = perk.displayOrder.toString();
    transactionKeywords.text = perk.transactionKeywords.toList().toString();
  }

  void setUpdating() {
    if (!isUpdating) {
      isUpdating = true;
      notifyListeners();
    }
  }

  String getTransactionKeywords(List<dynamic> kewWords) {
    String keys = '';
    if (kewWords != null) {
      kewWords.forEach((element) {
        if (keys.isNotEmpty) {
          keys = '$keys,' + element;
        } else {
          keys = element;
        }
      });
    }
    return keys;
  }

  bool checkValidate() {
    if (displayName.text.trim().isEmpty) {
      isNameError = true;
    } else {
      isNameError = false;
    }

    if (vendorWebsite.text.trim().isEmpty) {
      isWebsiteError = true;
    } else {
      isWebsiteError = false;
    }

    if (vendorName.text.trim().isEmpty) {
      vendorNameError = true;
    } else {
      vendorNameError = false;
    }

    if (perkAmount.text.trim().isEmpty) {
      perkAmountError = true;
    } else {
      if (isNumeric(perkAmount.text)) {
        perkAmountError = false;
      } else {
        perkAmountError = true;
      }
    }

    // if (count.text.trim().isEmpty) {
    //   countError = true;
    // } else {
    //   if (isNumeric(count.text)) {
    //     countError = false;
    //   } else {
    //     countError = true;
    //   }
    // }

    if (startDate.text.trim().isEmpty) {
      startDateError = true;
    } else {
      startDateError = false;

      // final startDt = DateTime.parse(startDate.text);
      // final now = DateTime.now();

      // if (startDt.compareTo(now) > 0 || isSameDate(startDt)) {
      //   startDateError = false;
      // } else {
      //   startDateError = true;
      // }
    }

    if (endDate.text.trim().isEmpty) {
      enDateError = true;
    } else {
      enDateError = false;

      // final endDt = DateTime.parse(endDate.text);
      // final now = DateTime.now();
      // if (endDt.compareTo(now) > 0 || isSameDate(endDt)) {
      //   enDateError = false;
      // } else {
      //   enDateError = true;
      // }
    }

    if (order.text.trim().isEmpty) {
      orderError = true;
    } else {
      if (isNumeric(order.text)) {
        orderError = false;
      } else {
        orderError = true;
      }
    }

    if (transactionKeywords.text.trim().isEmpty) {
      transactionKeywordsError = true;
    } else {
      transactionKeywordsError = false;
    }

    if (imageName.isEmpty) {
      imageError = true;
    } else {
      imageError = false;
    }

    if (isNameError ||
        transactionKeywordsError ||
        enDateError ||
        startDateError ||
        isWebsiteError ||
        vendorNameError ||
        perkAmountError ||
        orderError ||
        imageError) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool isSameDate(DateTime other) {
    final now = DateTime.now();
    return now.year == other.year &&
        now.month == other.month &&
        now.day == other.day;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  void updateImageUrl({required bool isUrl, required String image}) {
    if (isUrl) {
      imageName = image;
    } else {
      imageName = 'https://loft-public-asset.s3.amazonaws.com/uploads/$image';
    }
    setUpdating();
  }

  ApiRepository apiRepository = ApiRepository();

  Future<bool> createPerk() async {
    isUpdating = false;
    notifyListeners();

    List<String> keys = transactionKeywords.text.split(',');
    Map<String, dynamic> perkJson = {
      'imageUrl': imageName,
      'amount': double.parse(perkAmount.text),
      // 'count': int.parse(count.text),
      'displayName': displayName.text,
      'displayOrder': int.parse(order.text),
      'startDate': startDate.text,
      'endDate': endDate.text,
      'vendorName': vendorName.text,
      'vendorWebsite': vendorWebsite.text,
      'transactionKeywords': keys,
    };
    ApiResponse response = await apiRepository.createPerk(perkJson);

    dPrint('Update user response - ${response.data}');
    await refreshPerkList();

    if (response.isError) {
      return false;
    } else {
      Map<String, dynamic> temp = json.decode(response.data);
      return true;
    }
  }

  Future<bool> updatePerk(String id) async {
    isUpdating = false;
    notifyListeners();

    List<String> keys = transactionKeywords.text.split(',');
    Map<String, dynamic> perkJson = {
      'imageUrl': imageName,
      'id': id,
      'amount': double.parse(perkAmount.text),
      // 'count': int.parse(count.text),
      'displayName': displayName.text,
      'displayOrder': int.parse(order.text),
      'startDate': startDate.text,
      'endDate': endDate.text,
      'vendorName': vendorName.text,
      'vendorWebsite': vendorWebsite.text,
      'transactionKeywords': keys,
    };
    ApiResponse response = await apiRepository.updatePerk(perkJson);

    dPrint('Update user response - ${response.data}');
    await refreshPerkList();

    if (response.isError) {
      return false;
    } else {
      Map<String, dynamic> temp = json.decode(response.data);
      return true;
    }
  }

  Future<bool> getAllPerks() async {
    dPrint('getAllPerks');
    try {
      ApiResponse apiResponse = await apiRepository.getAllPerks();
      if (!apiResponse.isError) {
        perkList = [];
        List<dynamic> data = apiResponse.data!;

        data.forEach((element) {
          perkList.add(Perk.fromMap(element));
        });
        perkList.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      }
      // print('perks data $perkList');
    } catch (e) {
      dPrint('Error getting perks - $e');
    }

    return true;
  }

  Future<void> refreshPerkList() async {
    dPrint('refreshPerkList');
    await getAllPerks();
    notifyListeners();
  }

  Future<bool> deletePerk(String id) async {
    try {
      ApiResponse apiResponse = await apiRepository.deletePerk(id);
      if (!apiResponse.isError) {
        dynamic data = apiResponse.data!;
      }
    } catch (e) {
      dPrint('Error deleting perks - $e');
    }

    return true;
  }
}
