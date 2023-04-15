import 'package:flutter/material.dart';
import 'package:loftfin/providers/firebase_auth.dart';
import 'package:loftfin/screens/broadcast_screen.dart';
import 'package:loftfin/screens/feedback_report_screen.dart';
import 'package:loftfin/screens/perks/edit_perks_screen.dart';
import 'package:loftfin/screens/perks/perk_list_screen.dart';
import 'package:loftfin/screens/report_screen.dart';
import 'package:loftfin/screens/settings_screen.dart';
import 'package:loftfin/screens/signIn/loading_screen.dart';
import 'package:loftfin/screens/signIn/welcome_screen.dart';
import 'package:loftfin/screens/waitlist_screen.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/loft_menu.dart';
import 'package:loftfin/widgets/responsive.dart';
import 'package:provider/provider.dart';

import 'models/perk.dart';

class MyHomePage extends StatefulWidget {
  final String? routeInfo;
  final Object? args;
  const MyHomePage({this.routeInfo, Key? key, this.args}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List split = [];
  Widget buildBody({bool isMoblie = false}) {
    String? routeInfo = widget.routeInfo;
    dPrint('Route info - ${widget.routeInfo}');
    // if (context.read<MenuProvider>().selecetedRoutes != "") {
    //   routeInfo = context.read<MenuProvider>().selecetedRoutes;
    // }
    if (routeInfo != null) {
      switch (routeInfo) {
        case "/welcome":
          return WelcomeScreen();
        case "/perks":
          return PerkListScreen();
        case "/perks/edit_perk":
          return widget.args == null
              ? EditPerksScreen()
              : EditPerksScreen(perk: widget.args as Perk);
        case "/waitList":
          return WaitListScreen();
        case "/settings":
          return SettingsScreen();
        case "/logout":
          return WelcomeScreen();
        case "/broadcast":
          return BroadcastScreen();
        case "/reports":
          return ReportScreen();
        case "/feedback_reports":
          return FeedbackReportScreen();
        case "/404":
          return WelcomeScreen();
        default:
          return LoadingScreen();
      }
    } else {
      context.read<FirebaseAuthHandler>().authStatus = AuthStatus.notDetermined;
      context.read<FirebaseAuthHandler>().isUserLoggedIn();
      return LoadingScreen();
    }
  }

  PreferredSizeWidget _appBar(String title) {
    return CustomAppBar(
      title: title,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppTheme.blue,
        ),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.routeInfo != null) {
      split = widget.routeInfo!.split("/");
    }

    //  if (context.read<FirebaseAuthHandler>().isUserLoggedIn()) {
    //   AppSettings.instance.currentUser = LoftUser(
    //     userId: '',
    //     firstName: '',
    //     lastName: '',
    //     email: '',
    //     zipcode: '',
    //   );
    //   Navigator.of(context).pushReplacementNamed(BaseScreen.routeName);
    // } else {
    //   Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
    // }

    return Scaffold(
      // appBar:
      //     widget.routeInfo == "/welcome" || widget.routeInfo == "/splash_screen"
      //         ? null
      //         : _appBar("test"),
      drawerScrimColor: Colors.transparent,
      key: _scaffoldKey,
      drawer: const LoftMenu(),
      body: Responsive(
        mobile: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu)),
            Expanded(
              child: buildBody(isMoblie: true),
            ),
          ],
        ),
        tablet: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu)),
            Expanded(
              child: buildBody(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            widget.routeInfo != null
                ? const Expanded(child: LoftMenu())
                : Offstage(),
            Expanded(
              flex: 5,
              child: Container(
                child: buildBody(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
