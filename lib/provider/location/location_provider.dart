import 'package:flutter/cupertino.dart';

import '../../screen/tracking/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  void startTracking(int postId, String vehicleId, String driverNumber) {
    _locationService.startSendingLocation(postId, vehicleId, driverNumber);
  }

  void stopTracking(int postId) {
    _locationService.stopSendingLocation(postId);
  }
}
