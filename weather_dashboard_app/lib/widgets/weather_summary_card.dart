import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../utils/app_colors.dart';

class WeatherSummaryCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherSummaryCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final isFavorite = provider.isFavorite(weather.city);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.country,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () => provider.toggleFavorite(weather.city),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getWeatherIcon(weather.condition, 80),
                Column(
                  children: [
                    Text(
                      '${provider.getConvertedTemp(weather.temp).toStringAsFixed(0)}${provider.tempSuffix}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      weather.condition,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String condition, double size) {
    IconData icon;
    Color color = Colors.white;
    switch (condition.toLowerCase()) {
      case 'sunny':
        icon = Icons.wb_sunny_rounded;
        color = AppColors.accent;
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
    return Icon(icon, size: size, color: color);
  }
}
