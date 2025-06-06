import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/themes/colors.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool visibil = true;
  String? emailError, passwordError, confirmPasswordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateSignUp() async {
    setState(() {
      emailError = emailController.text.isEmpty
          ? "Please enter your email"
          : (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(emailController.text)
              ? "Invalid email format"
              : null);

      passwordError = passwordController.text.isEmpty
          ? "Please enter your password"
          : (passwordController.text.length < 8
          ? "Password must be at least 8 characters"
          : null);

      confirmPasswordError = confirmPasswordController.text.isEmpty
          ? "Please confirm your password"
          : (confirmPasswordController.text != passwordController.text
              ? "Passwords do not match"
              : null);
    });

    if (emailError == null &&
        passwordError == null &&
        confirmPasswordError == null ) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool isSuccess = await authProvider.signUp(emailController.text, passwordController.text);
      if (!context.mounted) return;
      print("isSuccess: $isSuccess");
      if (isSuccess) {
        showCustomDialog(
            context: context,
            title: "Success",
            message: "You have successfully signed up",
            onConfirm: () {
              context.go(AppRoutes.login);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              logo(),
              SizedBox(height: 20.h),
              inputField(emailController, "Email", Icons.email,
                  errorText: emailError),
              SizedBox(height: 20.h),
              inputField(passwordController, "Password", Icons.lock,
                  obscureText: visibil,
                  suffixIcon: true,
                  errorText: passwordError),
              SizedBox(height: 20.h),
              inputField(
                  confirmPasswordController, "Confirm Password", Icons.lock,
                  obscureText: visibil, errorText: confirmPasswordError),
              SizedBox(height: 20.h),
              signupButton(),
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
              SizedBox(height: 40.h),
              haveAccountText(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscureText = false,
    bool suffixIcon = false,
    String? errorText,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          errorText: errorText,
          suffixIcon: suffixIcon
              ? IconButton(
                  onPressed: () => setState(() => visibil = !visibil),
                  icon: Icon(visibil ? Icons.visibility_off : Icons.visibility),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
    );
  }

  Padding signupButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: TCustomButton(
        text: 'Sign Up',
        onPressed: validateSignUp,
        type: ButtonType.filled,
        customStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.primary),
          padding:
              WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16.h)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
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
        Text("Or continue with",
            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
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
          border: Border.all(color: Colors.grey, width: 1),
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
          Text("Already have an account?",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
          GestureDetector(
            onTap: () => context.go(AppRoutes.login),
            child: Text(" Login",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Padding logo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Image.asset('images/logo.png', width: 160.w, height: 160.h),
    );
  }
}
