import 'dart:io';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestStatus extends HookConsumerWidget {
  const RequestStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final requestResponse = ref.watch(requestResponseStateProvider(activeId));

    return requestResponse?.when(
          data: (response) {
            return Container(
              color: Colors.amber,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    color: response?.statusCode == HttpStatus.ok ? Colors.green : Colors.red,
                    child: Text(
                      response?.statusCode.toString() ?? '',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, _) {
            return const Text('Error');
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ) ??
        const SizedBox.shrink();
  }
}
