import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DialogTemplate extends ConsumerWidget {
  const DialogTemplate({
    super.key,
    this.title,
    required this.body,
    this.width,
    this.height,
  });

  final String? title;
  final Widget body;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.6,
      height: height ?? MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: title != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            children: [
              if (title != null)
                Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          body,
        ],
      ),
    );
  }
}
