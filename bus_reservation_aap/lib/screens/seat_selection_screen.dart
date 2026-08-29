import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/booking_provider.dart';
import 'passenger_info_screen.dart';

class SeatSelectionScreen extends StatelessWidget {
  final Map<String, dynamic> route;

  const SeatSelectionScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _legendItem('Available', Colors.white, Colors.grey),
                _legendItem('Selected', AppColors.accent, AppColors.accent),
                _legendItem('Booked', Colors.grey[300]!, Colors.grey[400]!),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.secondaryBackground),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Icon(Icons.radio_button_checked, size: 40, color: Colors.grey), // Steering wheel
                    ),
                  ),
                  Expanded(
                    child: Consumer<BookingProvider>(
                      builder: (context, provider, child) {
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: route['totalSeats'],
                          itemBuilder: (context, index) {
                            final seatNumber = index + 1;
                            bool isBooked = provider.bookedSeats.contains(seatNumber);
                            bool isSelected = provider.selectedSeats.contains(seatNumber);

                            // Add a gap for the aisle
                            bool isAisle = (index % 4 == 1);

                            return GestureDetector(
                              onTap: isBooked ? null : () => provider.toggleSeat(seatNumber),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isBooked
                                      ? Colors.grey[300]
                                      : isSelected
                                          ? AppColors.accent
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: isBooked
                                        ? Colors.grey[400]!
                                        : isSelected
                                            ? AppColors.accent
                                            : AppColors.secondary,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '$seatNumber',
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppColors.text,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _bottomBar(context),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final selectedCount = provider.selectedSeats.length;
        final double totalPrice = selectedCount * (route['basePrice'] as num).toDouble();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$selectedCount Seats Selected', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Total: \$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: selectedCount > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PassengerInfoScreen(route: route, totalPrice: totalPrice),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('PROCEED'),
              ),
            ],
          ),
        );
      },
    );
  }
}
