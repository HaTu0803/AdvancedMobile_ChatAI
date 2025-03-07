import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final FocusNode focusNode;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.focusNode,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(
                icon,
                color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
              ),
              suffixIcon: isPassword
                  ? GestureDetector(
                onTap: toggleVisibility,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
                ),
              )
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: errorText != null ? Colors.red : Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10.r),
              ),
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}
