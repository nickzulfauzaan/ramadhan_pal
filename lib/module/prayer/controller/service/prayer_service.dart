import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  Future<Map<String, dynamic>> fetchTimesByCity(
    String city,
    String country,
  ) async {
    final url = Uri.parse(
      'http://api.aladhan.com/v1/timingsByCity'
      '?city=${Uri.encodeComponent(city)}'
      '&country=${Uri.encodeComponent(country)}'
      '&method=17'
      '&timezone=Asia/Kuala_Lumpur',
    );

    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch prayer times (${resp.statusCode})');
    }

    final json = jsonDecode(resp.body);
    if (json['code'] != 200) {
      throw Exception('API error: ${json['status']}');
    }

    return json['data'];
  }
}
