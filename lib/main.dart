import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:success/services/location_service.dart';
import 'package:success/services/remote_services.dart';

// import 'package:geolocation/geolocation.dart';
import 'models/post.dart';
import 'package:shimmer/shimmer.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final tex = TextEditingController();
  final _dataService = DataService();
  late double lat;

  late double lon;

  Future<void> getcurrentlocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPositon = await Geolocator.getLastKnownPosition();
    print(lastPositon);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
  }

  String location = 'Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    // Placemark place = placemarks[0];
    // // Address = ' ${place.locality}';
    // setState(()  {
    //   Address = ' ${place.locality}';
    // });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String myCity = placemarks[0].locality!;

      final response = await _dataService.getWeather(myCity);

      setState(() => _response = response);
      print(placemarks[0].locality);
    } catch (err) {}
  }

  // try {
  // List<Placemark> placemarks = await placemarkFromCoordinates(
  // location.latitude,
  // location.longitude,
  // );
  // String myCity = placemarks[0].locality!;
  //
  // final response = await _dataService.getWeather(myCity);
  //
  // setState(() => _response = response);
  // print(placemarks[0].locality);
  // } catch (err) {}

  WeatherResponse? _response;
  ValueNotifier<bool> isnotLoading = ValueNotifier(false);

  Future<void> getpos() async {
    print('hi');
    late var response;
    await getcurrentlocation();


    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lon,
      );
      String myCity = placemarks[0].locality!;

      final response = await _dataService.getWeather(myCity);

      setState(() => _response = response);
      print(placemarks[0].locality);
    } catch (err) {}
    isnotLoading.value = true;

    print('bye');
  }



  @override
  void initState() {
    isnotLoading.addListener(() {
      setState(() {});
    });

    print("after");

    getpos();

    print('${_response?.cityName}');

    print("before");


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(

            // resizeToAvoidBottomInset : false,
            backgroundColor: Colors.white38,
            body:isnotLoading.value?  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      // decoration: BoxDecoration(
                      //     gradient: RadialGradient(
                      //         center: Alignment(0,0),
                      //         radius: 1.0,
                      //         colors: <Color>[
                      //           Colors.white38,
                      //           Colors.grey,
                      //
                      //         ]
                      //     )
                      // ),
                      child: SafeArea(
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: 200.0,
                                    height: 100.0,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor: Colors.yellow,
                                      child: Text(
                                        'Weather App',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // decoration: BoxDecoration(
                                        //   gradient: RadialGradient(
                                        //     center: Alignment(0,0),
                                        //     radius: 0.5,
                                        //     colors: <Color>[
                                        //       Colors.white,
                                        //       Colors.tealAccent,
                                        //     ]
                                        //
                                        //   )
                                        // ),
                                        padding: EdgeInsets.all(8),
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                80, 30, 60, 0),
                                            child: Text(
                                              '${_response?.weatherInfo.description}°',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 35,
                                              ),
                                            )
                                            // Text(_response?.weatherInfo.description)
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                // if (_response!=null)
                                Container(
                                  // decoration: BoxDecoration(
                                  //   gradient: RadialGradient(
                                  //     center: Alignment(0,0),
                                  //     radius: 1.0,
                                  //     colors: <Color>[
                                  //       Colors.white38,
                                  //       Colors.grey,
                                  //       Colors.white,
                                  //
                                  //     ]
                                  //   )
                                  // ),

                                  child: Row(
                                    children: [
                                      SizedBox(width: 10, height: 50),
                                      SizedBox(
                                        width: 150,
                                        child: TextField(
                                            controller: _cityTextController,
                                            decoration: InputDecoration(
                                                labelText: 'City'),
                                            textAlign: TextAlign.center),
                                      ),
                                      ElevatedButton(
                                          onPressed: _search,
                                          child: Text('Search')),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Position position =
                                                      await _getGeoLocationPosition();
                                                  location =
                                                      'Lat: ${position.latitude} , Long: ${position.longitude}';
                                                  GetAddressFromLatLong(
                                                      position);
                                                },
                                                child: Text('Current Location'))

                                            // ElevatedButton(onPressed: getcurrentlocation
                                            //
                                            // , child: const Text("User current location:  ",)),

                                            // ElevatedButton(onPressed: _search, child: Text('Search'))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 170,
                                      ),
                                      Text(
                                        '${_response?.cityName}',
                                        style: TextStyle(fontSize: 30),
                                      )
                                    ],
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Container(
                                //         padding: EdgeInsets.all(8),
                                //         child: Container(
                                //             margin: EdgeInsets.fromLTRB(40, 80, 60, 170),
                                //
                                //             child: Text(
                                //               '${_response?.weatherInfo.description}°',
                                //               style: TextStyle(fontSize: 35),
                                //             )
                                //           // Text(_response?.weatherInfo.description)
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(width: 180),
                                // Row(
                                //   children: [
                                //     SizedBox(height: 150),
                                //     Container(
                                //       child: Container(
                                //           margin: EdgeInsets.fromLTRB(40, 40, 60, 0),
                                //
                                //
                                //         // Text(_response?.weatherInfo.description)
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     gradient: RadialGradient(
                                  //         center: Alignment(0,0),
                                  //         radius: 1.0,
                                  //         colors: <Color>[
                                  //           Colors.white,
                                  //           Colors.tealAccent,
                                  //
                                  //         ]
                                  //     )
                                  //
                                  // ),

                                  child: Row(children: [
                                    SizedBox(width: 80),
                                    Text(
                                      '${_response?.tempInfo.temperature}°',
                                      style: TextStyle(
                                        fontSize: 100,
                                      ),
                                    ),
                                  ]
                                      // Text(_response?.weatherInfo.description)
                                      ),
                                ),

                                Container(
                                  // decoration: BoxDecoration(
                                  //     gradient: RadialGradient(
                                  //         center: Alignment(0,0),
                                  //         radius: 2.0,
                                  //         colors: <Color>[
                                  //           Colors.limeAccent,
                                  //           Colors.white,
                                  //
                                  //         ]
                                  //     )
                                  // ),

                                  child: Row(children: [
                                    SizedBox(width: 140),
                                    Text(
                                      'feels like :${_response?.feels_like.feels_like}°',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ]
                                      // Text(_response?.weatherInfo.description)
                                      ),
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     gradient: RadialGradient(
                                  //         center: Alignment(0,0),
                                  //         radius: 2,
                                  //         colors: <Color>[
                                  //           Colors.limeAccent,
                                  //           Colors.white,
                                  //
                                  //         ]
                                  //     )
                                  // ),

                                  child: Row(children: [
                                    SizedBox(width: 140),
                                    Text(
                                      'Humidity :${_response?.humidity.humidity} °',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ]
                                      // Text(_response?.weatherInfo.description)
                                      ),
                                ),
                                // Container(
                                //
                                //
                                //   child: Row(
                                //
                                //
                                //
                                //       children: [
                                //         SizedBox(width:100),
                                //         Text(
                                //           'Visibility :${_response?.visibility.visibility}°',
                                //           style: TextStyle(fontSize: 20),
                                //         ),
                                //       ]
                                //     // Text(_response?.weatherInfo.description)
                                //   ),
                                // ),

                                SizedBox(height: 20),
                                // SizedBox(
                                //
                                //
                                //   child: Row(
                                //     children: [
                                //
                                //       ElevatedButton(onPressed: () async{
                                //         Position position = await _getGeoLocationPosition();
                                //         location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                                //         GetAddressFromLatLong(position);
                                //       }, child: Text('Current Location'))
                                //
                                //
                                //       // ElevatedButton(onPressed: getcurrentlocation
                                //       //
                                //       // , child: const Text("User current location:  ",)),
                                //
                                //       // ElevatedButton(onPressed: _search, child: Text('Search'))
                                //     ],
                                //   ),
                                // ),
                              ]),
                        ),
                      ),
                    )):CircularProgressIndicator(color: Colors.white,)

        ));
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    final r = await _getGeoLocationPosition();
    setState(() => _response = response);
  }
}
