import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SecondRoute extends StatelessWidget {
  final String idLocation;
  const SecondRoute({Key? key, required this.idLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Historical Location A'),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Location A',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                child: Row(
                  children: [],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20, color: Colors.black.withAlpha(20))
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                    width: 200,
                    height: 300,
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: const Text('ph Water Level'),
                      ),
                      Expanded(
                          child: WaterPhChart(data: generateLocationsData())),
                    ]),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> generateLocationsData() {
    return [
      {
        "location_id": "27f9d433-29d2-499c-bab7-c7ab07086d19",
        "location_name": "Location A",
        "current_monitor": {
          "water_ph": "2.0",
          "created_at": "2024-01-19T04:05:58.145613+07:00",
        }
      },
      {
        "location_id": "005975f6-3352-4163-91ef-b44875488718",
        "location_name": "Location B",
        "current_monitor": {
          "water_ph": "5.5",
          "created_at": "2024-01-18T00:31:44.100437+07:00",
        }
      },
      {
        "location_id": "005975f6-3352-4163-91ef-b44875488718",
        "location_name": "Location B",
        "current_monitor": {
          "water_ph": "5.5",
          "created_at": "2024-01-18T00:31:44.100437+07:00",
        }
      },
      {
        "location_id": "005975f6-3352-4163-91ef-b44875488718",
        "location_name": "Location B",
        "current_monitor": {
          "water_ph": "5.5",
          "created_at": "2024-01-18T00:31:44.100437+07:00",
        }
      },
      {
        "location_id": "005975f6-3352-4163-91ef-b44875488718",
        "location_name": "Location B",
        "current_monitor": {
          "water_ph": "3.5",
          "created_at": "2024-01-18T00:31:44.100437+07:00",
        }
      },
    ];
  }
}

class WaterPhChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const WaterPhChart({super.key, required this.data});
  FlTitlesData get waterPhTiles => const FlTitlesData(
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(showTitles: true, reservedSize: 45),
        // ),
      );
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: 0,
        titlesData: waterPhTiles,
        lineBarsData: [
          LineChartBarData(
            spots: getWaterPhSpots(),
            isCurved: true,
            dotData: const FlDotData(show: true),
            barWidth: 3,
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.greenAccent]),
            belowBarData: BarAreaData(
                show: true,
                color: Colors.greenAccent,
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(210, 105, 240, 175),
                      Color.fromARGB(194, 178, 255, 89)
                    ])),
          ),
        ],
      ),
    );
  }

  List<FlSpot> getWaterPhSpots() {
    return data
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(),
            double.parse(entry.value['current_monitor']['water_ph'] ?? '0.0')))
        .toList();
  }
}
