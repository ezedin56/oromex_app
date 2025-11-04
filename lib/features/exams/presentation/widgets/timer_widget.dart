import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

class TimerWidget extends StatefulWidget {
  final int duration; // in minutes
  final VoidCallback onTimeUp;

  const TimerWidget({
    super.key,
    required this.duration,
    required this.onTimeUp,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _remainingSeconds = 0;
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration * 60;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingSeconds),
    )..addListener(_updateTimer);

    _startTimer();
  }

  void _startTimer() {
    _controller.reverse(from: 1.0);
  }

  void _updateTimer() {
    final elapsedSeconds = (widget.duration * 60 * _controller.value).toInt();
    setState(() {
      _remainingSeconds = (widget.duration * 60) - elapsedSeconds;

      if (_remainingSeconds <= 0 && !_isTimeUp) {
        _isTimeUp = true;
        widget.onTimeUp();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Color _getTimerColor() {
    if (_remainingSeconds <= 300) {
      // 5 minutes
      return AppColors.errorColor;
    } else if (_remainingSeconds <= 600) {
      // 10 minutes
      return AppColors.warningColor;
    }
    return AppColors.successColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTimerColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getTimerColor()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: _getTimerColor(), size: 16),
          const SizedBox(width: 6),
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyles.bodyMedium.copyWith(
              color: _getTimerColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
