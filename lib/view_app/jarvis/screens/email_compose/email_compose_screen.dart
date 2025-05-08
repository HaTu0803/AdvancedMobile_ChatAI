import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:advancedmobile_chatai/core/util/themes/colors.dart';

class EmailComposeScreen extends StatefulWidget {
  const EmailComposeScreen({super.key});

  @override
  State<EmailComposeScreen> createState() => _EmailComposeScreenState();
}

class _EmailComposeScreenState extends State<EmailComposeScreen> {
  bool _isIdeasExpanded = false;
  final TextEditingController _replyController = TextEditingController();
  final List<String> _replyIdeas = [
    "Thank you for your email. I appreciate your message.",
    "I'll get back to you as soon as possible.",
    "Let's schedule a meeting to discuss this further.",
    "I'm happy to help with your request.",
  ];

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Email'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Part 1: Received Email Content
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmailHeader(
                      sender: "John Doe",
                      email: "john.doe@example.com",
                      subject: "Meeting Request",
                      date: "Mar 15, 2024",
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Dear Team,\n\nI hope this email finds you well. I would like to schedule a meeting to discuss our upcoming project. Please let me know your availability for next week.\n\nBest regards,\nJohn",
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Part 2: Reply Section
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Reply Header
                  Row(
                    children: [
                      Text(
                        "Reply to: John Doe <john.doe@example.com>",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Reply Text Field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: TextField(
                        controller: _replyController,
                        maxLines: null,
                        expands: true,
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: "Type your reply here...",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  ),

                  // Action Buttons
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      // Draft with Jarvis Unified Button
                      Expanded(
                        flex: 6,
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement draft functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, size: 22, color: Colors.white),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Text(
                                    "Draft with Jarvis",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  _isIdeasExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Send Button
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement send functionality
                            },
                            icon: const Icon(Icons.send, size: 22),
                            label: const Text("Send"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 12.h,
                              ),
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Ideas Dropdown
                  if (_isIdeasExpanded)
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _replyIdeas.map((idea) {
                          return InkWell(
                            onTap: () {
                              _replyController.text = idea;
                              setState(() {
                                _isIdeasExpanded = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 8.w,
                              ),
                              child: Text(
                                idea,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailHeader({
    required String sender,
    required String email,
    required String subject,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                sender[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          subject,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
