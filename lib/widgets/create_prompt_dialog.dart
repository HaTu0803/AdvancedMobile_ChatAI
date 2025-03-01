import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePromptDialog extends StatefulWidget {
  const CreatePromptDialog({Key? key}) : super(key: key);

  @override
  State<CreatePromptDialog> createState() => _CreatePromptDialogState();
}

class _CreatePromptDialogState extends State<CreatePromptDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 340.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Prompt',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Warning message
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, 
                       color: Colors.amber.shade700, 
                       size: 20.w),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.amber.shade900,
                        ),
                        children: [
                          const TextSpan(text: 'You should '),
                          TextSpan(
                            text: 'login to Jarvis',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(
                            text: ' to save your prompt. Otherwise, it will be lost.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  RichText(
                    text: TextSpan(
                      text: 'Name ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name of the prompt',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  
                  // Prompt field
                  RichText(
                    text: TextSpan(
                      text: 'Prompt ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  
                  // Info box
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                             color: Colors.blue.shade700,
                             size: 20.w),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Use square brackets [ ] to specify user input.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  TextFormField(
                    controller: _promptController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a prompt';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Create button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle prompt creation
                      Navigator.pop(context, {
                        'name': _nameController.text,
                        'prompt': _promptController.text,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}