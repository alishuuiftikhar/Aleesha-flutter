class BusRoute {
  final int? id;
  final int busId;
  final String departureCity;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;
  final double basePrice;
  final String date;

  BusRoute({
    this.id,
    required this.busId,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.basePrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'busId': busId,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'basePrice': basePrice,
      'date': date,
    };
  }

  factory BusRoute.fromMap(Map<String, dynamic> map) {
    return BusRoute(
      id: map['id'],
      busId: map['busId'],
      departureCity: map['departureCity'],
      destinationCity: map['destinationCity'],
      departureTime: map['departureTime'],
      arrivalTime: map['arrivalTime'],
      basePrice: map['basePrice'],
      date: map['date'],
    );
  }
}
