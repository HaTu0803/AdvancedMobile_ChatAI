import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  final dynamic model;
  final List<IconAction> iconActions;
  final bool showIconActions;
  final bool showContent;
  final VoidCallback? onPressed;

  ButtonAction({
    required this.model,
    required this.iconActions,
    this.showIconActions = true,
    this.showContent = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title + Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        model.title ?? 'No Title',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),

                    if (showContent && model.description?.isNotEmpty == true)
                      const SizedBox(height: 6),
                    if (showContent && model.description?.isNotEmpty == true)
                      Text(
                        model.description!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        textAlign: TextAlign.justify,
                      ),
                  ],
                ),
              ),
              // Icon Actions
              if (showIconActions && iconActions.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: iconActions.map((action) {
                    return SizedBox(
                      width: action.size.width,
                      height: action.size.height,
                      child: IconButton(
                        icon: Icon(action.icon),
                        padding: EdgeInsets.zero,
                        iconSize: action.style?.iconSize?.toDouble() ?? 16,
                        color: action.style?.iconColor ?? Colors.black,
                        onPressed: action.onPressed,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconAction {
  final IconData icon;
  final VoidCallback onPressed;
  final Size size;
  final IconButtonStyle? style;

  IconAction({
    required this.icon,
    required this.onPressed,
    this.size = const Size(32, 32),
    this.style,
  });
}

class IconButtonStyle {
  final Color? iconColor;
  final double? iconSize;

  IconButtonStyle({
    this.iconColor,
    this.iconSize,
  });
}
