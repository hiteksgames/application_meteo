import 'package:flutter/material.dart';
import 'city_forecast_screen.dart';

class CityDetail extends StatelessWidget {
  final Map<String, dynamic> cityData;
  final VoidCallback onDelete;
  final bool showDeleteButton;

  const CityDetail({
    Key? key,
    required this.cityData,
    required this.onDelete,
    required this.showDeleteButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double temp = (cityData['current']?['temp'] ?? 0) - 273.15;
    int tempInt = temp.toInt();
    String tempString = tempInt.toString();

    return InkWell(
      onTap: () => _showCityDetails(context),
      child: Card(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cityData['city'] ?? 'N/A',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Temperature: $tempString °C',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Humidité: ${cityData['current']?['humidity']?.toString() ?? 'N/A'} %',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Météo: ${cityData['current']?['weather']?[0]['description'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityForecastScreen(
                          hourlyData: cityData['hourly'] ?? [],
                          weeklyData: cityData['daily'] ?? [],
                        ),
                      ),
                    );
                  },
                  child: Text('Weather Forecast'),
                ),
                if (showDeleteButton) ...[
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onDelete,
                    child: Text('Supprimer la ville'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCityDetails(BuildContext context) {
    double temp = (cityData['current']?['temp'] ?? 0) - 273.15;
    int tempInt = temp.toInt();
    String tempString = tempInt.toString();
    int timestamp = cityData['current']?['dt'] ?? 0;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String hour = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cityData['city'] ?? 'N/A'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Timezone: ${cityData['timezone'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'heure: $hour',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Temperature: $tempString °C',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Humidité: ${cityData['current']?['humidity']?.toString() ?? 'N/A'} %',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Météo: ${cityData['current']?['weather']?[0]['description'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Vitesse du vent: ${cityData['current']?['wind_speed'] ?? 'N/A'} km/h',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}