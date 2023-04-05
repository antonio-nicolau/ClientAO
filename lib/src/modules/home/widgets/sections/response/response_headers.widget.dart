import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponseHeaders extends ConsumerWidget {
  const ResponseHeaders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collections = ref.watch(collectionsNotifierProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final requestResponse = collections[collectionIndex].response;

    return Container(
      padding: const EdgeInsets.all(16),
      child: requestResponse?.when(
        data: (response) {
          final headers = response?.headers ?? {};

          if (headers.isEmpty) return const Text('no headers');

          return ListView.builder(
              itemCount: headers.entries.length,
              itemBuilder: (context, index) {
                final header = headers.entries.elementAt(index);

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.grey[300],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(header.key),
                      ),
                      Expanded(
                        child: Text(header.value),
                      ),
                    ],
                  ),
                );
              });
        },
        error: (error, _) {
          return const Text('Error');
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
