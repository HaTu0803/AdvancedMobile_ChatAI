import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordChanged extends StatefulWidget {
  const PasswordChanged({super.key});

  @override
  State<PasswordChanged> createState() => _PasswordChangedState();
}

class _PasswordChangedState extends State<PasswordChanged> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Define the custom purple color
  final Color customPurple = const Color.fromARGB(255, 136, 132, 250);

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Scale animation for the check icon
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Opacity animation for the stars/sparkles
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated success icon
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer circles
                        Opacity(
                          opacity: _opacityAnimation.value,
                          child: Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: customPurple.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _opacityAnimation.value,
                          child: Container(
                            width: 90.w,
                            height: 90.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: customPurple.withOpacity(0.2),
                            ),
                          ),
                        ),

                        // Main circle with check icon
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: customPurple,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 36.sp,
                            ),
                          ),
                        ),

                        // Sparkles/stars
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: Icon(Icons.star, color: customPurple, size: 16.sp),
                          ),
                        ),
                        Positioned(
                          top: 40.h,
                          left: 10.w,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: Icon(Icons.star, color: customPurple, size: 16.sp),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          right: 20.w,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: Icon(Icons.star, color: customPurple, size: 16.sp),
                          ),
                        ),
                        Positioned(
                          bottom: 10.h,
                          left: 30.w,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: Icon(Icons.star, color: customPurple, size: 16.sp),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 40.h),

                // Success text
                Text(
                  "Password changed",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 16.h),

                // Success message
                Text(
                  "Your password has been changed successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 60.h),

                // Back to login button
                GestureDetector(
                  onTap: () {
                    // Navigate back to login screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: customPurple,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Back to login",
                      style: TextStyle(
                        color: Colors.white,
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
      ),
    );
  }
}