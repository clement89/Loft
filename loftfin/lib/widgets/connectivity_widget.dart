import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loftfin/services/internet_check.dart';
import 'package:loftfin/services/log_service.dart';

import '../strings.dart';

class ConnectivityWidget extends StatefulWidget {
  ConnectivityWidget({
    required this.child,
  });

  final Widget child;

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  var connectionStatus;

  @override
  void initState() {
    connectionStatus = ConnectivityStatus.WiFi;
    _updateConnectivityStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dPrint('new connection status - $connectionStatus');
    return connectionStatus == ConnectivityStatus.Offline
        ? ConnectionLostWidget(
            onClickAction: () async {
              Timer(Duration(seconds: 2), () async {
                await _updateConnectivityStatus();
              });
            },
          )
        : widget.child;
  }

  Future _updateConnectivityStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    final Connectivity _connectivity = Connectivity();
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      dPrint(e.toString());
    }
    dPrint(result);

    if (result == ConnectivityResult.none) {
      // showError(context, strings.NO_INTERNET_CONNECTION);
    } else {
      setState(() {
        connectionStatus = _getStatusFromResult(result);
      });
    }
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.WiFi;
    }
  }
}

class ConnectionLostWidget extends StatefulWidget {
  final Function onClickAction;

  const ConnectionLostWidget({
    required this.onClickAction,
  });
  @override
  _ConnectionLostWidgetState createState() => _ConnectionLostWidgetState();
}

class _ConnectionLostWidgetState extends State<ConnectionLostWidget> {
  bool showSpinner = false;

  @override
  void initState() {
    setState(() {
      showSpinner = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  kStringsConnectionLost,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  kStringsConnectionCheck,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    await widget.onClickAction();
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black45, width: 3)),
                    child: Center(
                      child: Text(
                        kStringsTryAgain,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: showSpinner,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        )
      ],
    );
  }
}
