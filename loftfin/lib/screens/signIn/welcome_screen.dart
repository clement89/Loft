import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:loftfin/providers/firebase_auth.dart';
import 'package:loftfin/providers/signin_provider.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:provider/provider.dart';

import '../../strings.dart';

class WelcomeScreen extends StatefulWidget {
  static String routeName = "/welcome_screen";

  WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseAuthHandler>().isUserLoggedIn();
  }

  @override
  void dispose() {
    // EasyLoading.show(status: kStringsVerifyingUser);
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
          EasyLoading.dismiss();

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

          EasyLoading.dismiss();

          if (status) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushNamed(
                context,
                "/perks",
              );
            });
          } else {
            context.read<FirebaseAuthHandler>().logout();
            EasyLoading.showError('Access Denied');
          }
        }
      }
    } else if (context.watch<FirebaseAuthHandler>().authStatus ==
        AuthStatus.verificationFailed) {
      dPrint('verificationFailed..');

      context.read<FirebaseAuthHandler>().authStatus =
          AuthStatus.notAuthenticated;
      EasyLoading.dismiss();
      EasyLoading.showError(kStringsAuthFailed);
    } else if (context.watch<FirebaseAuthHandler>().authStatus ==
        AuthStatus.notAuthenticated) {
      dPrint('notAuthenticated..');

      EasyLoading.dismiss();
    } else {
      dPrint('notDetermined..');
      EasyLoading.show(status: kStringsVerifyingUser);

      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    addObservers();
    return Scaffold(
      backgroundColor: AppTheme.blue,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.35,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                // height: size.height * 0.5,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/header_clouds.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: size.height * 0.1),
              SizedBox(
                height: 150,
                width: 150,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/loft_logo.png',
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          'Admin',
                          style: TextStyle(
                            color: AppTheme.darkBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Spacer(),
              SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () async {
                          screenPushed = false;
                          EasyLoading.show(status: kStringsVerifyingUser);

                          await context
                              .read<FirebaseAuthHandler>()
                              .signInUsingGoogle();
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
