import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'password_changed.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFormValid = false;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = "Password is required";
      } else if (_passwordController.text.length < 8) {
        _passwordError = "Password must be at least 8 characters";
      } else {
        _passwordError = null;
      }

      // Validate confirm password
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = "Please confirm your password";
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = "Passwords do not match";
      } else {
        _confirmPasswordError = null;
      }

      // Check if form is valid
      _isFormValid = _passwordError == null && 
                     _confirmPasswordError == null && 
                     _passwordController.text.isNotEmpty &&
                     _confirmPasswordController.text.isNotEmpty;
    });
  }

  void _resetPassword() {
    if (_isFormValid) {
      // Here you would typically call your API to reset the password
      // For now, we'll just navigate to the success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PasswordChanged(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),

                // Title
                Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  "Create a new password for ${widget.email}",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),

                SizedBox(height: 32.h),

                // Password field
                Text(
                  "New Password",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Enter new password",
                    errorText: _passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Confirm password field
                Text(
                  "Confirm Password",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Confirm your password",
                    errorText: _confirmPasswordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Reset Password button
                GestureDetector(
                  onTap: _isFormValid ? _resetPassword : null,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _isFormValid ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}