import 'package:hive_flutter/hive_flutter.dart';

class OfflineLocationStore {
  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('offline_locations');
  }

  static Future<void> save(Map<String, dynamic> data) async {
    await _box?.add(data);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    if (_box == null) return [];
    return _box!.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> clear() async {
    await _box?.clear();
  }
}
