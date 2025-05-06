import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:advancedmobile_chatai/providers/prompt_input.dart';
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

  final List<Map<String, dynamic>> languageOptions = [
    {
      'group': 'Languages',
      'items': [
        {'label': 'Auto', 'native': 'Let AI choose the language'},
        {'label': 'English', 'native': 'English'},
        {'label': 'Mandarin Chinese', 'native': '中文 (普通话)'},
        {'label': 'Hindi', 'native': 'हिन्दी'},
        {'label': 'Spanish', 'native': 'Español'},
        {'label': 'French', 'native': 'Français'},
        {'label': 'Arabic (Standard)', 'native': 'العربية الفصحى'},
        {'label': 'Bengali', 'native': 'বাংলা'},
        {'label': 'Russian', 'native': 'Русский'},
        {'label': 'Portuguese', 'native': 'Português'},
        {'label': 'Indonesian', 'native': 'Bahasa Indonesia'},
        {'label': 'Urdu', 'native': 'اردو'},
        {'label': 'German', 'native': 'Deutsch'},
        {'label': 'Japanese', 'native': '日本語'},
        {'label': 'Swahili', 'native': 'Kiswahili'},
        {'label': 'Marathi', 'native': 'मराठी'},
        {'label': 'Telugu', 'native': 'తెలుగు'},
        {'label': 'Turkish', 'native': 'Türkçe'},
        {'label': 'Cantonese Chinese', 'native': '中文 (粤语)'},
        {'label': 'Tamil', 'native': 'தமிழ்'},
        {'label': 'Western Punjabi', 'native': 'پنجابی'},
        {'label': 'Wu Chinese', 'native': '吴语'},
        {'label': 'Korean', 'native': '한국어'},
        {'label': 'Vietnamese', 'native': 'Tiếng Việt'},
        {'label': 'Hausa', 'native': 'Harshen Hausa'},
        {'label': 'Javanese', 'native': 'Basa Jawa'},
        {'label': 'Egyptian Arabic', 'native': 'اللهجة المصرية'},
        {'label': 'Italian', 'native': 'Italiano'},
        {'label': 'Gujarati', 'native': 'ગુજરાતી'},
        {'label': 'Thai', 'native': 'ไทย'},
        {'label': 'Amharic', 'native': 'አማርኛ'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = 'Auto';
    _promptController = TextEditingController(text: widget.prompt.content);
  }

  @override
  void dispose() {
    _promptController.dispose();
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
                            selectedTab: 'Public Prompts', // Chọn tab này
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
              // Prompt TextField (read-only)
// Prompt TextField (editable)
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
                            ClipboardData(text: widget.prompt.content ?? ''),
                          );
                          showCustomSnackBar(context, 'Copied to clipboard');
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
                  TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: _promptController,

                    readOnly: false,
                    maxLines: 2, // Giới hạn hiển thị 2 dòng
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF4F5F7), // Màu nền xám nhạt
                      border: InputBorder.none, // Không có viền
                      hintText: 'Enter prompt content here...',
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onChanged: (newText) {
                      // Cập nhật nếu cần
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Dropdown Language
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Output Language",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height: 4), // khoảng cách giữa label và dropdown
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedLanguage,
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      fillColor: const Color(0xFFF4F5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _buildDropdownItems(),
                    selectedItemBuilder: (BuildContext context) {
                      return languageOptions
                          .expand<Widget>(
                              (group) => group['items'].map<Widget>((lang) {
                                    return Text(lang['label'],
                                        style: const TextStyle(fontSize: 12));
                                  }))
                          .toList();
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value;
                      });
                    },
                    menuMaxHeight: 200,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Send button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary, // Sửa từ backgroundColor → color
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

                      if (selectedLanguage != null &&
                          selectedLanguage != 'Auto') {
                        finalPrompt += '\n\nResponse in $selectedLanguage';
                      }

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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    final List<DropdownMenuItem<String>> items = [];

    for (var group in languageOptions) {
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(
            group['group'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );

      for (var lang in group['items']) {
        items.add(
          DropdownMenuItem<String>(
            value: lang['label'],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang['label'], style: const TextStyle(fontSize: 12)),
                Text(
                  lang['native'],
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }
    }

    return items;
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
