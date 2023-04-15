import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loftfin/providers/firebase_auth.dart';
import 'package:loftfin/providers/menu_provider.dart';
import 'package:loftfin/screens/signIn/welcome_screen.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:provider/provider.dart';

class LoftMenu extends StatelessWidget {
  const LoftMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppTheme.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ],
    );
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: decoration,
      width: 150,
      child: Drawer(
        child: Container(
          color: AppTheme.blue,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: size.height * 0.14,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: Image.asset(
                    'assets/images/cloud_menu_top.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: size.height * 0.05,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: Image.asset(
                    'assets/images/cloud_menu_bottom.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Column(
                // padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  ),
                  // ListView(
                  //   shrinkWrap: true,
                  //   padding: EdgeInsets.zero,
                  //   children: [
                  //     ListTile(
                  //       title: Text(
                  //         'Dashboard',
                  //         style: AppTheme.menuTextStyle,
                  //       ),
                  //       onTap: () {
                  //         context
                  //             .read<MenuProvider>()
                  //             .updateMenuSelection(Menu.dashboard);
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  ListTile(
                    title: Text(
                      'Perks',
                      style: AppTheme.menuTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/perks");
                      context.read<MenuProvider>().updateRoutes("/perks");
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Waitlist',
                      style: AppTheme.menuTextStyle,
                    ),
                    onTap: () {
                      //
                      Navigator.pushNamed(context, "/waitList");
                      context.read<MenuProvider>().updateRoutes("/waitList");
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Settings',
                      style: AppTheme.menuTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/settings");
                      context.read<MenuProvider>().updateRoutes("/settings");
                      // context
                      //     .read<MenuProvider>()
                      //     .updateMenuSelection(Menu.settings);
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Notifications',
                      style: AppTheme.menuTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/broadcast");
                      context.read<MenuProvider>().updateRoutes("/broadcast");
                      // context
                      //     .read<MenuProvider>()
                      //     .updateMenuSelection(Menu.settings);
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Reports',
                      style: AppTheme.menuTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/reports");
                      context.read<MenuProvider>().updateRoutes("/reports");
                      // context
                      //     .read<MenuProvider>()
                      //     .updateMenuSelection(Menu.settings);
                      // Navigator.pop(context);
                    },
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'Feedback',
                  //     style: AppTheme.menuTextStyle,
                  //   ),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, "/feedback_reports");
                  //     context
                  //         .read<MenuProvider>()
                  //         .updateRoutes("/feedback_reports");
                  //   },
                  // ),
                  Spacer(),
                  ListTile(
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: AppTheme.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () async {
                      await context.read<FirebaseAuthHandler>().logout();
                      Navigator.pushNamed(context, "/welcome");
                      context.read<MenuProvider>().updateRoutes("/welcome");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => WelcomeScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Version 0.0.20',
                      style: TextStyle(
                        color: AppTheme.darkBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
