import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class UserConnectivity extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const UserConnectivity(
      {super.key, required this.onInit, required this.child});

  @override
  State<UserConnectivity> createState() => _UserConnectivityState();
}

class _UserConnectivityState extends State<UserConnectivity> {
  bool isOnline = false;
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
    checkConnectionStatus();
  }

  Future<void> checkConnectionStatus() async {
    bool isConnected = await checkConnectivity();
    setState(() {
      isOnline = isConnected;
    });
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isOnline ? 'Online' : 'Offline',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
