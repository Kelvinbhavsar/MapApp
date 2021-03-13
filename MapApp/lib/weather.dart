import 'dart:ffi';

import 'package:MapApp/Utils/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MapApp/NetworkCall/apiManager.dart';
import 'Utils/colors.dart';
import 'Utils/constant.dart';
import 'dart:convert';

class Weather extends StatefulWidget {
  final String lat;
  final String long;
  final String address;

  const Weather({Key key, this.lat, this.long, this.address}) : super(key: key);
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentIndex = 0;
  var currentWeather = ["", ""];
  var forcastWeather = [
    ["", ""],
    ["", ""]
  ];

  @override
  void initState() {
    _tabController =
        TabController(length: 2, initialIndex: currentIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    // Constant().showProgress(context);
    apicallToGetWeatherInfo();
    super.initState();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _tabController.previousIndex) {
      setState(() {
        currentIndex = _tabController.index;
      });
    }
  }

  apicallToGetWeatherInfo() async {
    if (await Constant().isConnected()) {
      await ApiManager()
          .getRequestList(
              "https://api.openweathermap.org/data/2.5/onecall?lat=${widget.lat}&lon=${widget.long}&appid=98654aafb5d47472dcabfc314bf1ddb3")
          .then((value) {
        Constant().flushbar(context, "Success",
            "successfully fetched weather data ", Icons.info);
        var resBody = json.decode(utf8.decode(value.body.codeUnits));

        print(resBody['current']['weather']);
        setState(() {
          currentWeather = [
            resBody['current']['weather'][0]['main'],
            resBody['current']['weather'][0]['description']
          ];
          forcastWeather = [
            [
              resBody['daily'][0]['weather'][0]['main'],
              resBody['daily'][0]['weather'][0]['description']
            ],
            [
              resBody['daily'][1]['weather'][0]['main'],
              resBody['daily'][1]['weather'][0]['description']
            ],
            [
              resBody['daily'][2]['weather'][0]['main'],
              resBody['daily'][2]['weather'][0]['description']
            ],
            [
              resBody['daily'][3]['weather'][0]['main'],
              resBody['daily'][3]['weather'][0]['description']
            ],
            [
              resBody['daily'][4]['weather'][0]['main'],
              resBody['daily'][4]['weather'][0]['description']
            ]
          ];
        });
      });
    } else {
      Constant().makeflushbarForConnectivity(context);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        leading: Constant().backbutton(context),
        title: Text(
          "Weather Update",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        // sized: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: bg_white),
          child: Column(
            children: [
              // give the tab bar a height [can change hheight to preferred height]
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(12.5)),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.address,
                      style: TextStyle(fontSize: getProportionalScreenWidth(14),color: bg_white,),
                    ),
                  ),
                ),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    24.0,
                  ),
                ),
                child: TabBar(
                  onTap: (index) {
                    print("$index");
                  },
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      24.0,
                    ),
                    color: Colors.orangeAccent,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.orangeAccent,
                  labelStyle:
                      TextStyle(fontSize: getProportionalScreenWidth(14), fontWeight: FontWeight.w500),
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Current Weather',
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: '5 Day Forecast ',
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    Visibility(
                        visible: currentIndex == 0,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),color: Colors.teal,),
                              
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.7,
                            child: Card(
                              color: Colors.transparent,
                              elevation: 5,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: Text("Main:  ${(currentWeather[0])}",style: TextStyle(color: bg_white,fontSize: getProportionalScreenWidth(14)),))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: Text(
                                                "Description:  ${currentWeather[1]}",style: TextStyle(color: bg_white,fontSize: getProportionalScreenWidth(14)),)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                    // second tab bar view widget
                    Visibility(
                        visible: currentIndex == 1, child: futureTaskList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget futureTaskList() {
    return (forcastWeather.length > 0)
        ? ListView.builder(
            itemCount: forcastWeather.length,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            itemBuilder: (BuildContext cntxt, int i) {
              return tasksCell(forcastWeather[i]);
            })
        : Container(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text('No Data Available'),
            ),
          );
  }

  Widget tasksCell(List<String> str) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.teal,
          borderOnForeground: true,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.78,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(flex: 1, child: Text("Main:  ${(str[1])}",style: TextStyle(color: bg_white),))
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(flex: 1, child: Text("Description:  ${str[0]}",style: TextStyle(color: bg_white),)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
