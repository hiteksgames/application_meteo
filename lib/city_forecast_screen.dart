import 'package:flutter/material.dart';
import 'calendar.dart';
import 'hourly_forecast_chart.dart';
import 'weekly_forecast_chart.dart';

class CityForecastScreen extends StatefulWidget {
  final List<dynamic> hourlyData;
  final List<dynamic> weeklyData; // Add weekly data

  CityForecastScreen({required this.hourlyData, required this.weeklyData});

  @override
  _CityForecastScreenState createState() => _CityForecastScreenState();
}

class _CityForecastScreenState extends State<CityForecastScreen> {
  Calendar calendarView = Calendar.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prévision'),
      ),
      body: Column(
        children: [
          SegmentedButton<Calendar>(
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.red,
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: Colors.green,
            ),
            segments: const <ButtonSegment<Calendar>>[
              ButtonSegment<Calendar>(
                value: Calendar.day,
                label: Text('24 Heures'),
                icon: Icon(Icons.calendar_view_day),
              ),
              ButtonSegment<Calendar>(
                value: Calendar.week,
                label: Text('1 semaine'),
                icon: Icon(Icons.calendar_view_week),
              ),
            ],
            onSelectionChanged: (Set<Calendar> newSelection) {
              setState(() {
                calendarView = newSelection.first;
              });
            },
            selected: <Calendar>{calendarView},
          ),
          Expanded(
            child: calendarView == Calendar.day
                ? HourlyForecastChart(hourlyData: widget.hourlyData)
                : WeeklyForecastChart(weeklyData: widget.weeklyData), // Display weekly chart
          ),
        ],
      ),
    );
  }
}