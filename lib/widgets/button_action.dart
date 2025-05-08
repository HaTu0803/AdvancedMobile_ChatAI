// action_widget.dart
import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  final dynamic model;
  final List<IconAction> iconActions;
  final bool showIconActions;
  final bool showContent;

  ButtonAction({
    required this.model,
    required this.iconActions,
    this.showIconActions = true,
    this.showContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: iconActions.isNotEmpty ? iconActions[0].onPressed : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text with padding for better visibility
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                model.title ?? 'No Title',
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
                        if (showContent && model.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            model.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor,
        ),
      ],
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
