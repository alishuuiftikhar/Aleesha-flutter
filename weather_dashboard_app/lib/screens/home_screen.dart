import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/weather_summary_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/weather_details_grid.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SkyCast',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: WeatherSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadInitialData(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.currentWeather == null
              ? const Center(child: Text("No data available"))
              : RefreshIndicator(
                  onRefresh: () => provider.loadInitialData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherSummaryCard(weather: provider.currentWeather!),
                        const SizedBox(height: 30),
                        WeatherDetailsGrid(weather: provider.currentWeather!),
                        const SizedBox(height: 30),
                        HourlyForecastList(hourly: provider.currentWeather!.hourly),
                        const SizedBox(height: 30),
                        DailyForecastList(daily: provider.currentWeather!.daily),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Drawer(
      backgroundColor: AppColors.mainBackground,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.wb_sunny_rounded, color: AppColors.accent, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'SkyCast Settings',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.primary),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Favorites',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final cityName = provider.favorites[index];
                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.redAccent),
                  title: Text(cityName),
                  onTap: () {
                    final weather = provider.allWeatherData
                        .firstWhere((w) => w.city == cityName);
                    provider.setCurrentWeather(weather);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final results = provider.allWeatherData
        .where((w) => w.city.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(results, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final results = provider.allWeatherData
        .where((w) => w.city.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(results, context);
  }

  Widget _buildList(List results, BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    return Container(
      color: AppColors.mainBackground,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final weather = results[index];
          return ListTile(
            title: Text(weather.city),
            subtitle: Text(weather.country),
            onTap: () {
              provider.setCurrentWeather(weather);
              close(context, null);
            },
          );
        },
      ),
    );
  }
}
