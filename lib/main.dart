import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ramadhan_pal/module/auth/controller/provider/auth_provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RamadanCompanionApp());
}

class RamadanCompanionApp extends StatelessWidget {
  const RamadanCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PrayerProvider()),
          ],
          child: MaterialApp.router(
            title: 'Ramadan Companion',
            theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
