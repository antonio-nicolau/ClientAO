import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoRequestSent extends ConsumerWidget {
  /// Simple layout displayed for the case that no request was sent by user
  const NoRequestSent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Send a request to start playing around',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Icon(Icons.send, size: 50),
      ],
    );
  }
}
