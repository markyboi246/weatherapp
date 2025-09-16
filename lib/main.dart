import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}
// APP SETUP
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Info App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherHome(),
    );
  }
}
// Weather UI
class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final TextEditingController _cityController = TextEditingController();

  String cityName = '';
  String temperature = '';
  String condition = '';

  List<Map<String, String>> forecast = [];

  final List<String> conditions = ['Sunny', 'Cloudy', 'Rainy'];
// Weather Data Generation
  void _fetchWeather() {
    final random = Random();
    setState(() {
      cityName = _cityController.text;
      temperature = "${15 + random.nextInt(16)} °C"; // 15–30
      condition = conditions[random.nextInt(conditions.length)];
      forecast = []; // clear forecast if fetching current weather
    });
  }

  void _fetch7DayForecast() {
    final random = Random();
    final now = DateTime.now();
    setState(() {
      cityName = _cityController.text;
      temperature = '';
      condition = '';
      forecast = List.generate(7, (i) {
        final date = now.add(Duration(days: i + 1));
        return {
          "date":
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
          "temp": "${15 + random.nextInt(16)} °C",
          "condition": conditions[random.nextInt(conditions.length)],
        };
      });
    });
  }
// Display Simulated Weather Infomration
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Info App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Enter city",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: const Text("Fetch Weather"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _fetch7DayForecast,
                  child: const Text("7-Day Forecast"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (cityName.isNotEmpty &&
                temperature.isNotEmpty &&
                condition.isNotEmpty)
              Column(
                children: [
                  Text("City: $cityName", style: const TextStyle(fontSize: 18)),
                  Text(
                    "Temperature: $temperature",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Condition: $condition",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            if (forecast.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: forecast.length,
                  itemBuilder: (context, index) {
                    final day = forecast[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          day["date"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "Temp: ${day["temp"]}\nCondition: ${day["condition"]}",
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
