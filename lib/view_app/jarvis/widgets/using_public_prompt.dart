import 'package:advancedmobile_chatai/data_app/datasource/language_option.dart';
import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/providers/prompt_input.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/widgets/language_option_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/util/themes/colors.dart';
import '../screens/prompt_library/prompt_library.dart';

class UsingPublicPrompt extends StatefulWidget {
  final Prompt prompt;

  const UsingPublicPrompt({super.key, required this.prompt});

  @override
  State<UsingPublicPrompt> createState() => _UsingPublicPromptState();
}

class _UsingPublicPromptState extends State<UsingPublicPrompt> {
  late String? selectedLanguage;
  late TextEditingController _promptController;
  bool isSaving = false;
  final Map<String, TextEditingController> _inputControllers = {};
  bool _isPromptVisible = false;

  @override
  void initState() {
    super.initState();
    selectedLanguage = 'Auto';
    _promptController = TextEditingController(text: widget.prompt.content);
    _initializeInputFields();
  }

  void _initializeInputFields() {
    final RegExp regex = RegExp(r'\[(.*?)\]');
    final matches = regex.allMatches(widget.prompt.content);

    for (final match in matches) {
      final placeholder = match.group(1);
      if (placeholder != null && placeholder.isNotEmpty) {
        _inputControllers[placeholder] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    for (final controller in _inputControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PromptLibraryScreen(
                            selectedTab: 'Public Prompts',
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.prompt.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${widget.prompt.category} · ${widget.prompt.userName}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ),

              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.prompt.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),

              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isPromptVisible)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isPromptVisible = true;
                        });
                      },
                      child: const Text("View Prompt"),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                    ),
                  if (_isPromptVisible)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Prompt',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text: widget.prompt.content ?? ''),
                                );
                                showCustomSnackBar(
                                    context, 'Copied to clipboard');
                              },
                              icon: const Icon(Icons.copy,
                                  color: Colors.grey, size: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<PromptInputProvider>(context,
                                        listen: false)
                                    .setInputContent(widget.prompt.content);
                                print(
                                    'PromptInputProvider: setContent: ${widget.prompt.content}');
                                Navigator.pop(context);
                              },
                              child: const Text("Add to chat input"),
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          style: const TextStyle(fontSize: 12),
                          controller: _promptController,
                          readOnly: false,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF4F5F7),
                            border: InputBorder.none,
                            hintText: 'Enter prompt content here...',
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Dropdown Language
              LanguageSelector(
                selectedLanguage: selectedLanguage,
                onLanguageChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue;
                  });
                },
              ),
              const SizedBox(height: 8),
              ..._inputControllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextFormField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      hintText: entry.key,
                      filled: true,
                      fillColor: const Color(0xFFF4F5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Send button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      final provider = Provider.of<PromptInputProvider>(context,
                          listen: false);

                      String finalPrompt = _promptController.text.trim();

                      _inputControllers.forEach((key, controller) {
                        if (controller.text.isNotEmpty) {
                          finalPrompt =
                              finalPrompt.replaceAll('[$key]', controller.text);
                        }
                      });

                      if (selectedLanguage != null &&
                          selectedLanguage != 'Auto') {
                        finalPrompt += '\n\nResponse in $selectedLanguage';
                      }

                      // Send the final prompt
                      provider.sendPrompt(finalPrompt);

                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Send',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.subdirectory_arrow_left_rounded,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  void showCustomSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 4,
        left: 10,
        right: 10,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black,
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }
}
