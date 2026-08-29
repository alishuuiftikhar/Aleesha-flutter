import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/booking_provider.dart';
import 'seat_selection_screen.dart';

class BusListScreen extends StatelessWidget {
  final String from;
  final String to;
  final String date;

  const BusListScreen({super.key, required this.from, required this.to, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$from to $to', style: const TextStyle(fontSize: 18)),
            Text(date, style: const TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bus_alert, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text('No buses found for this route', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final route = provider.searchResults[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(route['busName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                Text(route['busType'], style: const TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text('\$${route['basePrice']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent)),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(route['departureTime'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(route['departureCity'], style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const Column(
                            children: [
                              Icon(Icons.arrow_forward, color: AppColors.secondary),
                              Text('6h 00m', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(route['arrivalTime'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(route['destinationCity'], style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            provider.loadBookedSeats(route['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatSelectionScreen(route: route),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('SELECT SEATS'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
