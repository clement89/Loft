import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/providers/signin_provider.dart';
import 'package:loftfin/services/service_locator.dart';

class MockAPI extends ApiRepository {
  @override
  Future<ApiResponse> validateUserInfo(Map<String, dynamic> phoneNumber) async {
    ApiResponse response = ApiResponse(
        isError: false, data: {"status": "true", "reason": "User exists"});
    return response;
  }

  @override
  Future<ApiResponse> getWelcomeData() async {
    ApiResponse response = ApiResponse(isError: false, data: {
      "data": [
        {
          "title": "Loft me cash",
          "image_url": "https://picsum.photos/200",
          "sub_title":
              "We will Loft you a cash advance up to \$100 when you need it.",
          "redirectUrl": ""
        },
        {
          "title": "Zero fees, tip optional",
          "image_url": "https://picsum.photos/seed/picsum/200/300",
          "sub_title":
              "When you've got cash pay it back with 5% recommended tip",
          "redirectUrl": ""
        },
        {
          "title": "Get rewarded",
          "image_url": "https://picsum.photos/200/300/?blur",
          "sub_title": "Invite a friend to use Loft and you'll each get \$5",
          "redirectUrl": ""
        }
      ]
    });
    return response;
  }
}

void main() async {
  setupLocator();

  await Firebase.initializeApp();
  var viewModel = serviceLocator<SignInProvider>();
  viewModel.apiRepository = MockAPI();

  group('Check user exist in server', () {
    test('Page should load a list of matches from mock server', () async {
      await viewModel.getWelcomeData();
      expect(viewModel.isUserUpdated, false);
    });
  });
}
