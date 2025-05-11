import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final int? maxLines;
  final int? maxLength;
  final int? currentLength;
  final String? Function(String?)? validator;
final bool obscureText;
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.maxLines = 1,
    this.maxLength,
    this.currentLength,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
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
        Container(
          constraints: (maxLines ?? 1) == 1
              ? const BoxConstraints(maxHeight: 40)
              : null,
          child: Stack(
            children: [
              TextFormField(
                controller: controller,
                 obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                ),
                maxLines: maxLines,
                maxLength: maxLength,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
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
        ),
      ],
    );
  }
}
