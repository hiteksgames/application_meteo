import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchCity(String name, String apiKey) async {
  final cityResponse = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$name&key=$apiKey'));

  if (cityResponse.statusCode == 200) {
    var cityData = json.decode(cityResponse.body);
    if (cityData['status'] == 'OK') {
      return {
        'latitude': cityData['results'][0]['geometry']['location']['lat'],
        'longitude': cityData['results'][0]['geometry']['location']['lng'],
        'status': 'success'
      };
    } else {
      return {'latitude': 0.0, 'longitude': 0.0, 'status': 'error'};
    }
  } else {
    return {'latitude': 0.0, 'longitude': 0.0, 'status': 'error'};
  }
}

Future<Map<String, dynamic>> fetchCityData(double latitude, double longitude, String apiKey) async {
  final cityResponse = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'));

  if (cityResponse.statusCode == 200) {
    var cityData = json.decode(cityResponse.body);
    if (cityData['results'].isNotEmpty && cityData['results'][0]['address_components'].length > 2) {
      return {
        'city': cityData['results'][0]['address_components'][2]['long_name'],
        'status': 'success'
      };
    } else {
      return {'city': 'Unknown location', 'status': 'error'};
    }
  } else {
    return {'city': 'Failed to fetch city data', 'status': 'error'};
  }
}

Future<Map<String, dynamic>> fetchWeatherData(double latitude, double longitude, String apiKey) async {
  final weatherResponse = await http.get(Uri.parse('https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&appid=$apiKey'));

  if (weatherResponse.statusCode == 200) {
    var weatherData = json.decode(weatherResponse.body);
    return weatherData;
  } else {
    return {'description': 'Failed to fetch weather data', 'temperature': 0.0, 'status': 'error'};
  }
}