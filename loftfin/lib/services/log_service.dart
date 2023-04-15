import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logger/logger.dart';

enum LogType { verbose, debug, info, warning, error }

void dPrint(dynamic message) {
  if (FlavorConfig.instance.variables['env'] != 'prod') {
    //if(true){
    print(message);
    // var logger = Logger(filter: null, output: null, printer: PrettyPrinter());
    // logger.i(message.toString());
  }
}

void customLog({required String message, LogType? logType}) {
  if (FlavorConfig.instance.variables['env'] != 'prod') {
    var logger = Logger(filter: null, output: null, printer: PrettyPrinter());
    switch (logType) {
      case LogType.verbose:
        {
          logger.v(message);
        }
        break;

      case LogType.debug:
        {
          logger.d(message);
        }
        break;

      case LogType.info:
        {
          logger.i(message);
        }
        break;

      case LogType.warning:
        {
          logger.w(message);
        }
        break;

      case LogType.error:
        {
          logger.e(message);
        }
        break;

      default:
        {
          logger.d(message);
        }
        break;
    }
  }
}
