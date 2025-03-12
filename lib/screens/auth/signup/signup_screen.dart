import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback show;
  const SignUpScreen({super.key, required this.show});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  final email = TextEditingController(text: 'admin@gmail.com');
  final password = TextEditingController(text: '12345678');
  final name = TextEditingController(text: 'admin');
  FocusNode _focusNode3 = FocusNode();
  final Confirmpassword = TextEditingController(text: '12345678');
  bool visibil = true;
  @override
  void initState() {
    super.initState();
    // _focusNode1.addListener(() {
    //   setState(() {});
    // });
    // _focusNode2.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              logo(),
              textfild(),
              SizedBox(height: 15.h),
              textfild1(),
              SizedBox(height: 15.w),
              textfild2(),
              SizedBox(height: 15.w),
              textfild3(),
              SizedBox(height: 20.h),
              signupButton(),
              SizedBox(height: 15.h),
              or(),
              SizedBox(height: 15.h),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WithGoogle(),
                SizedBox(width: 20.w),
                WithApple(),
              ],
            ),
            SizedBox(height: 15.h),
              have(),
            ],
          ),
        ),
      ),

    );
  }

  Row or() {
    return Row(
      children: [
        Expanded(
            child: Divider(
              thickness: 1.5.w,
              endIndent: 4,
              indent: 20,
            )),
        Text(
          "Or continue with",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Expanded(
            child: Divider(
              thickness: 1.5.w,
              endIndent: 20,
              indent: 4,
            ))
      ],
    );
  }

  Padding signupButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Padding WithGoogle() {
  return socialLoginButton('images/google.png');
}

Padding WithApple() {
  return socialLoginButton('', icon: Icons.apple);
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
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey, width: 1.w),
      ),
      child: imagePath.isNotEmpty
          ? Image.asset(imagePath, height: 30.h)
          : Icon(icon, color: Colors.black, size: 30.sp),
    ),
  );
}

  Padding have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?  ",
            style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(show: widget.show)),
              );
            },            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding textfild() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: email,
          focusNode: _focusNode1,
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(
              Icons.email,
              color: _focusNode1.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding textfild1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: name,
          focusNode: _focusNode4,
          decoration: InputDecoration(
            hintText: 'Name',
            prefixIcon: Icon(
              Icons.email,
              color: _focusNode4.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding textfild2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: password,
          focusNode: _focusNode2,
          obscureText: visibil,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visibil = !visibil;
                  });
                },
                child: Icon(
                  visibil ? Icons.visibility_off : Icons.visibility,
                  color: _focusNode2.hasFocus ? Colors.black : Colors.grey[600],
                )),
            hintText: 'Password',
            prefixIcon: Icon(
              Icons.key,
              color: _focusNode2.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xffc5c5c5),
                width: 2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding textfild3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: Confirmpassword,
          focusNode: _focusNode3,
          obscureText: visibil,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            hintText: 'Confirmpassword',
            prefixIcon: Icon(
              Icons.key,
              color: _focusNode2.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: const Color(0xffc5c5c5),
                width: 2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
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

Future<void> _dialogBuilder(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
        ),
        content: Text(message, style: TextStyle(fontSize: 17.sp)),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}