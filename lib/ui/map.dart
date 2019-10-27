import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<String> routeList = ['route01', 'route138', 'route155', 'route400'];
  String dropdownValue = 'route01';
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // 
  double lan = 6.9020677;
  double lat = 79.8609369;

  DatabaseReference databaseReference;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.9020677, 79.8609369),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            
          ),
          Positioned(
            top: 35,
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 80,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Select Route'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _dropDownMenu(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () {},
      ),
    );
  }

  Widget _dropDownMenu() {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          
        });
        _getLocations();
      },
      items: routeList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  _getLocations() async {
    databaseReference = firebaseDatabase.reference();
    databaseReference.child('routes/$dropdownValue/sessions').onChildAdded.listen((onData) {
      setState(() {
       if (onData.snapshot.value['dateTime'])
      });
    });
  }
}
