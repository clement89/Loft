import 'package:flutter/material.dart';
import 'package:loftfin/home_page.dart';
import 'package:loftfin/screens/broadcast_screen.dart';
import 'package:loftfin/screens/signIn/welcome_screen.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    String? routeInfo = routeSettings.name;
    // if (menuRoutes != "") {
    //   routeInfo = menuRoutes;
    // }
    dPrint("inside generate routes ${routeInfo}");
    switch (routeSettings.name) {
      case "/welcome_screen":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);

      case "/perks":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);
      case "/perks/edit_perk":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(routeInfo: routeInfo, args: routeSettings.arguments),
            settings: routeSettings,
            transitionDuration: Duration.zero);

      case "/waitList":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);

      case "/settings":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);
      case "/broadcast":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);

      case "/reports":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);
      case "/feedback_reports":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);

      case "/logout":
        return PageRouteBuilder(
            pageBuilder: (BuildContext ctx, Animation<double> animation,
                    Animation<double> secAnimation) =>
                MyHomePage(
                  routeInfo: routeInfo,
                ),
            settings: routeSettings,
            transitionDuration: Duration.zero);

      default:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => WelcomeScreen(),
        );
    }
  }
}
