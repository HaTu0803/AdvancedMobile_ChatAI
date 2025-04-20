import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data_app/repository/knowledge_base/assistant_repository.dart';

class AiModelDropdown extends StatefulWidget {
  const AiModelDropdown({super.key});

  @override
  State<AiModelDropdown> createState() => _AiModelDropdownState();
}

class _AiModelDropdownState extends State<AiModelDropdown> {
  AiModel? selectedModel;
  List<AiModel> bots = [];
  bool isLoadingBots = false;

  final List<AiModel> baseAiModels = [
    AiModel(
      id: 'gpt-4o-mini',
      name: 'GPT-4o mini',
      iconPath: 'images/gpt4o-mini.svg',
    ),
    AiModel(
      id: 'gpt-4o',
      name: 'GPT-4o',
      iconPath: 'images/gpt4o.svg',
      isDefault: true,
    ),
    AiModel(
      id: 'gemini-1.5-flash-latest',
      name: 'Gemini 1.5 Flash',
      iconPath: 'images/gemini-flash.svg',
    ),
    AiModel(
      id: 'gemini-1.5-pro-latest',
      name: 'Gemini 1.5 Pro',
      iconPath: 'images/gemini-pro.svg',
    ),
    AiModel(
      id: 'claude-3-haiku-20240307',
      name: 'Claude 3 Haiku',
      iconPath: 'images/claude-haiku.svg',
    ),
    AiModel(
      id: 'claude-3-sonnet-20240229',
      name: 'Claude 3.5 Sonnet',
      iconPath: 'images/claude-sonnet.svg',
    ),
    AiModel(
      id: 'deepseek-chat',
      name: 'Deepseek Chat',
      iconPath: 'images/deepseek.svg',
    ),
  ];

  Future<void> _fetchBots() async {
    try {
      final response = await AssistantRepository().getAssistants(null);
      debugPrint("Response: ${response.data}");
      setState(() {
        bots.clear();
        bots.addAll(response.data.map((assistant) {
          return AiModel(
            id: assistant.id,
            name: assistant.assistantName,
            iconPath: 'images/your_bots.svg',
            isDefault: assistant.isDefault ?? false,
            model: (assistant.isDefault ?? false) ? 'dify' : 'knowledge-base',
          );
        }).toList());
      });
    } catch (e) {
      debugPrint('Failed to load bots: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    selectedModel = baseAiModels.firstWhere(
          (model) => model.isDefault == true,
      orElse: () => baseAiModels.first,
    );
    _fetchBots();
  }

  void _showModelBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  if (isLoadingBots)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (bots.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("No AI Bots."),
                    )
                  else
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
        Navigator.of(context).pop();
      },
      leading: _buildIcon(model.iconPath),
      title: Text(model.name),
      trailing: model.id == selectedModel?.id
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
    );
  }

  Widget _buildIcon(String? path, {double size = 24}) {
    if (path == null) {
      return const Icon(Icons.image, size: 24);
    } else if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,

        placeholderBuilder: (context) => const Icon(Icons.image, size: 24),
      );
    } else {
      return Image.asset(
        path,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.error, size: 24),
      );
    }
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
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(selectedModel?.iconPath, size: 20),
            const SizedBox(width: 8),
            Text(selectedModel?.name ?? 'Select Model'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
