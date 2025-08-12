import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';
import 'package:ramadhan_pal/widget/error_widget.dart';
import 'package:sizer/sizer.dart';

class PrayerTimesResult extends StatelessWidget {
  const PrayerTimesResult({super.key});

  String formatToLocal12Hour(String timeStr) {
    try {
      final now = DateTime.now();
      final parsed = DateFormat("HH:mm").parseUtc(timeStr);

      final localTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsed.hour,
        parsed.minute,
      ).toLocal();
      return DateFormat("h:mm a").format(localTime);
    } catch (e) {
      return timeStr;
    }
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

  @override
  Widget build(BuildContext context) {
    final prayer = Provider.of<PrayerProvider>(context);

    if (prayer.error != null) return PrayerErrorWidget();
    if (prayer.data == null) return SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(top: 2.h),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${prayer.data!['date']['readable']}',
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green[900],
              ),
            ),
            Divider(height: 4.h),
            _buildTimeRow(
              'Fajr',
              formatToLocal12Hour(prayer.data!['timings']['Fajr']),
            ),
            _buildTimeRow(
              'Dhuhr',
              formatToLocal12Hour(prayer.data!['timings']['Dhuhr']),
            ),
            _buildTimeRow(
              'Asr',
              formatToLocal12Hour(prayer.data!['timings']['Asr']),
            ),
            _buildTimeRow(
              'Maghrib',
              formatToLocal12Hour(prayer.data!['timings']['Maghrib']),
            ),
            _buildTimeRow(
              'Isha',
              formatToLocal12Hour(prayer.data!['timings']['Isha']),
            ),
          ],
        ),
      ),
    );
  }
}
