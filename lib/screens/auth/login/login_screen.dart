import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../util/themes/colors.dart';
import '../../../widgets/button.dart';
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
    setState(() {
      emailError = email.text.isEmpty
          ? "Please enter your email"
          : (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email.text)
          ? "Invalid email format"
          : null);

      passwordError = password.text.isEmpty ? "Please enter your password" : null;
    });

    // If no errors, navigate to the home screen
    if (emailError == null && passwordError == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            logo(),
            SizedBox(height: 70.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  errorText: emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                focusNode: _focusNode1,
              ),
            ),
            SizedBox(height: 15.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextFormField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  errorText: passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      visibil ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        visibil = !visibil;
                      });
                    },
                  ),
                ),
                obscureText: visibil,
                focusNode: _focusNode2,
              ),
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
            SizedBox(height: 20.h),
          ],
        ),
      ),
    ),
  );
}


  Padding loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: TCustomButton(
        text: 'Login',
        onPressed: validateLogin,
        type: ButtonType.filled,
        customStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.primary),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16.h)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          )),
          minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.h)),
          alignment: Alignment.center,
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
                color: Color.fromARGB(255, 136, 132, 250),
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
