import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/loft_user.dart';
import 'package:loftfin/networking/api_client.dart';
import 'package:loftfin/services/log_service.dart';

import '../providers/firebase_auth.dart';

class ApiRepository {
  final ApiClient _apiClient = ApiClient();
  final FirebaseAuthHandler _authHandler =
      FirebaseAuthHandler(auth: FirebaseAuth.instance);

  Future<Map<String, String>> _getAuthHeader() async {
    String? accessToken = await _authHandler.getFirebaseToken();
    dPrint('accessToken - $accessToken');
    if (accessToken == null) {
      return <String, String>{};
    } else {
      return {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer ' + accessToken,
        'APP_TYPE': 'PORTAL',
      };
    }
  }

  Future<Map<String, String>> _getPDFHeader() async {
    String? accessToken = await _authHandler.getFirebaseToken();
    dPrint('accessToken - $accessToken');
    if (accessToken == null) {
      return <String, String>{};
    } else {
      return {
        'Content-Type': 'application/pdf',
        'Authorization': 'Bearer ' + accessToken,
      };
    }
  }

  Future<Map<String, String>> _getXLSXHeader() async {
    String? accessToken = await _authHandler.getFirebaseToken();
    dPrint('accessToken - $accessToken');
    if (accessToken == null) {
      return <String, String>{};
    } else {
      return {
        'Content-Type': 'application/xlsx',
        'Authorization': 'Bearer ' + accessToken,
      };
    }
  }

  Future<ApiResponse> registerUser(LoftUser user) async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.createRecordOnServer(
        url: 'register-admin', body: user.toMap(), header: header);
    return response;
  }

  Future<ApiResponse> checkUserExists() async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.getDataFromServer(
        url: 'check-user-registered', header: header);
    return response;
  }

  Future<ApiResponse> getAllPerks() async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response =
        await _apiClient.getDataFromServer(url: 'list-perk', header: header);
    return response;
  }

  Future<ApiResponse> getAllSettings() async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.getDataFromServer(
        url: 'get-loft-settings', header: header);
    return response;
  }

  Future<ApiResponse> deletePerk(String id) async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.getDataFromServer(
        url: 'delete-perk/$id', header: header);
    return response;
  }

  //...............

  Future<ApiResponse> getWelcomeData() async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };

    ApiResponse response =
        await _apiClient.getDataFromServer(url: 'slider-data', header: header);
    return response;
  }

  Future<ApiResponse> validateUserInfo(Map<String, dynamic> userInfo) async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };

    ApiResponse response = await _apiClient.createRecordOnServer(
        url: 'validate-user', header: header, body: userInfo);
    return response;
  }

  Future<ApiResponse> createPerk(Map<String, dynamic> info) async {
    Map<String, String> header = await _getAuthHeader();

    ApiResponse response = await _apiClient.createRecordOnServer(
        url: 'save-perk', header: header, body: info);
    return response;
  }

  Future<ApiResponse> saveSettings(Map<String, dynamic> info) async {
    Map<String, String> header = await _getAuthHeader();

    ApiResponse response = await _apiClient.createRecordOnServer(
        url: 'save-loft-settings', header: header, body: info);
    return response;
  }

  Future<ApiResponse> updatePerk(Map<String, dynamic> info) async {
    Map<String, String> header = await _getAuthHeader();

    ApiResponse response = await _apiClient.createRecordOnServer(
        url: 'update-perk', header: header, body: info);
    return response;
  }

  Future uploadPerkImage(
      Uint8List imageFile, String fileName, Function(String) callBack) async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.uploadFile(
        imageFile, fileName, header, 'uploadFile', (String imageName) {
      callBack(imageName);
    });
    return response;
  }

  Future<void> uploadWaitList(
      Uint8List imageFile, String fileName, Function(String) callBack) async {
    Map<String, String> header = await _getAuthHeader();
    await _apiClient.uploadFile(imageFile, fileName, header, 'import-waitlist',
        (String imageName) {
      callBack(imageName);
    });
  }

  Future broadcastPush(String title, String message, String fileName) async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.broadcastPush(
      header,
      'brodcast-push-notification',
      title,
      message,
      fileName,
    );
    return response;
  }

  Future broadcastEmail(String title, String message, String fileName) async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.broadcastPush(
      header,
      'brodcast-email-notification',
      title,
      message,
      fileName,
    );
    return response;
  }

  Future<void> getReports() async {
    Map<String, String> header = await _getPDFHeader();
    await _apiClient.getReports(header, 'getRewardReport', 'reports.pdf');
  }

  Future<void> getUsageReports() async {
    Map<String, String> header = await _getXLSXHeader();
    await _apiClient.getReports(
        header, 'get-usage-report', 'usageReports.xlsx');
  }

  Future<void> getLoanReports() async {
    Map<String, String> header = await _getXLSXHeader();
    await _apiClient.getReports(
        header, 'loan/get-loan-report', 'loanReports.xlsx');
  }

  Future<void> getFeedbackReports(Map<String, dynamic> params) async {
    Map<String, String> header = await _getAuthHeader();
    await _apiClient.getFeedBackReports(
      header: header,
      body: params,
      url: 'get-feedback-report',
      filename: 'feedbackReports.xlsx',
    );
  }

  Future<void> getKardImpressionReports(Map<String, dynamic> params) async {
    Map<String, String> header = await _getAuthHeader();
    await _apiClient.getFeedBackReports(
      header: header,
      body: params,
      url: 'kard-impression-report',
      filename: 'ImpressionReport.xlsx',
    );
  }

  Future<void> getAccessReports(Map<String, dynamic> params) async {
    Map<String, String> header = await _getAuthHeader();
    await _apiClient.getFeedBackReports(
      header: header,
      body: params,
      url: 'get-user-access-report',
      filename: 'UserAccessReport.xlsx',
    );
  }

  Future<void> getLocation(String id) async {
    Map<String, String> header = await _getPDFHeader();
    await _apiClient.getMapping(header, 'locations', id);
  }

  Future uploadLocation(Uint8List? file, String fileName, String id) async {
    Map<String, String> header = await _getAuthHeader();
    ApiResponse response = await _apiClient.uploadLocation(
        file, fileName, header, 'locations', id);
    return response;
  }
}
