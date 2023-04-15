import 'package:flutter/cupertino.dart';
import 'package:loftfin/networking/api_repository.dart';

class ReportsProvider with ChangeNotifier {
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final kardStartDate = TextEditingController();
  final kardEndDate = TextEditingController();
  final accessStartDate = TextEditingController();
  final accessEndDate = TextEditingController();
  bool startDateError = false;
  bool enDateError = false;
  bool kardStartDateError = false;
  bool kardEndDateError = false;
  bool accessStartDateError = false;
  bool accessEndDateError = false;
  void resetFields() {
    startDateError = false;
    enDateError = false;
    kardEndDateError = false;
    kardStartDateError = false;
    accessStartDateError = false;
    accessEndDateError = false;
  }

  bool checkValidate() {
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

    if (enDateError || startDateError) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool kardCheckValidate() {
    if (kardStartDate.text.trim().isEmpty) {
      kardStartDateError = true;
    } else {
      kardStartDateError = false;

      // final startDt = DateTime.parse(startDate.text);
      // final now = DateTime.now();

      // if (startDt.compareTo(now) > 0 || isSameDate(startDt)) {
      //   startDateError = false;
      // } else {
      //   startDateError = true;
      // }
    }

    if (kardEndDate.text.trim().isEmpty) {
      kardEndDateError = true;
    } else {
      kardEndDateError = false;

      // final endDt = DateTime.parse(endDate.text);
      // final now = DateTime.now();
      // if (endDt.compareTo(now) > 0 || isSameDate(endDt)) {
      //   enDateError = false;
      // } else {
      //   enDateError = true;
      // }
    }

    if (kardEndDateError || kardEndDateError) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool accessCheckValidate() {
    if (accessStartDate.text.trim().isEmpty) {
      accessStartDateError = true;
    } else {
      accessStartDateError = false;

      // final startDt = DateTime.parse(startDate.text);
      // final now = DateTime.now();

      // if (startDt.compareTo(now) > 0 || isSameDate(startDt)) {
      //   startDateError = false;
      // } else {
      //   startDateError = true;
      // }
    }

    if (accessEndDate.text.trim().isEmpty) {
      accessEndDateError = true;
    } else {
      accessEndDateError = false;

      // final endDt = DateTime.parse(endDate.text);
      // final now = DateTime.now();
      // if (endDt.compareTo(now) > 0 || isSameDate(endDt)) {
      //   enDateError = false;
      // } else {
      //   enDateError = true;
      // }
    }

    if (accessEndDateError || accessEndDateError) {
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

  ApiRepository apiRepository = ApiRepository();

  Future<void> getFeedbackReport() async {
    Map<String, dynamic> params = {
      'fromDate': startDate.text,
      'toDate': endDate.text,
    };
    apiRepository.getFeedbackReports(params);
  }

  Future<void> getKardReport() async {
    Map<String, dynamic> params = {
      'fromDate': kardStartDate.text,
      'toDate': kardEndDate.text,
    };
    apiRepository.getKardImpressionReports(params);
  }

  Future<void> getAccessReport() async {
    Map<String, dynamic> params = {
      'fromDate': accessStartDate.text,
      'toDate': accessEndDate.text,
    };
    apiRepository.getAccessReports(params);
  }
}
