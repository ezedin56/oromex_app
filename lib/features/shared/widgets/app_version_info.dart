import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';

class AppVersionInfo extends StatefulWidget {
  final bool showBuildNumber;

  const AppVersionInfo({super.key, this.showBuildNumber = false});

  @override
  State<AppVersionInfo> createState() => _AppVersionInfoState();
}

class _AppVersionInfoState extends State<AppVersionInfo> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Version ${_packageInfo.version}',
          style: TextStyles.caption.copyWith(
            color: AppColors.primaryText.withOpacity(0.5),
          ),
        ),
        if (widget.showBuildNumber) ...[
          const SizedBox(height: 2),
          Text(
            'Build ${_packageInfo.buildNumber}',
            style: TextStyles.overline.copyWith(
              color: AppColors.primaryText.withOpacity(0.3),
            ),
          ),
        ],
      ],
    );
  }
}
