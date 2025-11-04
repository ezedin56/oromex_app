import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/utils/network_utils.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget child;
  final bool showBanner;
  final Duration bannerDuration;

  const ConnectivityWidget({
    super.key,
    required this.child,
    this.showBanner = true,
    this.bannerDuration = const Duration(seconds: 4),
  });

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  bool _isConnected = true;
  ConnectivityResult _connectionType = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isBannerVisible = true;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await NetworkUtils.isConnected();
    final connectionType = await NetworkUtils.getConnectionStatus();

    if (mounted) {
      setState(() {
        _isConnected = isConnected;
        _connectionType = connectionType;
        _isBannerVisible = !isConnected && widget.showBanner;
      });

      // Auto-hide banner after duration if connected
      if (isConnected && _isBannerVisible) {
        _startBannerTimer();
      }
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription =
        NetworkUtils.connectivityStream.listen((ConnectivityResult result) {
      final isConnected = result != ConnectivityResult.none;

      if (mounted) {
        setState(() {
          _isConnected = isConnected;
          _connectionType = result;
          _isBannerVisible = !isConnected && widget.showBanner;
        });

        // Auto-hide banner when connection is restored
        if (isConnected && _isBannerVisible) {
          _startBannerTimer();
        }

        // Show banner immediately when connection is lost
        if (!isConnected && widget.showBanner) {
          _isBannerVisible = true;
          _cancelBannerTimer();
        }
      }
    });
  }

  void _startBannerTimer() {
    _cancelBannerTimer();
    _bannerTimer = Timer(widget.bannerDuration, () {
      if (mounted) {
        setState(() {
          _isBannerVisible = false;
        });
      }
    });
  }

  void _cancelBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = null;
  }

  void _hideBanner() {
    if (mounted) {
      setState(() {
        _isBannerVisible = false;
      });
    }
    _cancelBannerTimer();
  }

  void _retryConnection() async {
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _cancelBannerTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isConnected && _isBannerVisible) _buildNoConnectionBanner(),
        if (_isConnected && _isBannerVisible) _buildConnectionRestoredBanner(),
      ],
    );
  }

  Widget _buildNoConnectionBanner() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: AppColors.errorColor,
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.wifi_off,
                  color: AppColors.primaryText, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No internet connection',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      NetworkUtils.getConnectionType(_connectionType),
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryText.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.primaryText,
                  size: 20,
                ),
                onPressed: _retryConnection,
                tooltip: 'Retry connection',
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primaryText,
                  size: 20,
                ),
                onPressed: _hideBanner,
                tooltip: 'Hide banner',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionRestoredBanner() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.green,
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.wifi, color: AppColors.primaryText, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection restored',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Connected via ${NetworkUtils.getConnectionType(_connectionType)}',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryText.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primaryText,
                  size: 20,
                ),
                onPressed: _hideBanner,
                tooltip: 'Close',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
