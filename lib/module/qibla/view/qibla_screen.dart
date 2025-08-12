import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/qibla/controller/provider/qibla_provider.dart';
import 'package:sizer/sizer.dart';

class QiblaFinderScreen extends StatefulWidget {
  const QiblaFinderScreen({super.key});

  @override
  State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
}

class _QiblaFinderScreenState extends State<QiblaFinderScreen>
    with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QiblaProvider>().initializeQibla();
    });
  }

  @override
  void dispose() {
    _compassController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qibla Finder',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          Consumer<QiblaProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: provider.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.white),
                onPressed: provider.isLoading
                    ? null
                    : () => provider.recalibrate(),
              );
            },
          ),
        ],
      ),
      body: Consumer<QiblaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingView();
          }

          if (provider.error != null) {
            return _buildErrorView(provider.error!, provider);
          }

          return _buildQiblaView(provider);
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
          ),
          SizedBox(height: 2.h),
          Text(
            'Finding Qibla direction...',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Getting your location and compass data',
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error, QiblaProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 20.w, color: Colors.red[400]),
            SizedBox(height: 2.h),
            Text(
              'Unable to find Qibla',
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () => provider.recalibrate(),
              icon: const Icon(Icons.refresh),
              label: Text(
                'Try Again',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblaView(QiblaProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          _buildCompass(provider),
          SizedBox(height: 4.h),
          _buildDirectionInfo(provider),
        ],
      ),
    );
  }

  Widget _buildCompass(QiblaProvider provider) {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _compassController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -(provider.currentHeading ?? 0) * (math.pi / 180),
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white,
                        Colors.green[50]!,
                        Colors.green[100]!,
                      ],
                    ),
                    border: Border.all(color: Colors.green[300]!, width: 0.5.w),
                  ),
                  child: _buildCompassMarks(),
                ),
              );
            },
          ),

          if (provider.qiblaDirection != null)
            Transform.rotate(
              angle:
                  (provider.qiblaDirection! - (provider.currentHeading ?? 0)) *
                  (math.pi / 180),
              child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Qibla arrow
                    Positioned(
                      top: 5.w,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: provider.isPointingToQibla
                                ? 1.0 + (_pulseController.value * 0.2)
                                : 1.0,
                            child: Container(
                              width: 10.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                color: provider.isPointingToQibla
                                    ? Colors.green[600]
                                    : Colors.orange[600],
                                borderRadius: BorderRadius.circular(5.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: provider.isPointingToQibla
                                        ? Colors.green.withValues(alpha: 0.6)
                                        : Colors.orange.withValues(alpha: 0.6),
                                    blurRadius: provider.isPointingToQibla
                                        ? 15
                                        : 8,
                                    spreadRadius: provider.isPointingToQibla
                                        ? 3
                                        : 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 8.w,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Center dot
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: Colors.green[800],
              shape: BoxShape.circle,
            ),
          ),

          Positioned(
            top: 2.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Text(
                'N',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassMarks() {
    return Stack(
      children: List.generate(36, (index) {
        double angle = index * 10.0;
        bool isMajor = angle % 30 == 0;

        return Transform.rotate(
          angle: angle * (math.pi / 180),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 2.w),
              width: isMajor ? 0.8.w : 0.3.w,
              height: isMajor ? 5.w : 3.w,
              color: Colors.green[600],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDirectionInfo(QiblaProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  provider.isPointingToQibla
                      ? Icons.check_circle
                      : Icons.explore,
                  color: provider.isPointingToQibla
                      ? Colors.green[600]
                      : Colors.orange[600],
                  size: 8.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  provider.isPointingToQibla
                      ? 'Pointing to Qibla!'
                      : 'Find Qibla Direction',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: provider.isPointingToQibla
                        ? Colors.green[600]
                        : Colors.orange[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
