import 'event_model.dart';

enum TicketType { vip, standard, economy }

class Booking {
  final String id;
  final Event event;
  final DateTime bookingDate;
  final TicketType ticketType;
  final int quantity;
  final double totalAmount;
  final String status;

  Booking({
    required this.id,
    required this.event,
    required this.bookingDate,
    required this.ticketType,
    required this.quantity,
    required this.totalAmount,
    this.status = 'Confirmed',
  });
}
