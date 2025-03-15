import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'verify_otp.dart';

class ForgotPassword extends StatefulWidget {
  final VoidCallback show;
  const ForgotPassword({super.key, required this.show});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    setState(() {
      isButtonEnabled = EmailValidator.validate(emailController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  child: Center(
                    child: Image.asset(
                      'images/forgot.png',
                      width: 150.w,
                      height: 150.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                "Forgot password?",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Don't worry! It happens. Please enter the email associated with your account",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                ),
              ),
              SizedBox(height: 24.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 45.h,  // Reduced height
                child: GestureDetector(
                  onTap: isButtonEnabled
                      ? () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VerifyOTP(email: emailController.text),
                    ));
                  }
                      : null,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isButtonEnabled
                          ? const Color.fromARGB(255, 136, 132, 250)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: isButtonEnabled
                          ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ]
                          : [],
                    ),
                    child: Text(
                      'Send Code',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isButtonEnabled ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  ),
                )

              ),
            ],
          ),
        ),
      ),
    );
  }
}