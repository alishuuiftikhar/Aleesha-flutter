import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../utils/app_colors.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> daily;

  const DailyForecastList({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '7-Day Forecast',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daily.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final forecast = daily[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.secondaryBackground),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      forecast.day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _getWeatherIcon(forecast.condition, 24),
                      const SizedBox(width: 8),
                      Text(
                        forecast.condition,
                        style: TextStyle(color: AppColors.text.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  Text(
                    '${provider.getConvertedTemp(forecast.temp).toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          },
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
