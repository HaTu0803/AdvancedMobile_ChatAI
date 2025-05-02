import 'package:advancedmobile_chatai/data_app/model/knowledge_base/knowledge_data_source_model.dart';
import 'package:advancedmobile_chatai/data_app/repository/knowledge_base/knowledge_data_source_repository%20copy.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/widgets/notice.dart';
import 'package:flutter/material.dart';

class AddWebSiteScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final String id;

  const AddWebSiteScreen({
    super.key,
    this.onSuccess,
    required this.id,
  });

  @override
  State<AddWebSiteScreen> createState() => _AddWebSiteScreenState();
}

class _AddWebSiteScreenState extends State<AddWebSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _webUrlController = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _webUrlController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _webUrlController.removeListener(_validateForm);
    _nameController.dispose();
    _webUrlController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final url = _webUrlController.text.trim();

    final uri = Uri.tryParse(url);
    final isValidUrl = uri != null && uri.hasScheme && uri.hasAuthority;

    final isValid = name.isNotEmpty && isValidUrl;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
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
                  hintText: 'Enter knowledge unit name...',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter knowledge unit name';
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                _buildFormField(
                  label: 'Web URL',
                  controller: _webUrlController,
                  hintText: 'https://example.com',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a URL';
                    }

                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                      return 'Please enter a valid URL';
                    }

                    return null;
                  },

                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                const PageLimitNotice(),
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
                        onPressed:
                            (_isLoading || !_isFormValid) ? null : _submitForm,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                            : const Text('Import'),
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
    int? maxLength,
    int? currentLength,
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
        Stack(
          children: [
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
              maxLength: maxLength,
              buildCounter: (_,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              validator: validator,
            ),
            if (maxLength != null && currentLength != null)
              Positioned(
                right: 8,
                bottom: 4,
                child: Text(
                  '$currentLength/$maxLength',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = UploadWebsite(
        unitName: _nameController.text.trim(),
        webUrl: _webUrlController.text.trim(),
      );

      try {
        await KnowledgeDataRepository().uploadWeb(widget.id, request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Knowledge source added successfully')),
        );
        widget.onSuccess?.call();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add knowledge source')),
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
