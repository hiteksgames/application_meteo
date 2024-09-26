import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HourlyForecastChart extends StatelessWidget {
  final List<dynamic> hourlyData;

  HourlyForecastChart({required this.hourlyData});

  List<Map<String, int>> _convertHourlyDataToInt(List<dynamic> data) {
    return data.take(24).map((entry) {
      return {
        'dt': entry['dt'] as int? ?? 0,
        'temp': ((entry['temp'] as num?)?.toInt() ?? 0) - 273, // Convert to int and adjust for Celsius
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, int>> intHourlyData = _convertHourlyDataToInt(hourlyData);

    int maxTemp = intHourlyData.map((entry) => entry['temp'] ?? 0).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Container(
                      width: 900, // Set a fixed width for the chart
                      height: 300, // Set a fixed height for the chart
                      padding: EdgeInsets.only(left: 20, right: 20), // Add padding to the left and right
                      child: LineChart(
                        LineChartData(
                          minY: -10,
                          maxY: maxTemp + 5,
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index < 0 || index >= intHourlyData.length) {
                                    return Container();
                                  }
                                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((intHourlyData[index]['dt'] ?? 0) * 1000);
                                  return Text('${dateTime.hour}H');
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.visible,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: intHourlyData.asMap().entries.map((entry) {
                                int index = entry.key;
                                double temp = entry.value['temp']?.toDouble() ?? 0.0;
                                return FlSpot(index.toDouble(), temp);
                              }).toList(),
                              isCurved: true,
                              barWidth: 2,
                              color: Colors.red,
                              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}