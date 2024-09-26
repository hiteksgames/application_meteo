import 'weather_api.dart';

Future<Map<String, dynamic>> getWeatherOnLocation(String googleApiKey, String openWeatherApiKey, double latitude, double longitude) async {
  // Fetch city data
  var cityData = await fetchCityData(latitude, longitude, googleApiKey);

  // Fetch weather data
  var weatherData = await fetchWeatherData(latitude, longitude, openWeatherApiKey);

  // Combine city data and weather data
  var combinedData = {
    ...cityData,
    ...weatherData,
  };

  // Return the combined data
  return combinedData;
}