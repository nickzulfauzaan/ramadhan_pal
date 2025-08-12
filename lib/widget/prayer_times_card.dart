import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';
import 'package:ramadhan_pal/widget/error_widget.dart';
import 'package:ramadhan_pal/widget/prayer_times_form.dart';
import 'package:ramadhan_pal/widget/prayer_times_result.dart';
import 'package:sizer/sizer.dart';

class PrayerTimesCard extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController countryController;

  const PrayerTimesCard({
    super.key,
    required this.cityController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    final prayer = Provider.of<PrayerProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrayerTimesForm(
              cityController: cityController,
              countryController: countryController,
            ),

            if (prayer.data != null) ...[
              SizedBox(height: 2.h),
              const PrayerTimesResult(),
              SizedBox(height: 2.h),
            ],

            if (prayer.error != null) ...[PrayerErrorWidget()],
          ],
        ),
      ),
    );
  }
}
