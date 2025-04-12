import 'package:flutter/material.dart';
import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../data_app/repository/prompt_repository.dart';

class CreatePromptScreen extends StatefulWidget {
  final PromptItemV2? promptToEdit;
  final void Function()? onSubmitSuccess;

  const CreatePromptScreen({
    super.key,
    this.promptToEdit,
    this.onSubmitSuccess,
  });

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = false;

  bool get isEditMode => widget.promptToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final prompt = widget.promptToEdit!;
      _titleController.text = prompt.title;
      _contentController.text = prompt.content;
      _descriptionController.text = prompt.description ?? '';
      _isPublic = prompt.isPublic ?? false;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  final ButtonStyle buttonStyle = ButtonStyle(
    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
  );
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Title',
                    controller: _titleController,
                    hintText: 'Title of the prompt',
                    isRequired: true,
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: 'Prompt',
                    controller: _contentController,
                    hintText: 'Content of the prompt. For example: "Write about the benefits of [topic] in [number] words"',
                    isRequired: true,
                    maxLines: 5,
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter content' : null,
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: 'Description (optional)',
                    controller: _descriptionController,
                    hintText: 'Description of the prompt. For example: "This prompt is used to write about the benefits of [topic]"',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: buttonStyle,
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          style: buttonStyle,
                          onPressed: _submitForm,
                          child: Text(isEditMode ? 'Update' : 'Create'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isRequired = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            if (isRequired)
              Text(' *', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final request = CreatePromptRequest(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        isPublic: _isPublic,
        description: _descriptionController.text.trim(),
      );

      try {
        if (isEditMode) {
          await PromptRepository().updatePrompt(widget.promptToEdit!.id, request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prompt updated successfully'), backgroundColor: Colors.green),
          );
        } else {
          await PromptRepository().createPrompt(request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prompt created successfully'), backgroundColor: Colors.green),
          );
        }

        widget.onSubmitSuccess?.call(); // ← gọi callback

        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
