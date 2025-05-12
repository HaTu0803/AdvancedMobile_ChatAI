import 'package:advancedmobile_chatai/view_app/jarvis/widgets/language_option_email.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // final TextEditingController _languageController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  late String? selectedLanguage;

  String? _chosenIdea;
  @override
  void dispose() {
    _senderNameController.dispose();
    _actionController.dispose();
    _receiverEmailController.dispose();
    _subjectController.dispose();
    _emailBodyController.dispose();
    // _languageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedLanguage = 'Vietnamese';
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
            // CustomTextFormField(
            //   label: "Language",
            //   controller: _languageController,
            //   hintText: "Enter language",
            //   isRequired: true,
            //   maxLines: 1,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter language';
            //     }
            //     return null;
            //   },
            // ),
            LanguageSelector(
              selectedLanguage: selectedLanguage,
              onLanguageChanged: (value) {
                setState(() {
                  selectedLanguage = value;
                });
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
                      handleEmailDraft(context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Draft", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                      ],
                    ),
                  )
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
                              // Save the selected idea and trigger the draft
                              _chosenIdea = ideas[selectedIdeaIndex];
                              handleEmailDraft(context);
                              // Automatically trigger the email draft after choosing an idea

                              Navigator.of(context).pop();
                              // _handleEmailDraft(context);

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

  void showEmailDraftDialog(BuildContext context, String emailContent) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            print("Dialog is opening");
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
                              'Draft Email with AI',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Email content
                        Text(emailContent,
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 16),

                        // Copy button
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: emailContent));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Email content copied to clipboard')),
                            );
                          },
                          child: const Text('Copy'),
                        ),
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
    final language = selectedLanguage ?? "Vietnamese";

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

  Future<String?> getEmailDraftResponse() async {
    final emailBody = _emailBodyController.text.trim();
    final sender = _senderNameController.text.trim();
    final receiver = _receiverEmailController.text.trim();
    final subject = _subjectController.text.trim();
    final language = selectedLanguage ?? "Vietnamese";

    final style = Style(
      length: 'long',
      formality: 'neutral',
      tone: 'friendly',
    );

    final emailRequest = EmailRequestModel(
      mainIdea: _chosenIdea ?? "",
      action: "Reply to this email",
      email: emailBody,
      metadata: MetadataRequest(
        subject: subject,
        sender: sender,
        style: style,
        receiver: receiver,
        language: language,
        context: [],
      ),
    );

    try {
      final response = await EmailRepository().responseEmail(emailRequest);
      return response.email;
    } catch (e) {
      print("Error fetching email response: $e");
      return null;
    }
  }
  Future<void> handleEmailDraft(BuildContext context) async {
    final result = await getEmailDraftResponse();

    if (!context.mounted) return;

    if (result != null && result.isNotEmpty) {
      showEmailDraftDialog(context, result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate email draft')),
      );
    }
  }

}
