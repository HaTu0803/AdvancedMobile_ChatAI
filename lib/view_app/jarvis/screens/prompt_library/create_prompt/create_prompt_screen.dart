import 'package:flutter/material.dart';

import '../../../../../data_app/model/jarvis/prompt_model.dart';
import '../../../../../data_app/repository/jarvis/prompt_repository.dart';
import '../../../../../widgets/custom_form_filed.dart';

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

  bool get isEditMode => widget.promptToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final prompt = widget.promptToEdit!;
      _titleController.text = prompt.title;
      _contentController.text = prompt.content;
      _descriptionController.text = prompt.description ?? '';
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    label: 'Title',
                    controller: _titleController,
                    hintText: 'Title of the prompt',
                    isRequired: true,
                    maxLines: 1,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomFormField(
                    label: 'Prompt',
                    controller: _contentController,
                    hintText:
                        'Content of the prompt. For example: "Write about the benefits of [topic] in [number] words"',
                    isRequired: true,
                    maxLines: 5,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter content'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomFormField(
                    label: 'Description (optional)',
                    controller: _descriptionController,
                    hintText:
                        'Description of the prompt. For example: "This prompt is used to write about the benefits of [topic]"',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
                    children: [
                      // First button (Cancel)
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      // Second button (Create/Update)
                      FilledButton(
                        onPressed: _submitForm,
                        child: Text(isEditMode ? 'Update' : 'Create'),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final request = CreatePromptRequest(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        isPublic: false,
        description: _descriptionController.text.trim(),
      );

      try {
        if (isEditMode) {
          await PromptRepository()
              .updatePrompt(widget.promptToEdit!.id, request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Prompt updated successfully'),
                backgroundColor: Colors.green),
          );
        } else {
          await PromptRepository().createPrompt(request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Prompt created successfully'),
                backgroundColor: Colors.green),
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
