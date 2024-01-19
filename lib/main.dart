import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sensorlevel/repositories/config.dart';
import 'package:sensorlevel/repositories/locations.dart';
import 'package:sensorlevel/schemas/locations.dart';
import 'package:sensorlevel/screens/detail.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenphyto Monitoring',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Greenphyto Monitoring'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Location> locations = [];
  LocationsRepository locationsRepository = LocationsRepository();
  bool isLoading = false;

  getDataLocations() async {
    try {
      isLoading = true;
      locations = await locationsRepository.getData();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initSocket();
    getDataLocations();
    super.initState();
  }

  late IO.Socket socket;
  initSocket() {
    socket = IO.io(baseUrl, <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      if (kDebugMode) {
        print('Connection established');
      }
    });
    // ignore: avoid_print
    socket.onDisconnect((_) => print('Connection Disconnection'));
    // ignore: avoid_print
    socket.onConnectError((err) => print(err));
    // ignore: avoid_print
    socket.onError((err) => print(err));
    socket.on('monitor-location-current', (data) {
      List<Location> newData =
          data.map<Location>((json) => Location.fromJson(json)).toList();

      // Update the state with the new data
      setState(() {
        locations = newData;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // var locations = [
  //   {
  //     "location_id": "27f9d433-29d2-499c-bab7-c7ab07086d19",
  //     "location_name": "Location A",
  //     "location_image": "image.jpg",
  //     "current_monitor": {
  //       "id": "1f8be96c-1ca6-4637-8500-ab53d4c4676c",
  //       "soil_ec": "100",
  //       "soil_npk": ["10", "5", "20"],
  //       "water_ec": "1500",
  //       "water_ph": "7.5",
  //       "water_tds": "300",
  //       "created_at": "2024-01-18T00:07:47.039895+07:00",
  //       "soil_moisture": "30",
  //       "light_intensity": "1000",
  //       "water_tss": "5.0",
  //       "soil_temperature": "25.0",
  //       "weather_humidity": "60",
  //       "weather_temperature": "25.0"
  //     }
  //   },
  //   {
  //     "location_id": "005975f6-3352-4163-91ef-b44875488718",
  //     "location_name": "Location B",
  //     "location_image": "image.jpg",
  //     "current_monitor": {
  //       "id": "aa26321a-d7d2-4c66-8780-6d3b999849ce",
  //       "soil_ec": "100",
  //       "soil_npk": ["10", "5", "20"],
  //       "water_ec": "1500",
  //       "water_ph": "7.5",
  //       "water_tds": "300",
  //       "created_at": "2024-01-18T00:31:44.100437+07:00",
  //       "soil_moisture": "30",
  //       "light_intensity": "1000",
  //       "water_tss": "5.0",
  //       "soil_temperature": "25.0",
  //       "weather_humidity": "60",
  //       "weather_temperature": "25.0"
  //     }
  //   }
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   foregroundColor: Colors.green,

      // ),
      body: Stack(children: [
        Container(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(100)),
                child: Container(
                  color: Colors.green,
                  height: 300,
                  width: double.infinity,
                ),
              ),
              const Positioned(
                  top: 50,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Greenphyto',
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                      Text('Farm Monitoring',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                    ],
                  )),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const Text('Fetching Data...')
                  : CarouselSlider.builder(
                      itemCount: locations.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        var currentMonitor =
                            locations[itemIndex].currentMonitor;
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(30, 30)),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              top: 25, left: 15, right: 15),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        flex: 2,
                                        child: Text(
                                          locations[itemIndex].locationName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              overflow: TextOverflow.ellipsis),
                                        )),
                                    // const Flexible(
                                    //     flex: 1,
                                    //     child: Icon(Icons.edit_outlined,
                                    //         color: Colors.black54)),
                                  ]),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              const Text(
                                                'Air Humidity',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                currentMonitor.weatherHumidity,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )
                                            ],
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              const Text(
                                                'Temperature',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                '${currentMonitor.weatherTemperature}°',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )
                                            ],
                                          )),
                                    ]),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: ListView(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 1),
                                            child: const Text(
                                              'Soil',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/soil_ph.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Soil pH',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor
                                                          .soilTemperature,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/soil_temperature.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Soil Temperature',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor
                                                          .soilTemperature,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/soil_ec.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Soil EC',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor.soilEc,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 1),
                                            child: const Text(
                                              'Water',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/water_ph.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Water pH',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor.waterPh,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/water_ec.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Water EC',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor.waterEc,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/water_tds.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Water TDS',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor.waterTds,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          'assets/water_tss.png'),
                                                      width: 24,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Water TSS',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor.waterTds,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 1),
                                            child: const Text(
                                              'Light',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 1)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: const Icon(
                                                      Icons.flare,
                                                      color: Colors.amberAccent,
                                                      size: 30,
                                                    )),
                                                const Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      'Light Intensity',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    )),
                                                Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      currentMonitor
                                                          .lightIntensity,
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        width: 500,
                                        bottom: 0,
                                        top: null,
                                        left: null,
                                        right: null,
                                        child: Container(
                                          height: 50,
                                          decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        227, 255, 255, 255),
                                                    blurRadius: 10)
                                              ]),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Last Updated:',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              DateFormat.yMd().add_jm().format(
                                                  DateTime.parse(currentMonitor
                                                      .createdAt)),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SecondRoute(
                                                            idLocation: locations[
                                                                    itemIndex]
                                                                .locationName,
                                                          )),
                                                );
                                              },
                                              child: const Text(
                                                'Detail',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          height: 525,
                          disableCenter: true))
            ],
          ),
        ),
      ]),
    );
  }
}
