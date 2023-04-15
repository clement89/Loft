import 'package:get_it/get_it.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/providers/signin_provider.dart';

import 'navigation_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerSingleton<NavigationService>(NavigationService());
  serviceLocator.registerLazySingleton(() => ApiRepository());
  serviceLocator.registerLazySingleton(() => SignInProvider());
}
