// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
//
// class NetworkManager with ChangeNotifier {
//   bool _isConnected = true;
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<ConnectivityResult>? _subscription;
//
//   bool get isConnected => _isConnected;
//
//   NetworkManager() {
//     _subscription = _connectivity.onConnectivityChanged.listen((result) {
//       bool hasInternet = result != ConnectivityResult.none;
//       if (_isConnected != hasInternet) {
//         _isConnected = hasInternet;
//         notifyListeners(); // Notify UI when internet status changes
//       }
//     });
//   }
//
//   void dispose() {
//     _subscription?.cancel();
//   }
// }



import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkManager with ChangeNotifier {
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  final List<VoidCallback> _onReconnectCallbacks = [];

  bool get isConnected => _isConnected;

  NetworkManager() {
    _initConnectionStatus(); // 👈 Check once on app start

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      bool hasInternet = result != ConnectivityResult.none;
      if (_isConnected != hasInternet) {
        _isConnected = hasInternet;
        notifyListeners();

        if (_isConnected) {
          for (final cb in _onReconnectCallbacks) {
            cb(); // 🔁 Call all reconnect callbacks
          }
        }
      }
    });
  }

  Future<void> _initConnectionStatus() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    notifyListeners(); // 👈 Ensure the UI gets initial status
  }

  void onReconnect(VoidCallback callback) {
    _onReconnectCallbacks.add(callback);
  }

  void dispose() {
    _subscription?.cancel();
  }
}