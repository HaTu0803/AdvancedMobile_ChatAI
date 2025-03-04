import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './reset_password.dart';
class VerifyOTP extends StatefulWidget {
  final String email;

  const VerifyOTP({super.key, required this.email});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpController = TextEditingController();
  bool isOtpFilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),

              // Tiêu đề
              Text(
                "Please check your email",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8.h),

              // Hiển thị email người dùng nhập
              Text(
                "We’ve sent a code to ${widget.email}",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),

              SizedBox(height: 32.h),

              // Input OTP
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: otpController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8.r),
                  fieldHeight: 50.h,
                  fieldWidth: 50.w,
                  inactiveColor: Colors.black,
                  activeColor: Colors.blue,
                  selectedColor: Colors.blue,
                ),
                onChanged: (value) {
                  setState(() {
                    isOtpFilled = value.length == 4;
                  });
                },
              ),

              SizedBox(height: 32.h),

              // Nút Verify
              GestureDetector(
  onTap: isOtpFilled
      ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(email: widget.email),
            ),
          );
        }
      : null,
  child: Container(
    width: double.infinity,
    height: 50.h,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isOtpFilled ? Colors.blue : Colors.grey.shade300,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Text(
      "Verify",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),


              SizedBox(height: 16.h),

              // Nút Send Again
              GestureDetector(
                onTap: () => print("Resend Code"),
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Send Again",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
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
