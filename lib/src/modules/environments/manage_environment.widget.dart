import 'package:client_ao/src/modules/environments/sub_environments.widget.dart';
import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/hive.service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnvironmentManager extends ConsumerWidget {
  const EnvironmentManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () async {
                  await ref.read(hiveServiceProvider).saveEnvironment();
                  ref.invalidate(environmentsProvider);
                },
                icon: const Icon(Icons.add),
                label: const Text('New'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => ref.read(hiveServiceProvider).clearAll(),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete all'),
              ),
            ],
          ),
          const Expanded(child: SubEnvironments()),
        ],
      ),
    );
  }
}
