import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'forgot_password.dart'; // Import màn hình ForgotPassword
import 'reset_password.dart';
class VerifyOTP extends StatefulWidget {
  final String email;

  const VerifyOTP({super.key, required this.email});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  late TextEditingController otpController;
  bool isOtpFilled = false;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ForgotPassword(show: () {})),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: Image.asset(
                      'images/pincode.png',
                      width: 150.w,  // Điều chỉnh kích thước hình ảnh
                      height: 150.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),


                SizedBox(height: 20.h),

                // Tiêu đề
                Text(
                  "Enter Verification Code",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Hiển thị email
                Text(
                  "We have sent a code to\n${widget.email}",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32.h),

                // Nhập OTP
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12.r),
                    fieldHeight: 58.h,
                    fieldWidth: 50.w,
                    inactiveColor: Colors.grey.shade400,
                    activeColor: Color.fromARGB(255, 136, 132, 250),
                    selectedColor: Colors.blueAccent,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isOtpFilled = value.length == 4;
                    });
                  },
                ),

                SizedBox(height: 32.h),

                // Verify Button
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
                      color: isOtpFilled ? Color.fromARGB(255, 136, 132, 250) : Colors.grey.shade300,
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

                TextButton(
                  onPressed: () => print("Resend Code"),
                  child: Text(
                    "Resend Code",
                    style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
