import 'package:flutter/material.dart';
import 'package:seats_reserve/models/seat.dart';
import 'package:seats_reserve/models/reservation.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class InteractiveSeatMap extends StatelessWidget {
  final List<Seat> seats;
  final List<Reservation> todayReservations;
  final int? selectedSeatId;
  final Function(int) onSeatTap;

  const InteractiveSeatMap({
    super.key,
    required this.seats,
    required this.todayReservations,
    required this.selectedSeatId,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: seats.length,
      itemBuilder: (context, index) {
        final seat = seats[index];
        final reservation = todayReservations.firstWhere(
          (r) => r.seatId == seat.id,
          orElse: () => Reservation(id: '', studentId: '', seatId: -1, reservationDate: DateTime.now(), reservedAt: DateTime.now(), status: '', createdAt: DateTime.now()),
        );

        bool isReserved = reservation.seatId != -1;
        bool isOccupied = isReserved && (reservation.status == 'present');
        bool isDisabled = seat.status == 'disabled';
        bool isSelected = selectedSeatId == seat.id;

        Color seatColor = Colors.green; // Available
        if (isDisabled) seatColor = Colors.grey[300]!;
        if (isReserved) seatColor = Colors.orange;
        if (isOccupied) seatColor = Colors.red;
        if (isSelected) seatColor = AppTheme.primaryColor;

        return GestureDetector(
          onTap: (isReserved || isDisabled) ? null : () => onSeatTap(seat.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: seatColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)] : [],
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDisabled ? Icons.block : Icons.event_seat,
                  color: isDisabled ? Colors.grey : Colors.white,
                  size: 20,
                ),
                Text(
                  seat.seatNumber.replaceAll('Seat ', ''),
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
