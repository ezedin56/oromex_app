// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkUtils {
//   static final Connectivity _connectivity = Connectivity();

//   static Future<bool> isConnected() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }

//   static Future<ConnectivityResult> getConnectionStatus() async {
//     return await _connectivity.checkConnectivity();
//   }

//   static Stream<ConnectivityResult> get connectivityStream {
//     return _connectivity.onConnectivityChanged;
//   }

//   static String getConnectionType(ConnectivityResult result) {
//     switch (result) {
//       case ConnectivityResult.wifi:
//         return 'WiFi';
//       case ConnectivityResult.mobile:
//         return 'Mobile Data';
//       case ConnectivityResult.ethernet:
//         return 'Ethernet';
//       case ConnectivityResult.vpn:
//         return 'VPN';
//       case ConnectivityResult.bluetooth:
//         return 'Bluetooth';
//       case ConnectivityResult.other:
//         return 'Other';
//       default:
//         return 'No Connection';
//     }
//   }

//   static bool isConnectionStable(ConnectivityResult result) {
//     return result == ConnectivityResult.wifi ||
//         result == ConnectivityResult.mobile ||
//         result == ConnectivityResult.ethernet;
//   }
// }
