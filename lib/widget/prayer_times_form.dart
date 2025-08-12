import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';
import 'package:ramadhan_pal/widget/main_button.dart';
import 'package:sizer/sizer.dart';

class PrayerTimesForm extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController countryController;

  const PrayerTimesForm({
    super.key,
    required this.cityController,
    required this.countryController,
  });

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.green[700]),
      labelText: label,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 14.sp,
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
    final prayer = Provider.of<PrayerProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),

        TextField(
          controller: cityController,
          decoration: _inputDecoration(
            'City (e.g., Kuala Lumpur)',
            Icons.location_city_outlined,
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: countryController,
          decoration: _inputDecoration(
            'Country (e.g., Malaysia)',
            Icons.flag_outlined,
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: MainButton(
            text: 'Get Times',
            isLoading: prayer.isLoading,
            onPressed: () {
              final city = cityController.text.trim();
              final country = countryController.text.trim();
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
      ],
    );
  }
}
