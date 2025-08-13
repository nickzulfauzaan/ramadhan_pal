import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/auth/controller/provider/auth_provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';
import 'package:ramadhan_pal/widget/prayer_times_card.dart';
import 'package:ramadhan_pal/widget/qibla_card.dart';
import 'package:ramadhan_pal/widget/welcome_card.dart';
import 'package:sizer/sizer.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final _cityCtl = TextEditingController();
  final _countryCtl = TextEditingController(text: 'Malaysia');

  @override
  void dispose() {
    _cityCtl.dispose();
    _countryCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final displayName =
        auth.user?.displayName ?? auth.user?.email?.split('@')[0] ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Row(
          children: [
            Icon(Icons.nightlight_outlined, size: 40, color: Colors.white),
            Text(
              'RamadhanPal',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              context.read<PrayerProvider>().reset();
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 7.h, top: 1.h),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeCard(displayName: displayName),
              SizedBox(height: 2.h),
              _buildSectionHeader(
                icon: Icons.explore,
                title: 'Qibla Direction',
              ),
              SizedBox(height: 1.h),
              const QiblaCard(),
              SizedBox(height: 3.h),
              _buildSectionHeader(
                icon: Icons.access_time,
                title: 'Prayer Times',
              ),
              SizedBox(height: 1.h),
              PrayerTimesCard(
                cityController: _cityCtl,
                countryController: _countryCtl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 20.sp),
            SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
