import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/tracking_response.dart';
import '../../utils/colors.dart';
import 'dart:typed_data';



class VehicleTrackingWithTwoPolylines extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final String vehicleId;
  final String driverNumber;
  final int? postId;

  const VehicleTrackingWithTwoPolylines({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.vehicleId,
    required this.driverNumber,
    required this.postId,
  });

  @override
  State<VehicleTrackingWithTwoPolylines> createState() =>
      _VehicleTrackingWithTwoPolylinesState();
}

class _VehicleTrackingWithTwoPolylinesState
    extends State<VehicleTrackingWithTwoPolylines> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
   List<LatLng> _coveredPath = [];
  Timer? _timer;
  BitmapDescriptor? _truckIcon;

  @override
  void initState() {
    super.initState();
    _addPlannedRoute();
    _addMarkers();
    _loadTruckIcon();
    // fetch vehicle location every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchVehicleLocation();
    });
  }

  Future<void> _loadTruckIcon() async {
    final ByteData data = await rootBundle.load('assets/images/truck.png');
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 120, // 👈 increase width here
      targetHeight: 120, // 👈 and height here
    );
    final FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedData =
    (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();

    _truckIcon = BitmapDescriptor.fromBytes(resizedData);
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 1️⃣ Planned route using Google Routes API v2
  Future<void> _addPlannedRoute() async {
    const String apiUrl = "https://routes.googleapis.com/directions/v2:computeRoutes";

    final Map<String, dynamic> body = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": widget.startLocation.latitude,
            "longitude": widget.startLocation.longitude
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": widget.endLocation.latitude,
            "longitude": widget.endLocation.longitude
          }
        }
      },
      "travelMode": "DRIVE",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": AppConstant.GOOGLE_KEY,
          // We only need the encoded polyline field
          "X-Goog-FieldMask": "routes.polyline.encodedPolyline",
        },
        body: jsonEncode(body),
      );

      debugPrint("Routes API v2 response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final encodedPolyline = data["routes"][0]["polyline"]["encodedPolyline"];
          final List<LatLng> routePoints = _decodePolyline(encodedPolyline);

          if (routePoints.isNotEmpty) {
            setState(() {
              _polylines.add(Polyline(
                polylineId: const PolylineId("plannedRoute"),
                color: Colors.red,
                width: 5,
                points: routePoints,
              ));

              _fitMapToPolyline(routePoints);
            });

            debugPrint("✅ Planned Route (v2) added with ${routePoints.length} points");
          }
        } else {
          debugPrint("❌ No routes found in response");
        }
      } else {
        debugPrint("❌ Routes API failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Exception calling Routes API v2: $e");
    }
  }


  /// Helper: fit map bounds to polyline
  void _fitMapToPolyline(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    LatLngBounds bounds;
    if (points.length == 1) {
      bounds = LatLngBounds(
        southwest: points.first,
        northeast: points.first,
      );
    } else {
      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (var p in points) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }

      bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
    }

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  /// Polyline decoder
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  void _addMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId("start"),
        position: widget.startLocation,
        infoWindow: const InfoWindow(title: "Start Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: widget.endLocation,
        infoWindow: const InfoWindow(title: "End Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);
  }

  /// 2️⃣ Fetch live vehicle location periodically
  Future<void> _fetchVehicleLocation() async {
    String myUrl = ApiConstant.GET_LATLNG(widget.postId);
    debugPrint("Fetching vehicle location: $myUrl");

    try {
      final response = await http.get(Uri.parse(myUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final trackingResponse = TrackingResponse.fromJson(json);

        if (trackingResponse.data != null && trackingResponse.data!.isNotEmpty) {
          _coveredPath = trackingResponse.data!
              .map((e) => LatLng(
              double.parse(e.latitude.toString()),
              double.parse(e.longitude.toString())))
              .toList();

          // Last known position
          final lastPoint = _coveredPath.last;
          // Update map with full path and vehicle
          _updateVehicleLocation(lastPoint);

        } else {
          debugPrint("⚠️ Empty data in tracking API");
        }
      } else {
        debugPrint("❌ Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching: $e");
    }
  }

  /// Update live path
  /// Update vehicle marker and route on map
  /// Smooth vehicle animation like Ola/Uber
  void _updateVehicleLocation(LatLng newPos) {
    if (_truckIcon == null) return;

    final oldMarker = _markers.firstWhere(
          (m) => m.markerId == const MarkerId("vehicle"),
      orElse: () => Marker(
        markerId: const MarkerId("vehicle"),
        position: newPos,
        icon: _truckIcon!,
      ),
    );

    final oldPos = oldMarker.position;

    // Calculate bearing (rotation)
    double bearing = _getBearing(oldPos, newPos);

    // Animate movement
    const duration = Duration(seconds: 2);
    const fps = 30;
    int steps = duration.inMilliseconds ~/ (1000 ~/ fps);
    int i = 0;
    Timer.periodic(Duration(milliseconds: (1000 ~/ fps)), (timer) {
      i++;
      double t = i / steps;
      double lat = oldPos.latitude + (newPos.latitude - oldPos.latitude) * t;
      double lng = oldPos.longitude + (newPos.longitude - oldPos.longitude) * t;
      LatLng intermediatePos = LatLng(lat, lng);

      setState(() {
        _markers.removeWhere((m) => m.markerId == const MarkerId("vehicle"));
        _markers.add(
          Marker(
            markerId: const MarkerId("vehicle"),
            position: intermediatePos,
            icon: _truckIcon!,
            rotation: bearing,
            anchor: const Offset(0.5, 0.5),
          ),
        );
      });

      // Move camera smoothly
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(intermediatePos),
      );

      if (i >= steps) {
        timer.cancel();
        // Once animation completes, update path line
        setState(() {
          _polylines.removeWhere(
                  (p) => p.polylineId == const PolylineId("coveredPath"));
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("coveredPath"),
              color: Colors.blue,
              width: 5,
              points: List.from(_coveredPath),
            ),
          );
        });
      }
    });
  }

  /// Bearing calculation (direction angle between two points)
  double _getBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (pi / 180.0);
    double lon1 = start.longitude * (pi / 180.0);
    double lat2 = end.latitude * (pi / 180.0);
    double lon2 = end.longitude * (pi / 180.0);

    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) -
        sin(lat1) * cos(lat2) * cos(dLon);
    double brng = atan2(y, x);
    brng = brng * (180.0 / pi);
    return (brng + 360.0) % 360.0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Tracking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ThemeColor.red,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.startLocation,
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
