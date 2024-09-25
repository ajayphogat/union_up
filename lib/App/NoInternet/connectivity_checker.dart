import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'no_internet.dart';

class ConnectionStatusListener {

  static final _singleton = ConnectionStatusListener._internal();

  ConnectionStatusListener._internal();

  bool hasShownNoInternet = false;

  final Connectivity _connectivity = Connectivity();

  static ConnectionStatusListener getInstance() => _singleton;

  bool hasConnection = false;

  StreamController connectionChangeController = StreamController.broadcast();

  Stream get connectionChange => connectionChangeController.stream;


  void _connectionChange(List<ConnectivityResult> result) {
    checkConnection();
  }


  Future<bool> checkConnection() async {

    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      hasConnection = false;
    }

    // send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }


  //And check the connection status
  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    await checkConnection();
  }


  void dispose() {
    connectionChangeController.close();
  }
}

updateConnectivity(BuildContext context,
    dynamic hasConnection,
    ConnectionStatusListener connectionStatus

    ) {
  if (!hasConnection) {
    connectionStatus.hasShownNoInternet = true;

    Navigator.push(context, MaterialPageRoute(builder: (context) => const NoInternetScreen(),));
    // Get.to(const );
    // context.push("/"+RoutesName.noInternet);

  } else {

    if (connectionStatus.hasShownNoInternet) {
      connectionStatus.hasShownNoInternet = false;

     Navigator.pop(context);


    }
  }
}

initNoInternetListener(BuildContext context) async {

  var connectionStatus = ConnectionStatusListener.getInstance();
  await connectionStatus.initialize();
  if (!connectionStatus.hasConnection) {
    updateConnectivity(context, false, connectionStatus);
  }
  connectionStatus.connectionChange.listen((event) {
    print("initNoInternetListener $event");
    updateConnectivity(context,event, connectionStatus);
  });
}