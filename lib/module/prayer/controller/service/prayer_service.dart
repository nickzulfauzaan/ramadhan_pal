import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  // city and country strings
  Future<Map<String, dynamic>> fetchTimesByCity(
    String city,
    String country,
  ) async {
    final url = Uri.parse(
      'http://api.aladhan.com/v1/timingsByCity?city=${Uri.encodeComponent(city)}&country=${Uri.encodeComponent(country)}&method=2',
    );
    final resp = await http.get(url);
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch prayer times (${resp.statusCode})');
    }
    final json = jsonDecode(resp.body);
    if (json['code'] != 200) {
      throw Exception('API error: ${json['status']}');
    }
    // returns the timings map and date info
    return json['data'];
  }
}
