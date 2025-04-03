import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkManager with ChangeNotifier {
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  bool get isConnected => _isConnected;

  NetworkManager() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      bool hasInternet = result != ConnectivityResult.none;
      if (_isConnected != hasInternet) {
        _isConnected = hasInternet;
        notifyListeners(); // Notify UI when internet status changes
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
