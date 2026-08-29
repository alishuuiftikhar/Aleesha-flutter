import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/destination.dart';
import '../models/booking.dart';
import '../providers/travel_provider.dart';
import '../theme.dart';

class BookingFormScreen extends StatefulWidget {
  final Destination destination;

  const BookingFormScreen({super.key, required this.destination});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  int _travelers = 1;
  final _formKey = GlobalKey<FormState>();

  void _confirmBooking() {
    final booking = Booking(
      id: const Uuid().v4(),
      destination: widget.destination,
      bookingDate: DateTime.now(),
      travelDate: _selectedDate,
      travelers: _travelers,
      totalPrice: widget.destination.price * _travelers,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TravelTheme.bgSecondary,
        title: const Text('Confirm Booking', style: TextStyle(color: TravelTheme.textMain)),
        content: Text(
          'Do you want to confirm your booking for ${widget.destination.name}?',
          style: const TextStyle(color: TravelTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: TravelTheme.secondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TravelProvider>(context, listen: false).addBooking(booking);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking Confirmed!'),
                  backgroundColor: TravelTheme.success,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.destination.price * _travelers;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDestinationInfo(),
              const SizedBox(height: 30),
              _buildDatePicker(),
              const SizedBox(height: 25),
              _buildTravelersCount(),
              const SizedBox(height: 40),
              _buildSummary(totalPrice),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  child: const Text('Confirm and Pay', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TravelTheme.bgSecondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.destination.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.destination.name,
                style: const TextStyle(
                  color: TravelTheme.textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.destination.location,
                style: const TextStyle(color: TravelTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Travel Date',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: TravelTheme.textMain),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: TravelTheme.primary,
                      onPrimary: TravelTheme.bgMain,
                      surface: TravelTheme.bgSecondary,
                      onSurface: TravelTheme.textMain,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) setState(() => _selectedDate = date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: TravelTheme.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(color: TravelTheme.textMain, fontSize: 16),
                ),
                const Icon(Icons.calendar_today, color: TravelTheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelersCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Travelers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: TravelTheme.textMain),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _countBtn(Icons.remove, () {
              if (_travelers > 1) setState(() => _travelers--);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _travelers.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TravelTheme.textMain),
              ),
            ),
            _countBtn(Icons.add, () {
              setState(() => _travelers++);
            }),
          ],
        ),
      ],
    );
  }

  Widget _countBtn(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: TravelTheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: TravelTheme.bgMain),
      ),
    );
  }

  Widget _buildSummary(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TravelTheme.cardBg.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TravelTheme.cardBg.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _summaryRow('Base Price', '\$${widget.destination.price}'),
          const SizedBox(height: 10),
          _summaryRow('Travelers', 'x $_travelers'),
          const Divider(color: TravelTheme.textSecondary),
          _summaryRow('Total Price', '\$$total', isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? TravelTheme.textMain : TravelTheme.textSecondary,
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? TravelTheme.primary : TravelTheme.textMain,
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
