import 'package:flutter/cupertino.dart';

enum Menu {
  dashboard,
  perks,
  waitList,
  settings,
  reports,
  notifications,
  feedback,
}

class MenuProvider with ChangeNotifier {
  Menu selectedMenu = Menu.dashboard;
  String selecetedRoutes = "";

  void updateMenuSelection(Menu selection) {
    selectedMenu = selection;
    notifyListeners();
  }

  void updateRoutes(String selection) {
    selecetedRoutes = selection;
    notifyListeners();
  }
}
