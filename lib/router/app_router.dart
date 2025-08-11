import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../module/auth/view/login_screen.dart';
import '../module/auth/view/register_screen.dart';
import '../module/prayer/view/prayer_screen.dart';
import '../module/auth/controller/provider/auth_provider.dart';

final appRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if (auth.user == null) {
          return const LoginScreen();
        }
        return PrayerScreen();
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: "/register",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 500),
          key: state.pageKey,
          fullscreenDialog: true,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.ease)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: "/prayer",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 1),
          key: state.pageKey,
          fullscreenDialog: true,
          child: const PrayerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(
                curve: Curves.easeInOutCirc,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
