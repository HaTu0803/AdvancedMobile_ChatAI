import 'package:flutter/material.dart';

import '../../../../../data_app/model/knowledge_base/knowledge_model.dart';
import '../../../../../data_app/repository/knowledge_base/knowledge_repository.dart';
import '../../../../../widgets/custom_form_filed.dart';

class CreateAKnowledgeBaseScreen extends StatefulWidget {
  final bool isUpdate;
  final String? assistantId;
  final VoidCallback? onSuccess;

  const CreateAKnowledgeBaseScreen({
    super.key,
    this.isUpdate = false,
    this.assistantId,
    this.onSuccess,
  });

  @override
  State<CreateAKnowledgeBaseScreen> createState() =>
      _CreateAKnowledgeBaseScreenState();
}

class _CreateAKnowledgeBaseScreenState
    extends State<CreateAKnowledgeBaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  int _nameCharCount = 0;
  int _descCharCount = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _nameCharCount = _nameController.text.length;
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _descCharCount = _descriptionController.text.length;
      });
    });
  }

  // void _fetchKnowledgeData(String assistantId) async {
  //   try {
  //     final response = await KnowledgeRepository().getUnitsOfKnowledge(
  //     debugPrint('Fetched assistant data: $response');
  //
  //     setState(() {
  //       _nameController.text = response.assistantName ?? '';
  //       _instructionsController.text = response.instructions ?? '';
  //       _descriptionController.text = response.description ?? '';
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to load assistant data')),
  //     );
  //   }
  // }
  @override
  void dispose() {
    _nameController.dispose();
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

                CustomFormField(
                  label: 'Name',
                  controller: _nameController,
                  hintText: 'Enter a name for your knowledge base...',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for your Knowledge Base';
                    }
                    return null;
                  },
                  maxLines: 1,
                  maxLength: 50,
                  currentLength: _nameCharCount,
                ),
                const SizedBox(height: 8),

                CustomFormField(
                  label: 'Description',
                  controller: _descriptionController,
                  hintText: 'Enter a description for your knowledge base...',
                  isRequired: false,
                  maxLines: 4,
                  maxLength: 500,
                  currentLength: _descCharCount,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // OutlinedButton(
                      //   onPressed: () => Navigator.pop(context),
                      //   style: OutlinedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 8),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      //   child: const Text('Cancel'),
                      // ),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      // FilledButton(
                      //   onPressed: _isLoading ? null : _submitForm,
                      //   style: FilledButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 8),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
          FilledButton(
              onPressed: _isLoading ? null : _submitForm,

                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(widget.isUpdate
                                ? 'Update'
                                : 'Create'),
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


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = Knowledge(
        knowledgeName: _nameController.text,
        description: _descriptionController.text,
      );

      try {
        if (widget.isUpdate) {
          await KnowledgeRepository()
              .updateKnowledge(widget.assistantId!, request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Knowledge Base updated successfully')),
          );
        } else {

          await KnowledgeRepository().createKnowledge(request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Knowledge Base successfully')),
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
}
