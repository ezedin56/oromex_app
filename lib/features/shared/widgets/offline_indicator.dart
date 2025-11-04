import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/utils/network_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineIndicator extends StatefulWidget {
  final bool showMessage;

  const OfflineIndicator({super.key, this.showMessage = true});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await NetworkUtils.isConnected();
    setState(() {
      _isConnected = isConnected;
    });
  }

  void _setupConnectivityListener() {
    NetworkUtils.connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withOpacity(0.1),
        border: Border.all(color: AppColors.warningColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, color: AppColors.warningColor, size: 16),
          const SizedBox(width: 8),
          Text(
            'Offline',
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.warningColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.showMessage) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Some features may not be available',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.warningColor.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
