import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hotel_model.dart';
import '../services/hotel_service.dart';

class RoomListScreen extends StatefulWidget {
  final Hotel hotel;

  const RoomListScreen({super.key, required this.hotel});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final HotelService _hotelService = HotelService();
  List<Room> _rooms = [];
  bool _isLoading = true;

  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  void _fetchRooms() async {
    try {
      final list = await _hotelService.getRooms(widget.hotel.id);
      setState(() => _rooms = list);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading rooms: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectDatesAndBook(Room room) async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'SELECT STAY DATES',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF0F4C81),
            colorScheme: const ColorScheme.light(primary: Color(0xFF0F4C81)),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      final checkIn = pickedRange.start;
      final checkOut = pickedRange.end;
      final nights = checkOut.difference(checkIn).inDays;
      final totalPrice = nights * room.pricePerNight;

      if (!mounted) return;

      // Show Confirmation Dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hotel: ${widget.hotel.name}'),
              Text('Room: ${room.roomNumber} (${room.roomType})'),
              const SizedBox(height: 8),
              Text('Check-In: ${DateFormat('yyyy-MM-dd').format(checkIn)}'),
              Text('Check-Out: ${DateFormat('yyyy-MM-dd').format(checkOut)}'),
              Text('Total Nights: $nights'),
              const Divider(),
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F4C81),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                _processBooking(room.id, checkIn, checkOut, totalPrice);
              },
              child: const Text('CONFIRM & BOOK'),
            ),
          ],
        ),
      );
    }
  }

  void _processBooking(
      String roomId, DateTime checkIn, DateTime checkOut, double totalPrice) async {
    try {
      await _hotelService.createBooking(
        roomId: roomId,
        checkIn: checkIn,
        checkOut: checkOut,
        totalPrice: totalPrice,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking Confirmed Successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.hotel.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
          ? const Center(child: Text('No rooms available for this hotel.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F4C81).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.king_bed,
                  color: Color(0xFF0F4C81),
                ),
              ),
              title: Text(
                'Room ${room.roomNumber} (${room.roomType})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Capacity: ${room.capacity} Guests'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${room.pricePerNight.toStringAsFixed(0)} / night',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () => _selectDatesAndBook(room),
                    child: const Text('Book Now', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}