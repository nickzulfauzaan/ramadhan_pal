import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramadhan_pal/module/auth/controller/provider/auth_provider.dart';
import 'package:ramadhan_pal/widget/main_button.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userName = TextEditingController();
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Icon(
                Icons.person_pin_circle_outlined,
                size: 72,
                color: Colors.green[700],
              ),
              SizedBox(height: 1.h),
              Text(
                'Create Account',
                style: GoogleFonts.montserrat(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              Text(
                'Join RamadhanPal and start your journey',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: _userName,
                decoration: _inputDecoration('Name', Icons.person_outline),
              ),
              SizedBox(height: 2.h),
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
                text: 'Register',
                onPressed: () async {
                  await auth.register(
                    _userName.text.trim(),
                    _userEmail.text.trim(),
                    _userPassword.text,
                    context,
                  );
                },
                isLoading: context.watch<AuthProvider>().isAuthLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
