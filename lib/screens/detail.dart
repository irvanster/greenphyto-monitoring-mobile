import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:sensorlevel/repositories/config.dart';
import 'package:sensorlevel/repositories/locations.dart';
import 'package:sensorlevel/schemas/locations.dart';

class SecondRoute extends StatefulWidget {
  final String locationId;

  const SecondRoute({Key? key, required this.locationId}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  Map<String, dynamic> locationDetail = {};
  List<HistoryData> historyData = [];
  LocationsRepository locationsRepository = LocationsRepository();
  bool isLoading = false;
  getDataLocations() async {
    try {
      isLoading = true;

      locationDetail = await locationsRepository.getDetail(widget.locationId);

      // Assuming your HistoryData class has a factory method to create an instance from a map
      var historyList = locationDetail['history'] as List<dynamic>?;
      if (historyList != null) {
        List<HistoryData> historyResponse =
            historyList.map((item) => HistoryData.fromJson(item)).toList() ??
                [];
        historyData = historyResponse.reversed.toList();
        setState(() => isLoading = false);
      } else {
        historyData = [];
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final SocketManager socketManager = SocketManager();
  @override
  void initState() {
    super.initState();
    getDataLocations();
    socketManager.initSocket();
    socketManager.socket.on('monitor-location-current-${widget.locationId}',
        (data) {
      Map<String, dynamic> newData = data;

      var historyList = newData['history'] as List<dynamic>?;
      List<HistoryData> newHistoryData =
          historyList?.map((item) => HistoryData.fromJson(item)).toList() ?? [];
      setState(() {
        historyData = newHistoryData.reversed.toList();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      getDataLocations();
    }
  }

  @override
  void dispose() {
    socketManager.socket.dispose();
    super.dispose();
  }

  String selectedRange = '24 Hours';

  void updateSelectedRange(String range) {
    setState(() {
      selectedRange = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Historical Detail'),
          backgroundColor: Colors.white,
          centerTitle: true,
          surfaceTintColor: Colors.white,
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
          child: isLoading
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                )
              : historyData.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Oops... History Data Empty\n Waiting for new updates from sensor.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Monitoring ${locationDetail['location_name']}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(top: 10),
                        //   padding: const EdgeInsets.all(5),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Expanded(
                        //         flex: 1,
                        //         child: Container(
                        //           padding:
                        //               const EdgeInsets.only(left: 2.5, right: 2.5),
                        //           child: TextButton(
                        //             style: TextButton.styleFrom(
                        //               backgroundColor: selectedRange == '24 Hours'
                        //                   ? Colors.green
                        //                   : Colors.white,
                        //             ),
                        //             onPressed: () {
                        //               updateSelectedRange('24 Hours');
                        //               // Add logic to save '24 Hours' to state or perform other actions
                        //             },
                        //             child: Text(
                        //               '24 Hours',
                        //               style: TextStyle(
                        //                 color: selectedRange == '24 Hours'
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 1,
                        //         child: Container(
                        //           padding:
                        //               const EdgeInsets.only(left: 2.5, right: 2.5),
                        //           child: TextButton(
                        //             style: TextButton.styleFrom(
                        //               backgroundColor: selectedRange == '1 Week'
                        //                   ? Colors.green
                        //                   : Colors.white,
                        //             ),
                        //             onPressed: () {
                        //               updateSelectedRange('1 Week');
                        //               // Add logic to save '1 Week' to state or perform other actions
                        //             },
                        //             child: Text(
                        //               '1 Week',
                        //               style: TextStyle(
                        //                 color: selectedRange == '1 Week'
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 1,
                        //         child: Container(
                        //           padding:
                        //               const EdgeInsets.only(left: 2.5, right: 2.5),
                        //           child: TextButton(
                        //             style: TextButton.styleFrom(
                        //               backgroundColor: selectedRange == '1 Month'
                        //                   ? Colors.green
                        //                   : Colors.white,
                        //             ),
                        //             onPressed: () {
                        //               updateSelectedRange('1 Month');
                        //               // Add logic to save '1 Month' to state or perform other actions
                        //             },
                        //             child: Text(
                        //               '1 Month',
                        //               style: TextStyle(
                        //                 color: selectedRange == '1 Month'
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: const Text(
                            'Ambient Activities',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 180,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15,
                                                            top: 15),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/temperature.png'),
                                                      width: 24,
                                                    )),
                                                const Text(
                                                  'Temperature',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Text(
                                                    historyData.isNotEmpty
                                                        ? historyData.last
                                                            .weatherTemperature
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'weatherTemperature',
                                        type: "line",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 180,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15,
                                                            top: 15),
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child: const Icon(
                                                          Icons.flare,
                                                          color: Colors
                                                              .amberAccent,
                                                          size: 30,
                                                        ))),
                                                const Text(
                                                  'Intensity',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Text(
                                                    historyData.isNotEmpty
                                                        ? historyData
                                                            .last.lightIntensity
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'lightIntensity',
                                        type: "line",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 180,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15,
                                                            top: 15),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/humidity.png'),
                                                      width: 24,
                                                    )),
                                                const Text(
                                                  'Humidity',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Text(
                                                    historyData.isNotEmpty
                                                        ? historyData.last
                                                            .weatherHumidity
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'weatherHumidity',
                                        type: "line",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: const Text(
                            'Soil Activities',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withAlpha(20),
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          height: 220,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: const Image(
                                          image:
                                              AssetImage('assets/soil_ph.png'),
                                          width: 24,
                                        )),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Soil pH',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              historyData.isNotEmpty
                                                  ? historyData.last.soilPh
                                                  : 'N/A',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LineChartWrap(
                                  data: historyData,
                                  selected: 'soilPh',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withAlpha(20),
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          height: 220,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: const Image(
                                          image:
                                              AssetImage('assets/soil_ec.png'),
                                          width: 24,
                                        )),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Soil EC',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              historyData.isNotEmpty
                                                  ? historyData.last.soilEc
                                                  : 'N/A',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LineChartWrap(
                                  data: historyData,
                                  selected: 'soilEc',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 220,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/soil_temperature.png'),
                                                width: 24,
                                              )),
                                          Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Soil Temperature',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    historyData.isNotEmpty
                                                        ? historyData.last
                                                            .soilTemperature
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'soilTemperature',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 220,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/soil_moisture.png'),
                                                width: 24,
                                              )),
                                          Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Soil Moisture',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    historyData.isNotEmpty
                                                        ? historyData
                                                            .last.soilMoisture
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'soilMoisture',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: const Text(
                            'Water Activities',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withAlpha(20),
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          height: 220,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: const Image(
                                          image:
                                              AssetImage('assets/water_ph.png'),
                                          width: 24,
                                        )),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Water pH',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              historyData.isNotEmpty
                                                  ? historyData.last.waterPh
                                                  : 'N/A',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LineChartWrap(
                                  data: historyData,
                                  selected: 'waterPh',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black.withAlpha(20),
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          height: 220,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: const Image(
                                          image:
                                              AssetImage('assets/water_ec.png'),
                                          width: 24,
                                        )),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Water EC',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              historyData.isNotEmpty
                                                  ? historyData.last.waterEc
                                                  : 'N/A',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LineChartWrap(
                                  data: historyData,
                                  selected: 'waterEc',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 220,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/water_tds.png'),
                                                width: 24,
                                              )),
                                          Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Water TDS',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    historyData.isNotEmpty
                                                        ? historyData
                                                            .last.waterTds
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'waterTds',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.black.withAlpha(20),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                width: double.infinity,
                                height: 220,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/water_tss.png'),
                                                width: 24,
                                              )),
                                          Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Water TSS',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    historyData.isNotEmpty
                                                        ? historyData
                                                            .last.waterTss
                                                        : 'N/A',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: LineChartWrap(
                                        data: historyData,
                                        selected: 'waterTss',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class LineChartWrap extends StatelessWidget {
  final List<HistoryData> data;
  final String selected;
  final String type;

  const LineChartWrap(
      {Key? key,
      required this.data,
      required this.selected,
      this.type = "fill"})
      : super(key: key);
  String formatTo24Hour(String inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);
    return DateFormat.Hm().format(parsedDate);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String formattedDate = formatTo24Hour(data[value.toInt()].createdAt);
    const style = TextStyle(color: Colors.black, fontSize: 7);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      angle: -0.8,
      child: Text(
        formattedDate,
        style: style,
      ),
    );
  } // Return an empty SizedBox if the value is out of bounds

  FlTitlesData get lineChartTiles => FlTitlesData(
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: type != "fill" ? false : true, reservedSize: 1),
          axisNameSize: 5,
          drawBelowEverything: false),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
        showTitles: type != "fill" ? false : true,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      )));

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
            show: false, drawVerticalLine: true, drawHorizontalLine: true),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        baselineX: 1,
        minY: 0,
        titlesData: lineChartTiles,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.green.shade400,
            tooltipBorder: BorderSide(color: Colors.green.shade500),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                const textStyle = TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                );
                return LineTooltipItem(touchedSpot.y.toString(), textStyle);
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: getLineChartSpots(),
            isCurved: true,
            dotData: const FlDotData(show: false),
            barWidth: 3,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: type != "fill"
                    ? [Colors.greenAccent, Colors.greenAccent.shade400]
                    : [Colors.greenAccent.shade400, Colors.greenAccent]),
            belowBarData: BarAreaData(
                show: type != "fill" ? false : true,
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

  List<FlSpot> getLineChartSpots() {
    return data.asMap().entries.map((entry) {
      if (selected == "waterPh") {
        return FlSpot(entry.key.toDouble(), double.parse(entry.value.waterPh));
      }
      if (selected == "waterEc") {
        return FlSpot(entry.key.toDouble(), double.parse(entry.value.waterEc));
      }
      if (selected == "waterTds") {
        return FlSpot(entry.key.toDouble(), double.parse(entry.value.waterTds));
      }
      if (selected == "waterTss") {
        return FlSpot(entry.key.toDouble(), double.parse(entry.value.waterTss));
      }
      if (selected == "soilPh") {
        return FlSpot(entry.key.toDouble(), double.parse(entry.value.soilPh));
      }
      if (selected == "soilEc") {
        return FlSpot(entry.key.toDouble(), double.parse(entry.value.soilEc));
      }
      if (selected == "soilMoisture") {
        return FlSpot(
            entry.key.toDouble(), double.parse(entry.value.soilMoisture));
      }
      if (selected == "soilTemperature") {
        return FlSpot(
            entry.key.toDouble(), double.parse(entry.value.soilTemperature));
      }
      if (selected == "weatherHumidity") {
        return FlSpot(
            entry.key.toDouble(), double.parse(entry.value.weatherHumidity));
      }
      if (selected == "weatherTemperature") {
        return FlSpot(
            entry.key.toDouble(), double.parse(entry.value.weatherTemperature));
      }
      if (selected == "lightIntensity") {
        return FlSpot(
            entry.key.toDouble(), double.parse(entry.value.lightIntensity));
      }
      return const FlSpot(0, 0);
    }).toList();
  }
}
