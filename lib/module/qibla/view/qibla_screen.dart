import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  double begin = 0.0;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await getPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController);
  }

  Future<void> getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        setState(() => hasPermission = true);
      } else {
        var value = await Permission.location.request();
        setState(() {
          hasPermission = (value == PermissionStatus.granted);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.green[700],
        title: Row(
          children: [
            const Icon(Icons.explore, size: 28, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Qibla Direction',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: hasPermission
              ? StreamBuilder(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'Unable to get Qibla direction.',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final qiblahDirection = snapshot.data!;
                    animation = Tween(
                      begin: begin,
                      end: (qiblahDirection.qiblah * (pi / 180) * -1),
                    ).animate(_animationController);
                    begin = (qiblahDirection.qiblah * (pi / 180) * -1);
                    _animationController.forward(from: 0);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (qiblahDirection.direction.toInt() == 291 ||
                                qiblahDirection.direction.toInt() == 292 ||
                                qiblahDirection.direction.toInt() == 293)
                            ? Text(
                                "You're facing the Qibla",
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green[800],
                                ),
                              )
                            : Text(
                                "${qiblahDirection.direction.toInt()}°",
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green[800],
                                ),
                              ),
                        SizedBox(height: 3.h),
                        SizedBox(
                          height: 40.h,
                          child: AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) => Transform.rotate(
                              angle: animation.value,
                              child: Image.asset('assets/images/qibla.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Location permission is required to find Qibla direction.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
