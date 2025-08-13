import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadhan_pal/constant/widget_constant.dart';

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

    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        logger.e(
          'Failed to fetch prayer times',
          error: 'HTTP ${resp.statusCode}',
          stackTrace: StackTrace.current,
        );
        throw Exception('Failed to fetch prayer times (${resp.statusCode})');
      }

      final json = jsonDecode(resp.body);
      if (json['code'] != 200) {
        logger.e(
          'API returned error status',
          error: json['status'],
          stackTrace: StackTrace.current,
        );
        throw Exception('API error: ${json['status']}');
      }

      return json['data'];
    } catch (e, stackTrace) {
      logger.f('PRAYER_SERVICE_FATAL', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
