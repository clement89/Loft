import 'package:flutter/cupertino.dart';
import 'package:loftfin/providers/menu_provider.dart';
import 'package:loftfin/screens/broadcast_screen.dart';
import 'package:loftfin/screens/feedback_report_screen.dart';
import 'package:loftfin/screens/perks/perk_list_screen.dart';
import 'package:loftfin/screens/report_screen.dart';
import 'package:loftfin/screens/settings_screen.dart';
import 'package:loftfin/screens/waitlist_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  static String routeName = "/base_screen";

  const BaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menu, child) {
        switch (menu.selectedMenu) {
          case Menu.dashboard:
            return PerkListScreen();

          case Menu.perks:
            return PerkListScreen();

          case Menu.waitList:
            return WaitListScreen();

          case Menu.settings:
            return SettingsScreen();
          case Menu.reports:
            return ReportScreen();
          case Menu.feedback:
            return FeedbackReportScreen();
          case Menu.notifications:
            return BroadcastScreen();
          default:
            return PerkListScreen();
        }
      },
    );
  }
}
