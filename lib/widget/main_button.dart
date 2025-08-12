import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MainButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool isLoading;
  const MainButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 6.h,
        width: double.maxFinite,
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.green[700]),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
            ),
          ),
          onPressed: isLoading ? () {} : onPressed,
          child: (isLoading)
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    strokeCap: StrokeCap.round,
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  textScaler: TextScaler.noScaling,
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
