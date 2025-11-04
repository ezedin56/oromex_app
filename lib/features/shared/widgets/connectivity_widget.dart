// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../app/theme/colors.dart';
// import '../../../app/theme/text_styles.dart';
// import '../../../core/utils/network_utils.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class ConnectivityWidget extends StatefulWidget {
//   final Widget child;

//   const ConnectivityWidget({super.key, required this.child});

//   @override
//   State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
// }

// class _ConnectivityWidgetState extends State<ConnectivityWidget> {
//   bool _isConnected = true;
//   ConnectivityResult _connectionType = ConnectivityResult.none;
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//   bool _isBannerVisible = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkConnectivity();
//     _setupConnectivityListener();
//   }

//   Future<void> _checkConnectivity() async {
//     final isConnected = await NetworkUtils.isConnected();
//     final connectionType = await NetworkUtils.getConnectionStatus();

//     if (mounted) {
//       setState(() {
//         _isConnected = isConnected;
//         _connectionType = connectionType;
//         _isBannerVisible = !isConnected; // Show banner only when disconnected
//       });
//     }
//   }

//   void _setupConnectivityListener() {
//     _connectivitySubscription =
//         NetworkUtils.connectivityStream.listen((ConnectivityResult result) {
//       final isConnected = result != ConnectivityResult.none;

//       if (mounted) {
//         setState(() {
//           _isConnected = isConnected;
//           _connectionType = result;
//           _isBannerVisible =
//               !isConnected; // Show banner when connection is lost
//         });
//       }
//     });
//   }

//   void _hideBanner() {
//     if (mounted) {
//       setState(() {
//         _isBannerVisible = false;
//       });
//     }
//   }

//   void _retryConnection() async {
//     await _checkConnectivity();
//   }

//   @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         widget.child,
//         if (!_isConnected && _isBannerVisible) _buildNoConnectionBanner(),
//       ],
//     );
//   }

//   Widget _buildNoConnectionBanner() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: Material(
//         color: AppColors.errorColor,
//         elevation: 4,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             children: [
//               const Icon(Icons.wifi_off,
//                   color: AppColors.primaryText, size: 20),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'No internet connection',
//                       style: TextStyles.bodyMedium.copyWith(
//                         color: AppColors.primaryText,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       _getConnectionTypeText(),
//                       style: TextStyles.bodySmall.copyWith(
//                         color: AppColors.primaryText.withOpacity(0.8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               IconButton(
//                 icon: const Icon(
//                   Icons.refresh,
//                   color: AppColors.primaryText,
//                   size: 20,
//                 ),
//                 onPressed: _retryConnection,
//                 tooltip: 'Retry connection',
//               ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.close,
//                   color: AppColors.primaryText,
//                   size: 20,
//                 ),
//                 onPressed: _hideBanner,
//                 tooltip: 'Hide banner',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getConnectionTypeText() {
//     switch (_connectionType) {
//       case ConnectivityResult.wifi:
//         return 'Connected to WiFi';
//       case ConnectivityResult.mobile:
//         return 'Connected to mobile data';
//       case ConnectivityResult.ethernet:
//         return 'Connected to Ethernet';
//       case ConnectivityResult.vpn:
//         return 'Connected via VPN';
//       case ConnectivityResult.bluetooth:
//         return 'Connected via Bluetooth';
//       case ConnectivityResult.other:
//         return 'Connected to other network';
//       case ConnectivityResult.none:
//         return 'No network connection';
//     }
//   }
// }
