import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponseHeaders extends ConsumerWidget {
  const ResponseHeaders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final responseAsync = ref.watch(responseStateProvider(activeId));

    return Container(
      padding: const EdgeInsets.all(16),
      child: responseAsync?.when(
        data: (response) {
          final headers = response?.headers ?? {};

          if (headers.isEmpty) return const Text('no headers');

          return ListView.builder(
              itemCount: headers.entries.length,
              itemBuilder: (context, index) {
                final header = headers.entries.elementAt(index);

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.grey[200],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SelectableText(
                          header.key,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Expanded(
                        child: SelectableText(header.value),
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
