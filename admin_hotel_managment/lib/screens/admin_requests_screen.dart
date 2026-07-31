import 'package:flutter/material.dart';
import '../models/admin_model.dart';
import '../services/admin_service.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  final AdminService _service = AdminService();
  List<AdminBooking> _bookings = [];
  List<RoomModel> _availableRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final bookings = await _service.getAllCustomerBookings();
      final rooms = await _service.getAvailableRooms();
      if (!mounted) return;
      setState(() {
        _bookings = bookings;
        _availableRooms = rooms;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAssignRoomDialog(AdminBooking booking) {
    RoomModel? selectedRoom;
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text('Assign Room for ${booking.customerName}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<RoomModel>(
                    isExpanded: true,
                    hint: const Text('Select Available Room'),
                    value: selectedRoom,
                    items: _availableRooms.map((room) {
                      return DropdownMenuItem<RoomModel>(
                        value: room,
                        child: Text(
                          'Room ${room.roomNumber} - ${room.roomType} (PKR ${room.pricePerNight})',
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedRoom = val;
                        if (val != null) {
                          priceController.text =
                              val.pricePerNight.toStringAsFixed(0);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Price (PKR)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (selectedRoom == null) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a room from dropdown!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final price = double.tryParse(priceController.text) ??
                        selectedRoom!.pricePerNight;

                    try {
                      await _service.assignRoomAndApprove(
                        bookingId: booking.id,
                        roomId: selectedRoom!.id,
                        totalPrice: price,
                      );

                      if (!mounted) return;
                      Navigator.pop(ctx);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _fetchData();

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Room Assigned & Approved Successfully!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Approve Booking',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Booking Requests'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
          ? const Center(child: Text('No Booking Requests Yet'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final b = _bookings[index];
          final isPending = b.status.toLowerCase() == 'pending';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isPending
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          b.status,
                          style: TextStyle(
                            color: isPending
                                ? Colors.orange.shade900
                                : Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text('Hotel: ${b.hotelName}'),
                  Text('Phone: ${b.customerPhone}'),
                  Text('Dates: ${b.checkIn} to ${b.checkOut}'),
                  Text('Assigned Room: ${b.roomNumber} (${b.roomType})'),
                  const SizedBox(height: 12),
                  if (isPending)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4C81),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _showAssignRoomDialog(b),
                        icon: const Icon(Icons.meeting_room),
                        label: const Text(
                          'Assign Free Room & Approve',
                        ),
                      ),
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