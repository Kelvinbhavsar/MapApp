import 'dart:async';

import 'package:MapApp/CustomUI/Models/Location.dart';
import 'package:MapApp/CustomUI/alertdialog.dart';
import 'package:MapApp/Utils/sizeconfig.dart';
import 'package:MapApp/signIn.dart';
import 'package:MapApp/weather.dart';
import 'package:MapApp/history.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  static const LatLng _center = const LatLng(23.0225, 72.5714);
  LocationData currentLocation;
  Marker centerMarker;
  var currentAdd = "";
  var phone = "";

  @override
  void initState() {
    super.initState();
    getUserLocation();
    getUserdata();
  }
   getUserdata() async{
     await SharedPreferences.getInstance().then((value){
      setState(() {
        phone = value.get('userNumber') ?? "";
      });
     });
      
  }
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   /*AIzaSyBxGowZqeQnRVw8aLcWnL2UpMufxVL9TOc */
    // );
    SizeConfig().init(context);
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Phone Number"),
                accountEmail: Text(phone),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Text(
                    "W",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              Column(
                children: [
                  
                  GestureDetector(
                    child: makeListtile("History Screen"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => History()));
                    },
                  ),
                  GestureDetector(
                    child: makeListtile("Logout"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialogBox(
                          onOff: false,
                          type: 0,
                          title: "Logout!",
                          message: "Are you sure you want to logout?",
                          onNegative: popContext,
                          onPositive: () async {
                            await SharedPreferences.getInstance().then((value){
                              value.setInt('userLogged', 0);
                              int total = value.getInt('totalLocations');
                              if (total != null) {

                              for (int i = 0 ; i<total ; i++) {
                                value.remove('Location_${i.toString()}');
                              }
                              value.remove('totalLocations');
                              }
                            });
                            
                            Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Login()),(Route<dynamic> route )=> false);
                            
                          },
                          isUpdate: false,
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Map App'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,

            initialCameraPosition: CameraPosition(
              target: currentLocation != null
                  ? LatLng(currentLocation.latitude, currentLocation.longitude)
                  : LatLng(23.0225, 72.5714),
              zoom: 11.0,
            ),
            markers: _markers.values.toSet(),
            myLocationEnabled: true,

            onCameraMove: (CameraPosition position) {
              if (_markers.length > 0) {
                MarkerId markerId = MarkerId(_markerIdVal());
                Marker marker = _markers[markerId];
                Marker updatedMarker = marker.copyWith(
                  positionParam: position.target,
                );
                setState(() {
                  print(updatedMarker.position.latitude);

                  print(updatedMarker.position.longitude);
                  _markers[markerId] = updatedMarker;
                  centerMarker = updatedMarker;
                  getaddressFromLatlong(Coordinates(
                      updatedMarker.position.latitude,
                      updatedMarker.position.longitude));
                });
              }
            },
            // YOUR MARKS IN MAP
          ),
          SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.orangeAccent,
                  clipBehavior: Clip.antiAlias,
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    // getUserLocation();
                    print(prefs.getInt('totalLocations'));
                    if (prefs.getInt('totalLocations') != null &&
                        prefs.getInt('totalLocations') > 0) {
                      prefs.setStringList(
                          "Location_${prefs.getInt('totalLocations')}", [
                        centerMarker.position.latitude.toString(),
                        centerMarker.position.longitude.toString(),
                        currentAdd
                      ]);
                      prefs.setInt(
                          "totalLocations", prefs.getInt('totalLocations') + 1);
                    } else {
                      prefs.setStringList("Location_0", [
                        centerMarker.position.latitude.toString(),
                        centerMarker.position.longitude.toString(),
                        currentAdd
                      ]);
                      prefs.setInt("totalLocations", 1);
                    }
                    print(prefs.getStringList("Location_0"));

                    Flushbar(title: "Successfully Location Added");

                    Navigator.push(
                        context,
                        MaterialPageRoute(

                            builder: (context) => Weather(
                                  address: currentAdd,
                                  lat:
                                      centerMarker.position.latitude.toString(),
                                  long: centerMarker.position.longitude
                                      .toString(),
                                )));
                  },
                  child: Container(
                    // height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5)),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12.5)),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    currentAdd,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  makeListtile(String str) {
    return ListTile(
      title: Text(
        str,
        style: TextStyle(
          fontSize: getProportionalScreenWidth(14),
        ),
      ),
      trailing: Icon(Icons.arrow_right),
    );
  }

  popContext() {
    Navigator.pop(context);
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    if (_center != null) {
      print("Done done");
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = _center;
      Marker marker = Marker(
          markerId: markerId,
          position: position,
          draggable: false,
          visible: true);
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _controller.future;
        controller.showMarkerInfoWindow(markerId);
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
        // setState(() {
        // });
      });
    }
  }

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    return getaddressFromLatlong(
        Coordinates(myLocation.latitude, myLocation.longitude));
  }

  getaddressFromLatlong(Coordinates myLocation) async {
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        '1 ${first.locality},2 ${first.adminArea},3${first.subLocality}, 4${first.subAdminArea},5${first.addressLine},6 ${first.featureName},7${first.thoroughfare},8 ${first.subThoroughfare}');

    setState(() {
      currentAdd = "${first.addressLine}";
    });
    return first;
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }
}
