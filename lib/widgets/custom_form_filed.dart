import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final int? maxLines;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? currentLength;

  const CustomFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.maxLines,
    this.validator,
    this.maxLength,
    this.currentLength,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _currentLength = widget.currentLength ?? 0;
    widget.controller.addListener(_updateCurrentLength);
  }

  void _updateCurrentLength() {
    setState(() {
      _currentLength = widget.controller.text.length;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCurrentLength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: (widget.maxLines ?? 1) == 1
              ? const BoxConstraints(maxHeight: 40)
              : null,
          child: Stack(
            children: [
              TextFormField(
                controller: widget.controller,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                validator: widget.validator,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(160),
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
                  counterText: '', // Ẩn bộ đếm mặc định của TextFormField
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (widget.maxLength != null)
                Positioned(
                  right: 8,
                  bottom: 4,
                  child: Text(
                    '$_currentLength/${widget.maxLength}',
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
