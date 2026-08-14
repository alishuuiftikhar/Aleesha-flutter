import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class ReservationCountdown extends StatefulWidget {
  final String deadlineStr; // Format "HH:MM:SS"
  final DateTime serverTime;

  const ReservationCountdown({
    super.key,
    required this.deadlineStr,
    required this.serverTime,
  });

  @override
  State<ReservationCountdown> createState() => _ReservationCountdownState();
}

class _ReservationCountdownState extends State<ReservationCountdown> {
  late Timer _timer;
  late Duration _remainingTime;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemainingTime();
    });
  }

  void _calculateRemainingTime() {
    final now = DateTime.now(); // Using local for UI update, but server time is better for logic
    final parts = widget.deadlineStr.split(':');
    final deadline = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));

    if (now.isAfter(deadline)) {
      setState(() {
        _remainingTime = Duration.zero;
        _isExpired = true;
      });
      _timer.cancel();
    } else {
      setState(() {
        _remainingTime = deadline.difference(now);
        _isExpired = false;
      });
    }
  }

  @override
  void didUpdateWidget(ReservationCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadlineStr != widget.deadlineStr) {
      _timer.cancel();
      _calculateRemainingTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _calculateRemainingTime();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_remainingTime.inHours);
    final minutes = twoDigits(_remainingTime.inMinutes.remainder(60));
    final seconds = twoDigits(_remainingTime.inSeconds.remainder(60));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isExpired ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isExpired ? Colors.red[200]! : Colors.green[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isExpired ? 'Reservation Closed' : 'Reservation Open',
                style: TextStyle(
                  color: _isExpired ? Colors.red[700] : Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                'Deadline: ${widget.deadlineStr}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Time Remaining', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text(
                '$hours:$minutes:$seconds',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _isExpired ? Colors.red : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
