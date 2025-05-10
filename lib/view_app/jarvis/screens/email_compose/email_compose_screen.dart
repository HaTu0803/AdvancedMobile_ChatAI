import 'package:advancedmobile_chatai/view_app/knowledge_base/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data_app/model/jarvis/ai_email_model.dart';
import '../../../../data_app/repository/jarvis/ai_email_repository.dart';

class EmailComposeScreen extends StatefulWidget {
  const EmailComposeScreen({super.key});

  @override
  State<EmailComposeScreen> createState() => _EmailComposeScreenState();
}

class _EmailComposeScreenState extends State<EmailComposeScreen> {
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _receiverEmailController =
      TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _emailBodyController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  // final List<String> _replyIdeas = [
  //   "Thank you for your email. I appreciate your message.",
  //   "I'll get back to you as soon as possible.",
  //   "Let's schedule a meeting to discuss this further.",
  //   "I'm happy to help with your request.",
  // ];
  String? _chosenIdea;
  @override
  void dispose() {
    _senderNameController.dispose();
    _actionController.dispose();
    _receiverEmailController.dispose();
    _subjectController.dispose();
    _emailBodyController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
                  'Compose Email',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              label: "From",
              controller: _senderNameController,
              hintText: "Enter your email address",
              isRequired: true,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
               
                return null;
              },
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: "To",
              controller: _receiverEmailController,
              hintText: "Enter recipient's email address",
              isRequired: true,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter recipient\'s email address';
                }
               
                return null;
              },
            ),
            CustomTextFormField(
              label: "Subject",
              controller: _subjectController,
              hintText: "Enter email subject",
              isRequired: true,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email subject';
                }
                return null;
              },
            ),
            CustomTextFormField(
              label: "Language",
              controller: _languageController,
              hintText: "Enter language",
              isRequired: true,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter language';
                }
                return null;
              },
            ),
            CustomTextFormField(
              label: "Action",
              controller: _actionController,
              hintText: "Enter action",
              isRequired: true,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter action';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: "Email Body",
              controller: _emailBodyController,
              hintText: "Type your email content here...",
              isRequired: true,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email body';
                }
                return null;
              },
            ),

            // if (_isIdeasExpanded)
            //   Container(
            //     margin: EdgeInsets.only(top: 8.h),
            //     padding: EdgeInsets.all(8.w),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[100],
            //       borderRadius: BorderRadius.circular(8.r),
            //       border: Border.all(color: Colors.grey[300]!),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: _replyIdeas.map((idea) {
            //         return InkWell(
            //           onTap: () {
            //             _emailBodyController.text = idea;
            //             setState(() {
            //               _isIdeasExpanded = false;
            //             });
            //           },
            //           child: Padding(
            //             padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            //             child: Text(
            //               idea,
            //               style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
            //             ),
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //   ),

            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _openSuggestIdeas(context);
                    },
                    icon: Icon(Icons.settings_suggest),
                    label: Text("Suggest"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: FilledButton(
                    onPressed: () {

                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text("Draft"),
                        SizedBox(width: 8.w),
                        const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
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

  void _openSuggestIdeas(BuildContext context) async {
    final ideas = await _getSuggestedReplyIdeas(context);

    if (!context.mounted || ideas.isEmpty) return;

    int selectedIdeaIndex = -1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Close
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Suggest Ideas',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // List of ideas
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ideas.length,
                          itemBuilder: (_, index) {
                            final idea = ideas[index];
                            final isSelected = index == selectedIdeaIndex;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
                                ),
                                elevation: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIdeaIndex = index;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListTile(
                                    title: Text(
                                      idea,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle, color: Colors.blue)
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // Confirm button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: selectedIdeaIndex != -1
                                ? () {
                              // Lưu ý tưởng được chọn vào biến để dùng sau
                              _chosenIdea = ideas[selectedIdeaIndex];

                              // Không gán vào emailBodyController ở đây

                              // Đóng dialog
                              Navigator.of(context).pop();
                            }
                                : null,
                            icon: const Icon(Icons.done),
                            label: const Text("Use This Idea"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      ],
                  ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<List<String>> _getSuggestedReplyIdeas(BuildContext context) async {
    final emailBody = _emailBodyController.text.trim();
    final sender = _senderNameController.text.trim();
    final receiver = _receiverEmailController.text.trim();
    final subject = _subjectController.text.trim();
    final action = _actionController.text.trim();
    final language = _languageController.text.trim();

    final request = SuggestReplyIdeas(
      action: action,
      email: emailBody,
      metadata: MetadataSuggest(
        context: [],
        subject: subject,
        sender: sender,
        receiver: receiver,
        language: language,
      ),
    );
    if (context.mounted) {
      print("Request: $request");
    }
    try {
      final response = await EmailRepository().suggestReplyIdeas(request);
      return response.ideas;
    } catch (e) {
      if (context.mounted) {
        print("Error fetching suggested replies: $e");
      }
      return [];
    }
  }
}
