import 'package:flutter/material.dart';
import 'calendar.dart';
import 'location_service.dart';
import 'getWeather_service.dart';
import 'item_class.dart';
import 'city_detail.dart';
import 'weather_api.dart';

String googleApiKey = 'YOUR_GOOGLE_API_KEY';
String openWeather_Api_Key = 'YOUR_OPENWEATHER_API_KEY';

Map<String, dynamic> currentCity = {
  'lat': 0.0,
  'lon': 0.0,
  'status': 'error',
};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static final GlobalKey<_MyHomePageState> globalKey =
      GlobalKey<_MyHomePageState>();

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Calendar calendarView = Calendar.day;
  List<City> cityData = [
    City({'name': 'Lyon', 'latitude': 45.75, 'longitude': 4.85}),
    City({'name': 'Paris', 'latitude': 48.85, 'longitude': 2.35}),
    City({'name': 'Tokyo', 'latitude': 35.4122, 'longitude': 139.4130}),
  ];

  Map<String, dynamic> apiResponse = {};

  Map<String, dynamic> getApiResponse() {
    return apiResponse;
  }

  List<City> allCities = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    for (var city in cityData) {
      _getWeatherOnLocation(city);
    }
  }

  Future<void> _getCurrentLocation() async {
    var locationData =
        await getCurrentLocation(googleApiKey, openWeather_Api_Key);
    setState(() {
      apiResponse = locationData;
      if (locationData['status'] == 'success') {
        currentCity = locationData as Map<String, dynamic>;
        City current = City(currentCity);
        allCities = [current, ...cityData];
      } else {
        cityData[0].data['weatherDescription'] =
            locationData['locationMessage'] ?? 'No data';
        cityData[0].data['status'] = 'error';
        allCities = [cityData[0], ...cityData.sublist(1)];
      }
    });
  }

  Future<void> _getWeatherOnLocation(City city) async {
    var data = await getWeatherOnLocation(googleApiKey, openWeather_Api_Key,
        city.data['latitude'], city.data['longitude']);
    setState(() {
      if (data['status'] == 'success') {
        city.data = data;
      } else {
        city.data = data;
        city.data['status'] = 'error';
      }
    });
  }

  Future<void> _searchCity(String query) async {
    var cityData = await fetchCity(query, googleApiKey);
    if (cityData['status'] == 'success') {
      final city = City({
        'name': query,
        'latitude': cityData['latitude'],
        'longitude': cityData['longitude'],
      });
      setState(() {
        allCities.add(city); // Append the new city to the list
      });
      _getWeatherOnLocation(city); // Update the new city's weather data
      searchController.clear(); // Clear the search field
    } else {
      // Handle error
      print('City not found');
    }
  }

  void _deleteCity(City city) {
    setState(() {
      allCities.remove(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    double availableHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Chercher une ville',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (query) {
            _searchCity(query);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: 400,
                height: availableHeight,
                child: GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    for (var i = 0; i < allCities.length; i++)
                      CityDetail(
                        cityData: allCities[i].toMap(),
                        onDelete: () => _deleteCity(allCities[i]),
                        showDeleteButton: i >= 4,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
