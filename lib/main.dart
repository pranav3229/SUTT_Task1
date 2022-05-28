
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final _dataService = DataService();

  WeatherResponse? _response;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(



          // resizeToAvoidBottomInset : false,
          backgroundColor: Colors.white38,

          body: SingleChildScrollView(
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
                            fontWeight:
                            FontWeight.bold,
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

                                  margin: EdgeInsets.fromLTRB(80, 30, 60, 0),

                                  child: Text(
                                    '${_response?.weatherInfo.description}°',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 35,),
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
                              SizedBox(width:100,height:50),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                    controller: _cityTextController,
                                    decoration: InputDecoration(labelText: 'City'),
                                    textAlign: TextAlign.center),
                              ),
                              ElevatedButton(onPressed: _search, child: Text('Search'))
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


                        child: Row(


                            children: [
                              SizedBox(width: 80),
                              Text(


                                '${_response?.tempInfo.temperature}°',
                                style: TextStyle(fontSize: 100,
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


                        child: Row(



                            children: [
                              SizedBox(width:140),
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


                        child: Row(



                            children: [
                              SizedBox(width:140),
                              Text(
                                'Humidity :${_response?.humidity.humidity}°',
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

                      SizedBox(height:20),
                      // ElevatedButton(onPressed: _search, child: Text('Search'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
  }
}