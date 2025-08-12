import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

class QiblaProvider extends ChangeNotifier {
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  double? _qiblaDirection;
  double? _currentHeading;
  Position? _userLocation;
  bool _isLoading = true;
  String? _error;
  StreamSubscription<CompassEvent>? _compassSubscription;
  double? _distanceToKaaba;

  double? get qiblaDirection => _qiblaDirection;
  double? get currentHeading => _currentHeading;
  Position? get userLocation => _userLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double? get distanceToKaaba => _distanceToKaaba;

  double? get qiblaDifference {
    if (_currentHeading == null || _qiblaDirection == null) return null;

    double diff = _qiblaDirection! - _currentHeading!;

    while (diff > 180) {
      diff -= 360;
    }
    while (diff < -180) {
      diff += 360;
    }
    return diff;
  }

  bool get isPointingToQibla {
    final diff = qiblaDifference;
    return diff != null && diff.abs() <= 5;
  }

  Future<void> initializeQibla() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      await _requestPermissions();
      await _getUserLocation();
      _startCompassListening();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }
  }

  Future<void> _getUserLocation() async {
    try {
      _userLocation = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
        // ignore: deprecated_member_use
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      throw Exception('Failed to get location: ${e.toString()}');
    }
  }

  void _startCompassListening() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        _currentHeading = event.heading;
        notifyListeners();
      }
    });
  }

  Future<void> recalibrate() async {
    await initializeQibla();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}
