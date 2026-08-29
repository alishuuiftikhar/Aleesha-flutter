class WeatherData {
  final String city;
  final String country;
  final double temp;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String sunrise;
  final String sunset;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherData({
    required this.city,
    required this.country,
    required this.temp,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['city'],
      country: json['country'],
      temp: json['temp'].toDouble(),
      condition: json['condition'],
      humidity: json['humidity'],
      windSpeed: json['windSpeed'].toDouble(),
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      hourly: (json['hourly'] as List)
          .map((i) => HourlyForecast.fromJson(i))
          .toList(),
      daily: (json['daily'] as List)
          .map((i) => DailyForecast.fromJson(i))
          .toList(),
    );
  }
}

class HourlyForecast {
  final String time;
  final double temp;
  final String condition;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.condition,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      temp: json['temp'].toDouble(),
      condition: json['condition'],
    );
  }
}

class DailyForecast {
  final String day;
  final double temp;
  final String condition;

  DailyForecast({
    required this.day,
    required this.temp,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      day: json['day'],
      temp: json['temp'].toDouble(),
      condition: json['condition'],
    );
  }
}
