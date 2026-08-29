import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../utils/app_colors.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> hourly;

  const HourlyForecastList({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hourly Forecast',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final forecast = hourly[index];
              return Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondaryBackground),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      forecast.time,
                      style: const TextStyle(fontSize: 12, color: AppColors.text),
                    ),
                    _getWeatherIcon(forecast.condition, 24),
                    Text(
                      '${provider.getConvertedTemp(forecast.temp).toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getWeatherIcon(String condition, double size) {
    IconData icon;
    switch (condition.toLowerCase()) {
      case 'sunny':
        icon = Icons.wb_sunny_rounded;
        break;
      case 'cloudy':
        icon = Icons.cloud_rounded;
        break;
      case 'rainy':
        icon = Icons.beach_access_rounded;
        break;
      case 'partly cloudy':
        icon = Icons.wb_cloudy_rounded;
        break;
      default:
        icon = Icons.wb_cloudy_rounded;
    }
    return Icon(icon, size: size, color: AppColors.secondary);
  }
}
