import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/modules/environments/sub_environments.widget.dart';
import 'package:client_ao/src/shared/services/hive.service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnvironmentSection extends ConsumerWidget {
  const EnvironmentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnvironment = ref.watch(selectedEnvironmentProvider);

    return Row(
      children: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: _SelectEnvironmentDialog(),
                );
              },
            );
          },
          child: Text(selectedEnvironment ?? 'No Environment'),
        ),
        const Icon(Icons.arrow_drop_down),
      ],
    );
  }
}

class _SelectEnvironmentDialog extends HookConsumerWidget {
  const _SelectEnvironmentDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final environments = ref.watch(environmentsProvider);
    final selectedEnvironment = ref.watch(selectedEnvironmentProvider);

    return SizedBox(
      width: size.width * 0.3,
      height: size.height * 0.5,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: environments.length,
            itemBuilder: (context, index) {
              final envName = environments[index];
              if (environments.isEmpty) return const Text('No environment');

              return Container(
                padding: const EdgeInsets.all(8),
                color: envName == selectedEnvironment ? Colors.grey[300] : Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    ref.read(hiveServiceProvider).saveSelectedEnvironment(envName);
                    ref.read(selectedEnvironmentProvider.notifier).update((state) => envName);
                  },
                  child: Text(
                    envName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(hiveServiceProvider).clearSelectedEnvironment();
              ref.invalidate(selectedEnvironmentProvider);
            },
            child: const Text('No environment'),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 2, color: Colors.grey),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(content: _ManageEnvironments());
                },
              );
            },
            child: const Text('Manage Environments'),
          ),
        ],
      ),
    );
  }
}

class _ManageEnvironments extends ConsumerWidget {
  const _ManageEnvironments({super.key});

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
