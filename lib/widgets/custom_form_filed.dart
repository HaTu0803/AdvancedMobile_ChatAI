import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: maxLines == 1
              ? const BoxConstraints(maxHeight: 40) // Giới hạn chiều cao khi maxLines = 1
              : null,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withAlpha(160), // Màu nền nhạt
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
