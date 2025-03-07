import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/text_filed.dart';
import '../../home/home_screen.dart';
import '../forgot_password/forgot_password.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen({super.key, required this.show});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  final email = TextEditingController();
  final password = TextEditingController();
  bool visibil = true;

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  void validateLogin() {
    if (emailError == null && passwordError == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        emailError = email.text.isEmpty
            ? "Please enter your email"
            : (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(email.text)
            ? "Invalid email format"
            : null);

        passwordError = password.text.isEmpty ? "Please enter your password" : null;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 70.h),
            logo(),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: email,
              hintText: 'Email',
              icon: Icons.email,
              focusNode: _focusNode1,
              errorText: emailError,
            ),
            SizedBox(height: 15.w),
            CustomTextField(
              controller: password,
              hintText: 'Password',
              icon: Icons.lock,
              focusNode: _focusNode2,
              isPassword: true,
              obscureText: visibil,
              toggleVisibility: () {
                setState(() {
                  visibil = !visibil;
                });
              },
              errorText: passwordError,
            ),
            SizedBox(height: 20.h),
            forgotPassword(),
            SizedBox(height: 20.h),
            loginButton(),
            SizedBox(height: 20.h),
            orDivider(),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                socialLoginButton('images/google.png'),
                SizedBox(width: 20.w),
                socialLoginButton('', icon: Icons.apple),
              ],
            ),
            SizedBox(height: 30.h),
            haveAccountText(),
          ],
        ),
      ),
    );
  }

  Padding loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: validateLogin,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: Color(0xFF8884FA),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Login',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }



  Row orDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1.5.w, endIndent: 4, indent: 20)),
        Text("Or continue with", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Expanded(child: Divider(thickness: 1.5.w, endIndent: 20, indent: 4))
      ],
    );
  }

  Padding socialLoginButton(String imagePath, {IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        alignment: Alignment.center,
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey, width: 1), // Add border
        ),
        child: imagePath.isNotEmpty
            ? Image.asset(imagePath, height: 30.h)
            : Icon(icon, color: Colors.black, size: 30.sp),
      ),
    );
  }

  Padding haveAccountText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?  ",
              style: TextStyle(color: Colors.grey[700], fontSize: 14.sp)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen(show: widget.show)),
              );
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Padding forgotPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPassword(show: widget.show),
                ),
              );
            },
            child: Text(
              "Forgot Password?",
              // style: TextStyle(
              //   color: Colors.grey[700],
              //   fontSize: 16.sp,
              //   fontWeight: FontWeight.bold,
              // ),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding logo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Image.asset(
        'images/logo.png',
        width: 160.w,
        height: 160.h,
        fit: BoxFit.contain,
      ),
    );
  }
}
