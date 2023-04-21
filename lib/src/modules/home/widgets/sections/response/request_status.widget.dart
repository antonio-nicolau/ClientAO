import 'package:client_ao/src/core/constants/default_values.dart';
import 'package:client_ao/src/core/utils/layout.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestStatus extends HookConsumerWidget {
  const RequestStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final responseAsync = ref.watch(responseStateProvider(activeId));

    return responseAsync?.when(
          data: (data) {
            if (data == null || data.statusCode == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    data.statusCode.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${defaultResponseCodeReasons[data.statusCode]}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${data.requestDuration}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${data.responseSize}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            );
          },
          error: (error, _) {
            return const Text('Error');
          },
          loading: () => const SizedBox.shrink(),
        ) ??
        const SizedBox.shrink();
  }
}
