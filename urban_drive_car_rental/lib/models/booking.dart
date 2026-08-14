import 'dart:convert';
import 'package:urban_drive_car_rental/models/car.dart';

class Booking {
  final String id;
  final String userId;
  final String carId;
  final String carName;
  final String carImage;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.carImage,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'carId': carId,
      'carName': carName,
      'carImage': carImage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'pickupLocation': pickupLocation,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      carId: map['carId'] ?? '',
      carName: map['carName'] ?? '',
      carImage: map['carImage'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      pickupLocation: map['pickupLocation'] ?? '',
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: map['status'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) => Booking.fromMap(json.decode(source));
}
