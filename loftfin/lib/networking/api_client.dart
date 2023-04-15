import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart' as http;
import 'package:loftfin/services/log_service.dart';

import '../models/api_response.dart';

class ApiClient {
  final String baseUrl = FlavorConfig.instance.variables['BASE_URL'];
  final int timeOut = 10;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<ApiResponse> getDataFromServer({
    required String url,
    required Map<String, String> header,
  }) async {
    dPrint('GET --------- ${baseUrl + url}');
    try {
      http.Response response = await http.get(
        Uri.parse(baseUrl + url),
        headers: header,
      );

      dPrint('statue code --- ${response.statusCode}');

      dPrint('data --- ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body.toString()) as dynamic;

        return ApiResponse(isError: false, data: data);
      } else {
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } catch (e) {
      print('Error -- $e');
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future uploadFile(Uint8List imageFile, String fileName,
      Map<String, String> header, String url, Function(String) callBack) async {
    Map<String, dynamic> convertedResp;
    try {
      // var stream = new http.ByteStream(imageFile.openRead());
      // //stream.cast();
      // var length;
      //  await imageFile.length().then((value) => length = value);

      var uri = Uri.parse(baseUrl + url);

      var request = new http.MultipartRequest("POST", uri);

      // var multipartFileSign = new http.MultipartFile(
      //     'profile_pic', stream, length,
      //     filename: basename("1645077199520-rds.PNG"));

      var multipartFileSign = new http.MultipartFile.fromBytes(
        "file",
        imageFile,
        filename: fileName,
      );
      request.files.add(multipartFileSign);
      request.headers.addAll(header);
      // send
      var response = await request.send();

      print('image upload status -- ${response.statusCode}');
      // var respData = await response.stream.toBytes();
      // var responseString = String.fromCharCodes(respData);

      //convertedResp = loggedDecodeConvert(responseString, url);

      //   if (convertedResp.containsKey('statusCode')) {
      //     int statusCode = convertedResp["statusCode"];
      //     String reasonPhrase = convertedResp["message"];
      //     if (statusCode < 200 || statusCode >= 400) {
      //       throw new Error();
      //     }
      //   }

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print('value --- $value');
        callBack(value.toString());
      });

      return ApiResponse(isError: false, data: {});
    } catch (e) {
      dPrint(e);
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future uploadLocation(Uint8List? imageFile, String fileName,
      Map<String, String> header, String url, String id) async {
    Map<String, dynamic> convertedResp;
    try {
      dPrint("Upload Url" + baseUrl + "$id/" + url);
      var uri = Uri.parse(baseUrl + "$id/" + url);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFileSign = new http.MultipartFile.fromBytes(
        "file",
        imageFile!,
        filename: fileName,
      );
      request.files.add(multipartFileSign);
      request.headers.addAll(header);
      // send
      var response = await request.send();

      print('location upload status -- ${response.statusCode}');

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print('value --- $value');
      });

      return ApiResponse(isError: false, data: {});
    } catch (e) {
      dPrint(e);
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future broadcastPush(
    Map<String, String> header,
    String url,
    String title,
    String message,
    String fileName,
  ) async {
    dPrint('GET --------- ${baseUrl + url}');
    try {
      http.Response response = await http.post(Uri.parse(baseUrl + url),
          headers: header,
          body: jsonEncode(<String, String>{
            "title": title,
            "body": message,
            // "image": fileName == ""
            //     ? "https://loft-public-asset.s3.amazonaws.com/articles/perk_available_notification.png"
            //     : "https://loft-public-asset.s3.amazonaws.com/articles/${fileName}"
          }));

      dPrint('statue code --- ${response.statusCode}');

      dPrint('data --- ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body.toString()) as dynamic;

        return ApiResponse(isError: false, data: data);
      } else {
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } catch (e) {
      print('Error -- $e');
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future getReports(
      Map<String, String> header, String url, String fileName) async {
    dPrint('GET --------- ${baseUrl + url}');
    dPrint('header --------- $header');
    try {
      http.Response response = await http.get(
        Uri.parse(baseUrl + url),
        headers: header,
      );
      dPrint('statue code --- ${response.statusCode}');
      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = fileName;
        html.document.body?.children.add(anchor);
        anchor.click();

        return ApiResponse(isError: false);
      } else {
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } catch (e) {
      print('Error -- $e');
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  // Future getFeedBackReports(
  //   Map<String, String> header,
  //   Map<String, dynamic> body,
  //   String url,
  // ) async {
  //   dPrint('POST --------- ${baseUrl + url}');
  //   dPrint('header --------- $header');
  //   dPrint('body --------- $body');
  //
  //   try {
  //     http.Response response = await http.post(
  //       Uri.parse(baseUrl + url),
  //       headers: header,
  //       body: body,
  //     );
  //     dPrint('statue code --- ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       final blob = html.Blob([response.bodyBytes]);
  //       final url = html.Url.createObjectUrlFromBlob(blob);
  //       final anchor = html.document.createElement('a') as html.AnchorElement
  //         ..href = url
  //         ..download = 'reports.pdf';
  //       html.document.body?.children.add(anchor);
  //       anchor.click();
  //
  //       return ApiResponse(isError: false);
  //     } else {
  //       return ApiResponse(
  //         isError: true,
  //         errorMessage: 'Error getting response from server',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error -- $e');
  //     return ApiResponse(
  //       isError: true,
  //       errorMessage: 'No internet connection',
  //     );
  //   }
  // }

  Future<ApiResponse> getFeedBackReports({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> header,
    required String filename,
  }) async {
    dPrint('POST --------- ${baseUrl + url}');
    dPrint('body --------- $body');
    dPrint('header --------- $header');

    try {
      var bodyNew = json.encode(body);

      http.Response response = await http.post(
        Uri.parse(baseUrl + url),
        body: bodyNew,
        headers: header,
      );

      dPrint('response - ${response.statusCode}');
      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = filename;
        html.document.body?.children.add(anchor);
        anchor.click();

        return ApiResponse(isError: false);
      } else {
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } catch (e) {
      print('Error -- $e');
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future getMapping(Map<String, String> header, String url, String id) async {
    dPrint('GET --------- ${baseUrl + "$id/" + url}');
    dPrint('header --------- ${header}');
    try {
      http.Response response = await http.get(
        Uri.parse(baseUrl + "$id/" + url),
        headers: header,
      );
      dPrint('statue code --- ${response.statusCode}');
      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = 'Location$id.csv';
        html.document.body?.children.add(anchor);
        anchor.click();

        return ApiResponse(isError: false);
      } else {
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } catch (e) {
      print('Error -- $e');
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  dynamic loggedDecodeConvert(String input, String url) {
    try {
      return _decoder.convert(input);
    } catch (error, st) {
      print("url: $url, error: ${error}, stacktrace: ${st}");
      rethrow;
    }
  }

  Future<ApiResponse> createRecordOnServer({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> header,
  }) async {
    dPrint('POST --------- ${baseUrl + url}');
    dPrint('body --------- $body');
    dPrint('header --------- $header');

    try {
      var bodyNew = json.encode(body);

      http.Response response = await http.post(
        Uri.parse(baseUrl + url),
        body: bodyNew,
        headers: header,
      );

      dPrint('response - ${response.statusCode}');
      return ApiResponse(isError: false, data: response.body);
    } catch (e) {
      print('Error -- $e');
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future<ApiResponse> updateRecordOnServer({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> header,
  }) async {
    dPrint('PUT --------- $url');
    try {
      var bodyNew = json.encode(body);

      http.Response response = await http.put(
        Uri.parse(baseUrl + url),
        body: bodyNew,
        headers: header,
      );

      if (response.statusCode == 200) {
        return ApiResponse(isError: false, data: response.body);
      } else {
        dPrint('statue code --- ${response.statusCode}');
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } on SocketException {
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }

  Future<ApiResponse> deleteRecordFromServer({
    required String url,
    required Map<String, String> header,
  }) async {
    try {
      dPrint('DELETE --------- $url');

      http.Response response =
          await http.delete(Uri.parse(baseUrl + url), headers: header);
      if (response.statusCode == 200) {
        return ApiResponse(isError: false, data: response.body);
      } else {
        dPrint('statue code ---2 ${response.statusCode}');
        return ApiResponse(
          isError: true,
          errorMessage: 'Error getting response from server',
        );
      }
    } on SocketException {
      return ApiResponse(
        isError: true,
        errorMessage: 'No internet connection',
      );
    }
  }
}
