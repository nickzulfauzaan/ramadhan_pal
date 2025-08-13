import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ramadhan_pal/constant/widget_constant.dart';
import 'package:sizer/sizer.dart';
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
        error: {e.code, e.message},
        stackTrace: e.stackTrace,
      );

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account with this email already exists.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'operation-not-allowed':
          message =
              'Email/password sign-up is not enabled. Please contact support.';
          break;
        case 'weak-password':
          message =
              'Your password is too weak. Try using at least 6 characters with a mix of letters and numbers.';
          break;
        case 'too-many-requests':
          message =
              'Too many sign-up attempts. Please wait a moment and try again.';
          break;
        case 'user-token-expired':
          message =
              'Your session has expired. Please log in again to continue.';
          break;
        case 'network-request-failed':
          message =
              'No internet connection. Please check your network and try again.';
          break;
        default:
          message = 'Registration failed. Please try again later.';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.green[50],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.f('REGISTRATION_FATAL', error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An unexpected error occurred. Please try again.',
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.green[50],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
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
      logger.e(
        'LOGIN_ERROR',
        error: {e.code, e.message},
        stackTrace: e.stackTrace,
      );

      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'user-not-found':
          message = 'No account found for this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'too-many-requests':
          message =
              'Too many login attempts. Please wait a moment and try again.';
          break;
        case 'user-token-expired':
          message =
              'Your session has expired. Please log in again to continue.';
          break;
        case 'network-request-failed':
          message = 'No internet connection. Please check your network.';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password. Please check your credentials.';
          break;
        case 'operation-not-allowed':
          message =
              'Email/password sign-in is not enabled. Please contact support.';
          break;
        default:
          message = 'Login failed. Please try again later.';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.green[50],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.f('LOGIN_FATAL', error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An unexpected error occurred. Please try again.',
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.green[50],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _service.signOut();
    } on FirebaseAuthException catch (e) {
      logger.e(
        'SIGN_OUT_ERROR',
        error: {e.code, e.message},
        stackTrace: e.stackTrace,
      );
    } catch (e, stackTrace) {
      logger.f('SIGN_OUT_FATAL', error: e, stackTrace: stackTrace);
    }
  }
}
