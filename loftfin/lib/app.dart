import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loftfin/home_page.dart';
import 'package:loftfin/navigation/routes.dart';
import 'package:loftfin/providers/broadcast_provider.dart';
import 'package:loftfin/providers/feedback_provider.dart';
import 'package:loftfin/providers/firebase_auth.dart';
import 'package:loftfin/providers/menu_provider.dart';
import 'package:loftfin/providers/perk_provider.dart';
import 'package:loftfin/providers/settings_provider.dart';
import 'package:loftfin/providers/signin_provider.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:provider/provider.dart';

import 'services/internet_check.dart';

class MyApp extends StatelessWidget {
  final appNavigator = AppNavigator();
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        try {
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }
        } catch (e) {
          print(e);
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return app();
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }

  Widget app() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                FirebaseAuthHandler(auth: FirebaseAuth.instance)),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => PerksProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => BroadcastProvider()),
        ChangeNotifierProvider(create: (context) => ReportsProvider()),
      ],
      child: StreamProvider<ConnectivityStatus>(
        initialData: ConnectivityStatus.WiFi,
        create: (context) {
          return ConnectivityService().connectionStatusController.stream;
        },
        child: MaterialApp(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
          },
          onGenerateRoute: appNavigator.onGenerateRoute,
          debugShowCheckedModeBanner: false,
          //navigatorKey: serviceLocator<NavigationService>().navigatorKey,
          title: 'LoftFin',
          supportedLocales: [
            Locale('en'),
          ],
          // routes: {
          //   SplashScreen.routeName: (context) => SplashScreen(),
          //   WelcomeScreen.routeName: (context) => WelcomeScreen(),
          //   PerkListScreen.routeName: (context) => PerkListScreen(),
          //   BaseScreen.routeName: (context) => BaseScreen(),
          //   EditPerksScreen.routeName: (context) => EditPerksScreen(),
          // },
          theme: ThemeData(
            primaryColor: AppTheme.blue,
            backgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MyHomePage(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: Center(
            child: Icon(
              Icons.error_outline_outlined,
              color: Colors.pink,
              size: 50.0,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
