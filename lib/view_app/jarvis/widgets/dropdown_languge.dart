import 'package:flutter/material.dart';

class PromptBottomSheet extends StatefulWidget {
  const PromptBottomSheet({super.key});

  @override
  State<PromptBottomSheet> createState() => _PromptBottomSheetState();
}

class _PromptBottomSheetState extends State<PromptBottomSheet> {
  String? selectedLanguage = 'Auto';

  final List<Map<String, dynamic>> languageOptions = [
    {
      'group': 'Languages',
      'items': [
        {'label': 'Auto', 'native': 'Let AI choose the language'},
        {'label': 'English', 'native': 'English'}, // 1
        {'label': 'Mandarin Chinese', 'native': '中文 (普通话)'}, // 2
        {'label': 'Hindi', 'native': 'हिन्दी'}, // 3
        {'label': 'Spanish', 'native': 'Español'}, // 4
        {'label': 'French', 'native': 'Français'}, // 5
        {'label': 'Arabic (Standard)', 'native': 'العربية الفصحى'}, // 6
        {'label': 'Bengali', 'native': 'বাংলা'}, // 7
        {'label': 'Russian', 'native': 'Русский'}, // 8
        {'label': 'Portuguese', 'native': 'Português'}, // 9
        {'label': 'Indonesian', 'native': 'Bahasa Indonesia'}, // 10
        {'label': 'Urdu', 'native': 'اردو'}, // 11
        {'label': 'German', 'native': 'Deutsch'}, // 12
        {'label': 'Japanese', 'native': '日本語'}, // 13
        {'label': 'Swahili', 'native': 'Kiswahili'}, // 14
        {'label': 'Marathi', 'native': 'मराठी'}, // 15
        {'label': 'Telugu', 'native': 'తెలుగు'}, // 16
        {'label': 'Turkish', 'native': 'Türkçe'}, // 17
        {'label': 'Cantonese Chinese', 'native': '中文 (粤语)'}, // 18
        {'label': 'Tamil', 'native': 'தமிழ்'}, // 19
        {'label': 'Western Punjabi', 'native': 'پنجابی'}, // 20
        {'label': 'Wu Chinese', 'native': '吴语'}, // 21
        {'label': 'Korean', 'native': '한국어'}, // 22
        {'label': 'Vietnamese', 'native': 'Tiếng Việt'}, // 23
        {'label': 'Hausa', 'native': 'Harshen Hausa'}, // 24
        {'label': 'Javanese', 'native': 'Basa Jawa'}, // 25
        {'label': 'Egyptian Arabic', 'native': 'اللهجة المصرية'}, // 26
        {'label': 'Italian', 'native': 'Italiano'}, // 27
        {'label': 'Gujarati', 'native': 'ગુજરાતી'}, // 28
        {'label': 'Thai', 'native': 'ไทย'}, // 29
        {'label': 'Amharic', 'native': 'አማርኛ'}, // 30
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'Prompt',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedLanguage,
            decoration: const InputDecoration(
              labelText: "Output Language",
              border: OutlineInputBorder(),
            ),
            items: _buildDropdownItems(),
            onChanged: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle submit
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Send'),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    final List<DropdownMenuItem<String>> items = [];

    for (var group in languageOptions) {
      // Add group header (disabled item)
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              group['group'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

      // Add actual language items
      for (var lang in group['items']) {
        items.add(
          DropdownMenuItem<String>(
            value: lang['label'],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang['label'], style: const TextStyle(fontSize: 16)),
                Text(
                  lang['native'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
