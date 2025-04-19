import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:flutter/material.dart';

class AiModelDropdown extends StatefulWidget {
  const AiModelDropdown({super.key});

  @override
  State<AiModelDropdown> createState() => _AiModelDropdownState();
}

class _AiModelDropdownState extends State<AiModelDropdown> {
  AiModel? selectedModel;

  final List<AiModel> baseAiModels = [
    AiModel(
      id: 'gpt-4o-mini',
      name: 'GPT-4o mini',
      iconPath: 'images/icons/gpt4o-mini.svg',
    ),
    AiModel(
      id: 'gpt-4o',
      name: 'GPT-4o',
      iconPath: 'images/icons/gpt4o.png',
      isDefault: true,
    ),
    AiModel(
      id: 'gemini-1.5-flash-latest',
      name: 'Gemini 1.5 Flash',
      iconPath: 'images/icons/gemini-flash.svg',
    ),
    AiModel(
      id: 'gemini-1.5-pro-latest',
      name: 'Gemini 1.5 Pro',
      iconPath: 'images/icons/gemini-pro.svg',
    ),
    AiModel(
      id: 'claude-3-haiku-20240307',
      name: 'Claude 3 Haiku',
      iconPath: 'images/icons/claude-haiku.svg',
    ),
    AiModel(
      id: 'claude-3-sonnet-20240229',
      name: 'Claude 3.5 Sonnet',
      iconPath: 'images/icons/claude-sonnet.svg',
    ),
    AiModel(
      id: 'deepseek-chat',
      name: 'Deepseek Chat',
      iconPath: 'images/icons/deepseek.svg',
    ),
  ];

  final List<AiModel> bots = [
    AiModel(
      id: 'tu-test',
      name: 'Tú test',
      iconPath: 'images/icons/your_bots.svg',
    ),
    AiModel(
      id: 'default-bot',
      name: 'Default Bot',
      iconPath: 'images/icons/your_bots.svg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedModel = baseAiModels.firstWhere((model) => model.isDefault == true,
        orElse: () => baseAiModels.first);
  }

  void _showModelBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Prevent overflow
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader("Base AI Models"),
                  ...baseAiModels.map(_buildModelItem).toList(),
                  const Divider(),
                  _buildHeader("Your Bots"),
                  ...bots.map(_buildModelItem).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildModelItem(AiModel model) {
    return ListTile(
      onTap: () {
        setState(() => selectedModel = model);
        Navigator.of(context).pop(); // đóng bottom sheet
      },
      leading: Image.asset(
        model.iconPath ?? 'images/icons/your_bots.svg',
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 24),
      ),
      title: Text(model.name),
      trailing: model.id == selectedModel?.id
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showModelBottomSheet,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Theme.of(context)
              .colorScheme
              .primaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              selectedModel?.iconPath ?? 'images/icons/your_bots.svg',
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.smart_toy, color: Colors.purple),
            ),
            const SizedBox(width: 8),
            Text(selectedModel?.name ?? 'Select Model'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
