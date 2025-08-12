import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/auth/controller/provider/auth_provider.dart';
import 'package:ramadhan_pal/widget/main_button.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();

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
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Icon(
                Icons.nightlight_outlined,
                size: 72,
                color: Colors.green[700],
              ),
              SizedBox(height: 1.h),
              Text(
                'RamadhanPal',
                style: GoogleFonts.montserrat(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              Text(
                'Your Ramadan companion',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: _userEmail,
                decoration: _inputDecoration('Email', Icons.email_outlined),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _userPassword,
                decoration: _inputDecoration('Password', Icons.lock_outline),
                obscureText: true,
              ),
              SizedBox(height: 4.h),
              MainButton(
                text: 'Login',
                onPressed: () async {
                  await auth.login(
                    _userEmail.text.trim(),
                    _userPassword.text,
                    context,
                  );
                },
                isLoading: context.watch<AuthProvider>().isAuthLoading,
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: () => context.push('/register'),
                child: Text(
                  "Don't have an account? Register",
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
