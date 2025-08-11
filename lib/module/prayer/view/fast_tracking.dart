import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/prayer/controller/provider/prayer_provider.dart';

class FastingTrackerScreen extends StatefulWidget {
  const FastingTrackerScreen({super.key});

  @override
  State<FastingTrackerScreen> createState() => _FastingTrackerScreenState();
}

class _FastingTrackerScreenState extends State<FastingTrackerScreen> {
  bool fasted = false;

  @override
  Widget build(BuildContext context) {
    final prayer = Provider.of<PrayerProvider>(context);
    String hijri = 'Unknown';
    if (prayer.data != null && prayer.data!['date'] != null) {
      hijri =
          prayer.data!['date']['hijri']?['date'] ??
          prayer.data!['date']['readable'];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Fasting Tracker')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Hijri Date: $hijri', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            SwitchListTile(
              title: Text('I have fasted today'),
              value: fasted,
              onChanged: (v) {
                setState(() => fasted = v);
                final snack = v ? 'Marked as fasted' : 'Marked as not fasted';
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(snack)));
              },
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
