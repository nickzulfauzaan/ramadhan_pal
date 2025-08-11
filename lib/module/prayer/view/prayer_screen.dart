import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/auth/controller/provider/auth_provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';
import 'package:ramadhan_pal/module/prayer/view/fast_tracking.dart';
import 'package:sizer/sizer.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final _cityCtl = TextEditingController();
  final _countryCtl = TextEditingController(text: 'Malaysia');

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.green[700]),
      labelText: label,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      ),
      filled: true,
      fillColor: Colors.green.shade50,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final prayer = Provider.of<PrayerProvider>(context);

    final displayName =
        auth.user?.displayName ?? auth.user?.email?.split('@')[0] ?? 'Friend';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          'Prayer Times',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              if (!context.mounted) return;
              context.go('login');
              await auth.logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Assalamualaikum, $displayName 👋',
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Check today’s prayer times in your city.',
              style: GoogleFonts.montserrat(
                fontSize: 11.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 3.h),
            TextField(
              controller: _cityCtl,
              decoration: _inputDecoration(
                'City (e.g., Kuala Lumpur)',
                Icons.location_city_outlined,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _countryCtl,
              decoration: _inputDecoration(
                'Country (e.g., Malaysia)',
                Icons.flag_outlined,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.access_time, color: Colors.white),
                label: Text(
                  'Get Prayer Times',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  final city = _cityCtl.text.trim();
                  final country = _countryCtl.text.trim();
                  if (city.isEmpty || country.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter city and country')),
                    );
                    return;
                  }
                  prayer.getPrayerTimes(city, country);
                },
              ),
            ),
            SizedBox(height: 2.h),
            if (prayer.isLoading) Center(child: CircularProgressIndicator()),
            if (prayer.error != null)
              Text(
                prayer.error!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            if (prayer.data != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.only(top: 2.h),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${prayer.data!['date']['readable']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[900],
                        ),
                      ),
                      Divider(height: 24),
                      _buildTimeRow('Fajr', prayer.data!['timings']['Fajr']),
                      _buildTimeRow('Dhuhr', prayer.data!['timings']['Dhuhr']),
                      _buildTimeRow('Asr', prayer.data!['timings']['Asr']),
                      _buildTimeRow(
                        'Maghrib',
                        prayer.data!['timings']['Maghrib'],
                      ),
                      _buildTimeRow('Isha', prayer.data!['timings']['Isha']),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green[700]!),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(Icons.fastfood, color: Colors.green[700]),
                          label: Text(
                            'Open Fasting Tracker',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FastingTrackerScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value, style: GoogleFonts.montserrat()),
        ],
      ),
    );
  }
}
