import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:geocoding/geocoding.dart';

class GeoHelper {
  static const String _apiKey = AppConstant.GOOGLE_KEY;

  /*/// Get latitude and longitude from city name
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
  }*/

  // simple in-memory cache for offline reuse
  static final Map<String, Map<String, double>> _cityCache = {
    "pune": {"lat": 18.5204, "lng": 73.8567},
    "mumbai": {"lat": 19.0760, "lng": 72.8777},
    "delhi": {"lat": 28.6139, "lng": 77.2090},
    "bangalore": {"lat": 12.9716, "lng": 77.5946},
    "chennai": {"lat": 13.0827, "lng": 80.2707},
    "hyderabad": {"lat": 17.3850, "lng": 78.4867},
    "kolkata": {"lat": 22.5726, "lng": 88.3639},
  };

  static Future<Map<String, double>?> getLatLngFromCity(String cityName) async {
    final key = cityName.toLowerCase().trim();

    // Step 1: Check cache first (offline fallback)
    if (_cityCache.containsKey(key)) {
      print("Loaded $cityName from cache");
      return _cityCache[key];
    }

    // Step 2: Try to get coordinates online using geocoding package
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        final result = {
          "lat": locations.first.latitude,
          "lng": locations.first.longitude,
        };

        // store in cache for future offline use
        _cityCache[key] = result;

        print("Fetched $cityName online and cached result");
        return result;
      }
    } catch (e) {
      print("Error fetching location for $cityName: $e");
    }

    // Step 3: Return null if not found
    print("No location found for $cityName");
    return null;
  }

  /*static final Map<String, Map<String, double>> _cityCache = {
    "pune": {"lat": 18.5204, "lng": 73.8567},
    "mumbai": {"lat": 19.0760, "lng": 72.8777},
    "delhi": {"lat": 28.6139, "lng": 77.2090},
    "bangalore": {"lat": 12.9716, "lng": 77.5946},
    "chennai": {"lat": 13.0827, "lng": 80.2707},
    "hyderabad": {"lat": 17.3850, "lng": 78.4867},
    "kolkata": {"lat": 22.5726, "lng": 88.3639},
  };

  static bool _initialized = false;

  /// Initialize cache from SharedPreferences
  static Future<void> _initCache() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('city_cache');
    if (savedData != null) {
      final Map<String, dynamic> decoded = json.decode(savedData);
      decoded.forEach((key, value) {
        _cityCache[key] = Map<String, double>.from(value);
      });
      print("Loaded cached city data from SharedPreferences");
    }
    _initialized = true;
  }

  /// Save updated cache to SharedPreferences
  static Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city_cache', json.encode(_cityCache));
  }

  /// Main method to get lat/lng from city name
  static Future<Map<String, double>?> getLatLngFromCity(String cityName) async {
    await _initCache();
    final key = cityName.toLowerCase().trim();

    // Step 1: Check local cache (offline)
    if (_cityCache.containsKey(key)) {
      print("Loaded $cityName from cache");
      return _cityCache[key];
    }

    // Step 2: Fetch online (geocoding)
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        final result = {
          "lat": locations.first.latitude,
          "lng": locations.first.longitude,
        };

        // Step 3: Save result to memory + SharedPreferences
        _cityCache[key] = result;
        await _saveCache();

        print("Fetched $cityName online and cached result");
        return result;
      }
    } catch (e) {
      print("Error fetching location for $cityName: $e");
    }

    // Step 4: Fallback
    print("No location found for $cityName");
    return null;
  }*/
}
