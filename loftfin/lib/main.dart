import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:loftfin/services/service_locator.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(
    name: 'dev',
    color: Colors.green,
    location: BannerLocation.bottomStart,
    variables: {
      'dev': 'dev',
      'BASE_URL': 'https://api.prod.loftfin.com/api/loftfin/v1/',
      // 'BASE_URL': 'https://api.staging.loftfin.com/api/loftfin/v1/',
      // 'BASE_URL':
      //     'http://loft-staging-lb-1614271584.us-east-1.elb.amazonaws.com/api/loftfin/v1/',
    },
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  runApp(
    MyApp(),
  );
}
