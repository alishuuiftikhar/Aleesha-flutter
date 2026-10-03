import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_colors.dart';
import '../../services/salon_provider.dart';
import 'booking_success_screen.dart';

class BookingStepperScreen extends ConsumerStatefulWidget {
  const BookingStepperScreen({super.key});

  @override
  ConsumerState<BookingStepperScreen> createState() => _BookingStepperScreenState();
}

class _BookingStepperScreenState extends ConsumerState<BookingStepperScreen> {
  int _currentStep = 0;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTime;
  Map<String, String>? _selectedStylist;
  bool _isBooking = false;

  final List<String> _timeSlots = ['09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM'];
  
  final List<Map<String, String>> _stylists = [
    {'id': '1', 'name': 'Emma Wilson', 'role': 'Master Stylist', 'img': 'https://i.pravatar.cc/150?u=1'},
    {'id': '2', 'name': 'Sophia Chen', 'role': 'Color Expert', 'img': 'https://i.pravatar.cc/150?u=2'},
    {'id': '3', 'name': 'Olivia Rose', 'role': 'Makeup Artist', 'img': 'https://i.pravatar.cc/150?u=3'},
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _confirmBooking();
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _isBooking = true);
    
    // In a real app, salonId would come from the previous screen
    const salonId = 'demo-salon-id'; 
    final success = await ref.read(salonServiceProvider).createBooking(
      salonId: salonId,
      staffId: _selectedStylist?['id'] ?? '',
      date: _selectedDay,
      time: _selectedTime ?? '',
      price: 45.0,
      serviceIds: ['classic-haircut-id'],
    );

    setState(() => _isBooking = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookingSuccessScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create booking. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Book Appointment', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildProgressIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildStepContent(),
                ),
              ),
            ],
          ),
          if (_isBooking)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5.0))],
        ),
        child: ElevatedButton(
          onPressed: (_canProceed() && !_isBooking) ? _nextStep : null,
          child: Text(_currentStep == 3 ? 'Confirm & Book' : 'Continue'),
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_currentStep == 0) return true;
    if (_currentStep == 1) return _selectedStylist != null;
    if (_currentStep == 2) return _selectedTime != null;
    return true;
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          bool isActive = _currentStep >= index;
          return Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.softRose,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: isActive ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (index < 3)
                Container(
                  width: 40,
                  height: 2,
                  color: _currentStep > index ? AppColors.primary : AppColors.softRose,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0: return _buildServiceSelection();
      case 1: return _buildStylistSelection();
      case 2: return _buildDateTimeSelection();
      case 3: return _buildSummary();
      default: return const SizedBox();
    }
  }

  Widget _buildServiceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Services ✨', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        const SizedBox(height: 16),
        _serviceItem('Classic Haircut', r'$45', true),
        _serviceItem('Deep Conditioning', r'$30', false),
        _serviceItem('Scalp Massage', r'$20', false),
      ],
    );
  }

  Widget _serviceItem(String name, String price, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.softRose : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
          Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStylistSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Your Stylist 💕', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        const SizedBox(height: 20),
        ..._stylists.map((stylist) {
          bool isSelected = _selectedStylist?['id'] == stylist['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedStylist = stylist),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(stylist['img']!)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stylist['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(stylist['role']!, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick Date & Time 🌸', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        const SizedBox(height: 16),
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            todayDecoration: const BoxDecoration(color: AppColors.softRose, shape: BoxShape.circle),
            todayTextStyle: const TextStyle(color: AppColors.primary),
          ),
          headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        ),
        const SizedBox(height: 24),
        const Text('Available Slots', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _timeSlots.map((time) {
            bool isSelected = _selectedTime == time;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = time),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.mainText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Appointment ✨', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        const SizedBox(height: 24),
        _summaryRow('Stylist', _selectedStylist?['name'] ?? ''),
        _summaryRow('Date', '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}'),
        _summaryRow('Time', _selectedTime ?? ''),
        const Divider(height: 40),
        _summaryRow('Total', r'$45.00', isTotal: true),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.softRose,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Payment will be collected at the salon after your service.',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.secondaryText, fontSize: isTotal ? 18.0 : 14.0)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 24.0 : 16.0, color: AppColors.mainText)),
        ],
      ),
    );
  }
}
