import 'package:geolocator/geolocator.dart';
import 'getWeather_service.dart';

Future<Map<String, dynamic>> getCurrentLocation(String googleApiKey, String openWeatherApiKey) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Vérifier les permissions de localisation
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return {
        'locationMessage': "Les permissions de localisation sont refusées.",
        'ville': '',
        'temperature': 0.0,
        'status': 'error'
      };
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return {
      'locationMessage': "Les permissions de localisation sont refusées de manière permanente.",
      'ville': '',
      'temperature': 0.0,
      'status': 'error'
    };
  }

  // Obtenir la position actuelle
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // Fetch weather data
  var weatherData = await getWeatherOnLocation(googleApiKey, openWeatherApiKey, position.latitude, position.longitude);

  return weatherData;
}