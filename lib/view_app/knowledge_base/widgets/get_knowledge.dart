import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  final dynamic model;
  final List<IconAction> iconActions;
  final bool showIconActions;
  final bool showContent;
  final VoidCallback? onPressed;

  ListWidget({
    required this.model,
    required this.iconActions,
    this.showIconActions = true,
    this.showContent = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Icon(Icons.storage,
                      size: 16, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                 Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          model.knowledgeName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                const SizedBox(height: 6),
                Text(
                  model.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${model.numUnits} units',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${(model.totalSize / 1024).toStringAsFixed(1)} KB',
                        style: const TextStyle(color: Colors.purple),
                      ),

                    ),
                  ],
                ),


              ],
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
