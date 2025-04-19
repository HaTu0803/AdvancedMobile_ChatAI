import 'package:advancedmobile_chatai/data_app/model/knowledge_base/assistant_model.dart';
import 'package:flutter/material.dart';

import '../../../../data_app/datasource/mock_data.dart';
import '../../../../data_app/repository/knowledge_base/assistant_repository.dart';
import '../../../knowledge_base/screens/knowledge_source/knowledge_source.dart';

class CreateYourOwnBotScreen extends StatefulWidget {
  final bool isUpdate;
  final String? assistantId;
  final VoidCallback? onSuccess;

  const CreateYourOwnBotScreen({
    super.key,
    this.isUpdate = false,
    this.assistantId,
    this.onSuccess,
  });

  @override
  State<CreateYourOwnBotScreen> createState() => _CreateYourOwnBotScreenState();
}

class _CreateYourOwnBotScreenState extends State<CreateYourOwnBotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _knowledgebaseController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.assistantId != null) {
      _fetchAssistantData(widget.assistantId!);
    }
  }

  void _fetchAssistantData(String assistantId) async {
    try {
      final response = await AssistantRepository().getAssistant(assistantId);
      debugPrint('Fetched assistant data: $response');

      setState(() {
        _nameController.text = response.assistantName ?? '';
        _instructionsController.text = response.instructions ?? '';
        _descriptionController.text = response.description ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load assistant data')),
      );
    }
  }
  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _knowledgebaseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField(
                  label: 'Name',
                  controller: _nameController,
                  hintText: 'Enter a name for your bot...',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for your bot';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                _buildFormField(
                  label: 'Instructions (Optional)',
                  controller: _instructionsController,
                  hintText: 'Enter instructions for the bot...',
                  isRequired: false,
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Knowledge Base (Optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Enhance your bot\'s responses by adding custom knowledge.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showKnowledgeSourceModal(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 8),
                        Text(
                          'Add Knowledge Source',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        Text(
                          'Advanced Options',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      _buildFormField(
                        label: 'Description (Optional)',
                        controller: _descriptionController,
                        hintText: 'Enter a short description...',
                        isRequired: false,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(widget.isUpdate ? 'Update Bot' : 'Create Bot'),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isRequired = false,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = Assistant(
        assistantName: _nameController.text,
        instructions: _instructionsController.text,
        description: _descriptionController.text,
      );

      try {
        if (widget.isUpdate) {
          await AssistantRepository().updateAssistant(widget.assistantId!, request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bot updated successfully')),
          );
        } else {
          await AssistantRepository().createAssistant(request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bot created successfully')),
          );
        }

        widget.onSuccess?.call();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process the request')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showKnowledgeSourceModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return KnowledgeSource(
          knowledgeSources: knowledgeSources,
        );
      },
    );
  }
}
