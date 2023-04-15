import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:loftfin/models/api_response.dart';
import 'package:loftfin/models/perk.dart';
import 'package:loftfin/networking/api_repository.dart';
import 'package:loftfin/services/log_service.dart';

class BroadcastProvider with ChangeNotifier {
  final title = TextEditingController();
  final message = TextEditingController();
  bool titleError = false;
  bool messageError = false;
}
