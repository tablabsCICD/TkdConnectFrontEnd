import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/constant/app_constant.dart';

class GeoHelper {
  static const String _apiKey = AppConstant.GOOGLE_KEY;

  /// Get latitude and longitude from city name
  static Future<Map<String, double>?> getLatLngFromCity(String cityName) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?address=$cityName&key=$_apiKey",
    );
    print(url);
    final response = await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "OK") {
        final location = data["results"][0]["geometry"]["location"];
        return {
          "lat": location["lat"],
          "lng": location["lng"],
        };
      }
    }
    return null;
  }
}
