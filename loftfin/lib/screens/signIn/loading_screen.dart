import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/providers/firebase_auth.dart';
import 'package:loftfin/providers/signin_provider.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  static String routeName = "/loading_screen";

  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseAuthHandler>().isUserLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool screenPushed = false;

  Future addObservers() async {
    dPrint('observing..');
    if (context.watch<FirebaseAuthHandler>().authStatus ==
        AuthStatus.verified) {
      dPrint('verified..');

      if (!screenPushed) {
        screenPushed = true;

        bool statusOne = await context.read<SignInProvider>().checkUserExists();

        if (statusOne) {
          // EasyLoading.dismiss();

          dPrint('Ok here...');
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushNamed(
              context,
              "/perks",
            );
          });
        } else {
          dPrint('Un authorized..');

          bool status = await context.read<SignInProvider>().createUser();

          // EasyLoading.dismiss();

          if (status) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushNamed(
                context,
                "/perks",
              );
            });
          } else {
            context.read<FirebaseAuthHandler>().logout();
            // EasyLoading.showError('Access Denied');
          }
        }
      }
    } else if (context.watch<FirebaseAuthHandler>().authStatus ==
        AuthStatus.verificationFailed) {
      dPrint('verificationFailed..');

      context.read<FirebaseAuthHandler>().authStatus =
          AuthStatus.notAuthenticated;
      // EasyLoading.dismiss();
      // EasyLoading.showError(kStringsAuthFailed);
    } else if (context.watch<FirebaseAuthHandler>().authStatus ==
        AuthStatus.notAuthenticated) {
      dPrint('notAuthenticated..');

      if (!screenPushed) {
        screenPushed = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamed(
            context,
            "/welcome",
          );
        });
      }

      // EasyLoading.dismiss();
    } else {
      dPrint('notDetermined..');
      // EasyLoading.show(status: kStringsVerifyingUser);

      Future.delayed(const Duration(seconds: 2), () {
        // EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    addObservers();
    return Scaffold(
      backgroundColor: AppTheme.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading..',
              style: TextStyle(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
