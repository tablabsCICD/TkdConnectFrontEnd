import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/tracking_response.dart';
import '../../utils/colors.dart';

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
    extends State<VehicleTrackingWithTwoPolylines>
    with WidgetsBindingObserver {
  GoogleMapController? _mapController;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  final List<LatLng> _coveredPath = [];

  Timer? _timer;
  BitmapDescriptor? _truckIcon;

  LatLng? _lastVehiclePosition;

  bool _isAnimating = false;
  bool _isFetching = false;
  bool _followVehicle = true;
  static const double _destinationThresholdMeters = 50;
  bool _hasReachedDestination = false;
  bool _isInitialRouteDrawn = false;


  // -------------------- LIFECYCLE --------------------

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _addPlannedRoute();
    _addMarkers();
    _loadTruckIcon();
    _fetchVehicleLocation();
    // 🔥 Immediate fetch after UI loads
  /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVehicleLocation();
    });
*/
    _startTrackingTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTrackingTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopTrackingTimer();
    }

    if (state == AppLifecycleState.resumed) {
      _fetchVehicleLocation();
      _startTrackingTimer();
    }
  }

  // -------------------- TIMER --------------------

  void _startTrackingTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 30),
          (_) => _fetchVehicleLocation(),
    );
  }

  void _stopTrackingTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // -------------------- ICON --------------------

  Future<void> _loadTruckIcon() async {
    final data = await rootBundle.load('assets/images/truck.png');
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 100,
    );
    final fi = await codec.getNextFrame();
    final bytes =
    (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();

    _truckIcon = BitmapDescriptor.fromBytes(bytes);
  }

  // -------------------- PLANNED ROUTE --------------------

  Future<void> _addPlannedRoute() async {
    const apiUrl =
        "https://routes.googleapis.com/directions/v2:computeRoutes";

    final body = {
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
          "X-Goog-FieldMask": "routes.polyline.encodedPolyline",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final encoded =
        data["routes"][0]["polyline"]["encodedPolyline"];

        final points = _decodePolyline(encoded);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("plannedRoute"),
              color: Colors.red,
              width: 5,
              points: points,
            ),
          );
        });
      }
    } catch (_) {}
  }

  // -------------------- LIVE LOCATION --------------------

  Future<void> _fetchVehicleLocation() async {
    if (_isFetching || _isAnimating || _hasReachedDestination) return;
    _isFetching = true;

    try {
      final response =
      await http.get(Uri.parse(ApiConstant.GET_LATLNG(widget.postId)));
        print(ApiConstant.GET_LATLNG(widget.postId));
        print(response.body);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final tracking = TrackingResponse.fromJson(json);

        if (tracking.data != null && tracking.data!.isNotEmpty) {

          // 🔥 STEP 1: FIRST TIME → draw full covered route
          if (!_isInitialRouteDrawn) {
            _coveredPath.clear();

            for (int i = 0; i < tracking.data!.length; i++) {
              final p = tracking.data![i];
              _coveredPath.add(
                LatLng(
                  double.parse(p.latitude.toString()),
                  double.parse(p.longitude.toString()),
                ),
              );
            }

            _lastVehiclePosition = _coveredPath.last;

            // ✅ MOVE CAMERA TO LIVE VEHICLE LOCATION (ONLY FIRST TIME)
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _lastVehiclePosition!,
                  zoom: 16,
                  tilt: 45,
                ),
              ),
            );


            setState(() {
              _polylines.removeWhere(
                    (p) => p.polylineId == const PolylineId("coveredPath"),
              );

              _polylines.add(
                Polyline(
                  polylineId: const PolylineId("coveredPath"),
                  color: Colors.blue,
                  width: 5,
                  points: List.from(_coveredPath),
                ),
              );

              _markers.removeWhere(
                    (m) => m.markerId == const MarkerId("vehicle"),
              );

              _markers.add(
                Marker(
                  markerId: const MarkerId("vehicle"),
                  position: _lastVehiclePosition!,
                  icon: _truckIcon!,
                  anchor: const Offset(0.5, 0.5),
                ),
              );
            });

            _isInitialRouteDrawn = true;
            _isFetching = false;
            return;
          }

          // 🔥 STEP 2: NEXT CALLS → only latest point
          final last = tracking.data!.last;
          final newPos = LatLng(
            double.parse(last.latitude.toString()),
            double.parse(last.longitude.toString()),
          );

          if (_lastVehiclePosition != null) {
            await _addRoadSnappedSegment(
              _lastVehiclePosition!,
              newPos,
            );
          }

          final distanceToDestination =
          _calculateDistanceMeters(newPos, widget.endLocation);

          if (distanceToDestination <= _destinationThresholdMeters) {
            _handleReachedDestination(newPos);
            _isFetching = false;
            return;
          }

          _lastVehiclePosition = newPos;
          _updateVehicleLocation(newPos);
        }
      }
    } catch (e) {
      debugPrint("❌ Tracking error: $e");
    }

    _isFetching = false;
  }


  void _handleReachedDestination(LatLng finalPos) async {
    if (_hasReachedDestination) return;
    _hasReachedDestination = true;

    debugPrint("🏁 Destination reached → stop tracking (FG)");

    // Stop UI timer
    _stopTrackingTimer();
    _isAnimating = false;
    _isFetching = false;

    // 🔥 STOP BACKGROUND TRACKING FOR THIS VEHICLE
    final service = FlutterBackgroundService();
    service.invoke("stopTracking", {
      "postId": widget.postId.toString(),
    });

    setState(() {
      _markers.removeWhere(
            (m) => m.markerId == const MarkerId("vehicle"),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId("vehicle"),
          position: finalPos,
          icon: _truckIcon!,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vehicle reached destination 🚩")),
    );
  }


  // -------------------- ROAD SNAPPING --------------------

  Future<void> _addRoadSnappedSegment(LatLng from, LatLng to) async {
    final uri = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json"
          "?origin=${from.latitude},${from.longitude}"
          "&destination=${to.latitude},${to.longitude}"
          "&mode=driving"
          "&key=${AppConstant.GOOGLE_KEY}",
    );

    final response = await http.get(uri);
    final data = jsonDecode(response.body);

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final encoded =
      data['routes'][0]['overview_polyline']['points'];
      final points = _decodePolyline(encoded);

      setState(() {
        _coveredPath.addAll(points);

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
  }

  void _addMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId("start"),
        position: widget.startLocation,
        infoWindow: const InfoWindow(title: "Start Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: widget.endLocation,
        infoWindow: const InfoWindow(title: "Destination"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ),
    ]);
  }

  // -------------------- VEHICLE ANIMATION --------------------

  void _updateVehicleLocation(LatLng newPos) {
    if (_truckIcon == null || _isAnimating) return;
    _isAnimating = true;

    final oldMarker = _markers.firstWhere(
          (m) => m.markerId == const MarkerId("vehicle"),
      orElse: () => Marker(
        markerId: const MarkerId("vehicle"),
        position: newPos,
        icon: _truckIcon!,
      ),
    );

    final oldPos = oldMarker.position;
    final bearing = _getBearing(oldPos, newPos);

    const duration = Duration(seconds: 2);
    const fps = 30;
    final steps = duration.inMilliseconds ~/ (1000 ~/ fps);
    int i = 0;

    Timer.periodic(Duration(milliseconds: (1000 ~/ fps)), (timer) {
      i++;
      final t = i / steps;

      final pos = LatLng(
        oldPos.latitude + (newPos.latitude - oldPos.latitude) * t,
        oldPos.longitude + (newPos.longitude - oldPos.longitude) * t,
      );

      setState(() {
        _markers.removeWhere(
                (m) => m.markerId == const MarkerId("vehicle"));
        _markers.add(
          Marker(
            markerId: const MarkerId("vehicle"),
            position: pos,
            icon: _truckIcon!,
            rotation: bearing,
            anchor: const Offset(0.5, 0.5),
          ),
        );
      });

      if (_followVehicle) {
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: pos,
              zoom: 16,
              bearing: bearing,
              tilt: 45,
            ),
          ),
        );
      }

      if (i >= steps) {
        timer.cancel();
        _isAnimating = false;
      }
    });
  }

  // -------------------- HELPERS --------------------

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  double _getBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lon1 = start.longitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final lon2 = end.longitude * pi / 180;

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    return (atan2(y, x) * 180 / pi + 360) % 360;
  }


  double _calculateDistanceMeters(LatLng a, LatLng b) {
    const earthRadius = 6371000; // meters

    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;

    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;

    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) *
            sin(dLon / 2) * sin(dLon / 2);

    return 2 * earthRadius * asin(sqrt(h));
  }

  // -------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Live Vehicle Tracking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ThemeColor.red,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.startLocation,
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        zoomControlsEnabled: false,
        myLocationEnabled: false,
        onMapCreated: (c) => _mapController = c,
        onCameraMoveStarted: () => _followVehicle = false,
      ),
    );
  }
}
