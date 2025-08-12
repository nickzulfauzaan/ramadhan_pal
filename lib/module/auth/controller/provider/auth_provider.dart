import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadhan_pal/constant/widget_constant.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? user;
  bool isLoading = true;
  bool isAuthLoading = false;

  AuthProvider() {
    _service.authStateChanges().listen((userData) {
      user = userData;
      isLoading = false;
      notifyListeners();
    });
  }

  Future register(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      isAuthLoading = true;
      notifyListeners();

      await _service.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );

      if (!context.mounted) return;
      context.go('/prayer');
    } on FirebaseAuthException catch (e) {
      logger.e(
        'REGISTRATION_ERROR',
        error: e.message,
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      logger.f('REGISTRATION_FATAL', error: e, stackTrace: stackTrace);
    } finally {
      isAuthLoading = false;
      notifyListeners();
    }
  }

  Future login(String email, String password, BuildContext context) async {
    try {
      isAuthLoading = true;
      notifyListeners();

      await _service.signInWithEmail(email: email, password: password);

      if (!context.mounted) return;
      context.go('/prayer');
    } on FirebaseAuthException catch (e) {
      logger.e('LOGIN_ERROR', error: e.message, stackTrace: e.stackTrace);
    } catch (e, stackTrace) {
      logger.f('LOGIN_FATAL', error: e, stackTrace: stackTrace);
    } finally {
      isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _service.signOut();
    } on FirebaseAuthException catch (e) {
      logger.e('SIGN_OUT_ERROR', error: e.message, stackTrace: e.stackTrace);
    } catch (e, stackTrace) {
      logger.f('SIGN_OUT_FATAL', error: e, stackTrace: stackTrace);
    }
  }
}
