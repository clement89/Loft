import 'package:loftfin/models/loft_user.dart';

class AppSettings {
  AppSettings._privateConstructor();

  static final AppSettings _instance = AppSettings._privateConstructor();

  static AppSettings get instance => _instance;

  LoftUser currentUser = LoftUser(
    userId: '',
    firstName: '',
    lastName: '',
    email: '',
    zipcode: '',
  );
}
