import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/environment_hive.service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ManageEnvironmentHeader extends ConsumerWidget {
  const ManageEnvironmentHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () async {
            await ref.read(environmentHiveServiceProvider).saveEnvironment();
            ref.invalidate(environmentsProvider);
          },
          icon: const Icon(Icons.add),
          label: const Text('New'),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () => ref.read(environmentHiveServiceProvider).clearAll(),
          icon: const Icon(Icons.delete_forever),
          label: const Text('Delete all'),
        ),
      ],
    );
  }
}
