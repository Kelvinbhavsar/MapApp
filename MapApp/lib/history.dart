import 'package:MapApp/Utils/colors.dart';
import 'package:MapApp/weather.dart';
import 'package:flutter/material.dart';

import 'package:MapApp/Utils/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var totalLocations = 0;
  SharedPreferences prefs;

  @override
  Future<void> initState() {
    super.initState();
    fetchTotalLocation();
  }

  void fetchTotalLocation() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      totalLocations = prefs.getInt('totalLocations') ?? 0;
    });

    print("total ${totalLocations.toString() ?? 0}");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Map App'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: bg_white),
          child: futureTaskList()),
    );
  }

  Widget futureTaskList() {
    return (totalLocations  > 0)
        ? ListView.builder(
            itemCount: totalLocations,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            itemBuilder: (BuildContext cntxt, int i) {
              return tasksCell(prefs.getStringList('Location_${i.toString()}'));
            })
        : Container(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text('No Associated Location Available'),
            ),
          );
  }

  Widget tasksCell(List<String> str) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Weather(address: str[2], lat: str[0], long: str[1])));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          borderOnForeground: true,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("Location:  ${str[2]}"))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                              flex: 1, child: Text("Latitude:  ${(str[0])}"))
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                              flex: 1, child: Text("Longitude:  ${str[1]}")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                      child: Icon(
                Icons.keyboard_arrow_right,
              )))
            ],
          ),
        ),
      ),
    );
  }
}
