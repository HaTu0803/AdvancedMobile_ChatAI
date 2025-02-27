import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

import '../home/home_screen.dart';

class ForgotPassword extends StatefulWidget {
  final VoidCallback show;
  const ForgotPassword({super.key, required this.show});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade200, 
    appBar: AppBar(
      backgroundColor: Colors.grey.shade200,
      elevation: 0,
      title: const Text('', style: TextStyle(color: Colors.black)), 
      iconTheme: const IconThemeData(color: Colors.black), 
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logo(),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Don’t worry! It happens. Please enter the email associated with your account",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          emailInputField(),
          SizedBox(height: 20.h),
          sendCodeButton(),
        ],
      ),
    ),
  );
}

  Widget emailInputField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Enter your email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
    );
  }

  Padding sendCodeButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () {
          if (isButtonEnabled) {
            if (!EmailValidator.validate(emailController.text)) {
              _dialogBuilder(context, "Error", "Please provide a valid email format.");
            } else {
              _dialogBuilder(context, "Success", "Verification code sent!", isSuccess: true);
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: isButtonEnabled ? Colors.blue.shade700 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Send Code',
            style: TextStyle(
              color: isButtonEnabled ? Colors.white : Colors.grey.shade700,
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String title, String message, {bool isSuccess = false}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isSuccess) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              },
              child: Text("OK", style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        );
      },
    );
  }

  Padding logo() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 50.w),
    child: Center(
      child: Image.asset(
        'images/padlock.png',
        width: 160.w,
        height: 160.h,
        fit: BoxFit.contain,
      ),
    ),
  );
}

}
