import 'package:flutter/material.dart';
import 'package:ramadhan_pal/constant/widget_constant.dart';
import '../service/prayer_service.dart';

class PrayerProvider with ChangeNotifier {
  final PrayerService _service = PrayerService();

  bool isLoading = false;
  String? error;
  Map<String, dynamic>? data;

  Future<void> getPrayerTimes(String city, String country) async {
    isLoading = true;
    error = null;
    data = null;
    notifyListeners();

    try {
      final result = await _service.fetchTimesByCity(city, country);
      data = result;
    } catch (e, stackTrace) {
      error = e.toString();
      logger.e('PRAYER_PROVIDER_ERROR', error: e, stackTrace: stackTrace);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    data = null;
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
