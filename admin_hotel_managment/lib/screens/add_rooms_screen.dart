import 'package:flutter/material.dart';
import '../models/admin_model.dart';
import '../services/admin_service.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final AdminService _service = AdminService();
  final _roomNumCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  List<Hotel> _hotels = [];
  String? _selectedHotelId;
  String _selectedRoomType = 'Deluxe';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  @override
  void dispose() {
    _roomNumCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _loadHotels() async {
    try {
      final list = await _service.getAllHotels();
      if (!mounted) return;
      setState(() {
        _hotels = list;
        if (list.isNotEmpty) _selectedHotelId = list.first.id;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load hotels: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _saveRoom() async {
    final roomNum = _roomNumCtrl.text.trim();
    final priceText = _priceCtrl.text.trim();

    if (_selectedHotelId == null || roomNum.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    final double? parsedPrice = double.tryParse(priceText);
    if (parsedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price!')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _service.addRoom(
        hotelId: _selectedHotelId!,
        roomNumber: roomNum,
        roomType: _selectedRoomType,
        pricePerNight: parsedPrice,
        capacity: 2,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room Added Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hotels.isEmpty
          ? const Center(child: Text('Please add a Hotel first!'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedHotelId,
              items: _hotels
                  .map((h) => DropdownMenuItem(value: h.id, child: Text(h.name)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedHotelId = val),
              decoration: const InputDecoration(
                labelText: 'Select Hotel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomNumCtrl,
              decoration: const InputDecoration(
                labelText: 'Room Number (e.g. 101)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRoomType,
              items: ['Single', 'Double', 'Deluxe', 'Suite']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedRoomType = val!),
              decoration: const InputDecoration(
                labelText: 'Room Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price Per Night (PKR)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C81),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSaving ? null : _saveRoom,
                child: _isSaving
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : const Text(
                  'SAVE ROOM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}