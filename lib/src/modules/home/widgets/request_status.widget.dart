import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestStatus extends HookConsumerWidget {
  const RequestStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestResponse = ref.watch(apiRequestNotifierProvider);

    return requestResponse.when(
      data: (response) {
        return Container(
          color: Colors.amber,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                color: Colors.green,
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
    );
  }
}
