import 'package:advancedmobile_chatai/data_app/model/jarvis/prompt_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/util/themes/colors.dart';
import '../prompt_library.dart';
import 'my_prompt.dart';

class PromptBottomSheet extends StatefulWidget {
  final PromptItemV2 prompt;

  const PromptBottomSheet({super.key, required this.prompt});

  @override
  State<PromptBottomSheet> createState() => _PromptBottomSheetState();
}

class _PromptBottomSheetState extends State<PromptBottomSheet> {
  late String? selectedLanguage;

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
    selectedLanguage = widget.prompt.language ?? 'Auto';
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
                            selectedTab: 'My Prompts', // Chọn tab này
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Other · Anonymous User",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Copied to clipboard')),
                          );
                        },
                        icon: const Icon(Icons.copy,
                            color: Colors.grey, size: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add to chat input
                        },
                        child: const Text("Add to chat input"),
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Save
                        },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 12),
                    controller:
                        TextEditingController(text: widget.prompt.content),
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
                  const SizedBox(height: 4), // khoảng cách giữa label và dropdown
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedLanguage,
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

                      fillColor: const Color(0xFFF4F5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _buildDropdownItems(),
                    selectedItemBuilder: (BuildContext context) {
                      return languageOptions
                          .expand<Widget>((group) => group['items'].map<Widget>((lang) {
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
                      // Handle send
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
}
