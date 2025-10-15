import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:tkd_connect/constant/api_constant.dart';  // ✅ Correct import

class LocationService {
  final Location _location = Location();
  final Map<int, Timer> _activePosts = {}; // Track multiple posts

  void startSendingLocation(int postId, String vehicleId, String driverNumber) {
    _activePosts[postId]?.cancel();

    _activePosts[postId] = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final loc = await _location.getLocation();
      print("${loc.latitude} And ${loc.longitude}");
      String myUrl = ApiConstant.SAVE_LATLNG(postId,vehicleId,driverNumber);
      print(myUrl);
      if (loc.latitude != null && loc.longitude != null) {

      var response=  await http.post(
          Uri.parse(myUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "dateTime": DateTime.now().toUtc().toIso8601String(),
            "latitude": loc.latitude,
            "longitude": loc.longitude,
            "speed": 80
          }),
        );
      print(response.statusCode);
      print(response.body);
      }
    });
  }

  void stopSendingLocation(int postId) {
    _activePosts[postId]?.cancel();
    _activePosts.remove(postId);
  }

  void stopAll() {
    for (var timer in _activePosts.values) {
      timer.cancel();
    }
    _activePosts.clear();
  }
}
