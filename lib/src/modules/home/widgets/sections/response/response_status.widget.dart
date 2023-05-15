import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponseStatus extends HookConsumerWidget {
  /// Widget responsible to build Response status section
  /// on top of Response & Headers preview
  const ResponseStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final responseAsync = ref.watch(responseStateProvider(activeId));

    return responseAsync?.when(
          data: (data) {
            if (data?.isEmpty == true) return const SizedBox.shrink();

            final response = (data?.first as ResponseModel?);
            if (response == null || response.statusCode == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    response.statusCode.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${defaultResponseCodeReasons[response.statusCode]}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${response.requestDuration}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${response.responseSize}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            );
          },
          error: (error, _) => const Text('Error'),
          loading: () => const SizedBox.shrink(),
        ) ??
        const SizedBox.shrink();
  }
}
