import 'package:flutter/material.dart';

const List<Map<String, String>> languageOptions = [
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
];

class LanguageSelector extends StatelessWidget {
  final String? selectedLanguage;
  final ValueChanged<String?> onLanguageChanged;

  const LanguageSelector({
    Key? key,
    this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Language",
          style:Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),

        // 👇 Bọc DropdownButtonFormField bằng Container để giới hạn chiều cao
        Container(
          height: 40, // Giới hạn chiều cao, bạn có thể tùy chỉnh
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedLanguage,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            items: languageOptions.map((lang) {
              return DropdownMenuItem<String>(
                value: lang['label'],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang['label'] ?? '', style: const TextStyle(fontSize: 12)),
                    Text(
                      lang['native'] ?? '',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }).toList(),
            selectedItemBuilder: (BuildContext context) {
              return languageOptions.map<Widget>((lang) {
                return Text(
                  lang['label'] ?? '',
                  style: const TextStyle(fontSize: 12),
                );
              }).toList();
            },
            onChanged: onLanguageChanged,
            menuMaxHeight: 200,
          ),
        ),
      ],
    );
  }
}
