import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../constant/app_constant.dart';

class GoogleMapAddressPicker extends StatefulWidget {
  @override
  _GoogleMapAddressPickerState createState() => _GoogleMapAddressPickerState();
}

class _GoogleMapAddressPickerState extends State<GoogleMapAddressPicker> {
  late GoogleMapController _mapController;
  LatLng _pickedLocation = LatLng(18.520418, 73.8567); // Default to San Francisco
  String _fullAddress = "Tap on the map to pick an address";
  String _city = "";

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.animateCamera(CameraUpdate.newLatLng(_pickedLocation));
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${AppConstant.GOOGLE_KEY}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["results"].isNotEmpty) {
          setState(() {
            _fullAddress = data["results"][0]["formatted_address"];
            _city = data["results"][0]["address_components"]
                .firstWhere((comp) => comp["types"].contains("locality"))["long_name"];
          });
        }
      } else {
        print("Failed to fetch address: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Address"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 15,
            ),
            onTap: (LatLng position) {
              setState(() {
                _pickedLocation = position;
              });
              _getAddressFromLatLng(position);
            },
            markers: {
              Marker(
                markerId: MarkerId("picked-location"),
                position: _pickedLocation,
              )
            },
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Full Address:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _fullAddress,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "City: $_city",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
