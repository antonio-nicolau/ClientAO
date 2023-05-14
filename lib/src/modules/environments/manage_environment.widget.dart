import 'package:client_ao/src/modules/environments/environment_name_textfield.widget.dart';
import 'package:client_ao/src/modules/environments/environment_value_textfield.widget.dart';
import 'package:client_ao/src/modules/environments/manage_environment_header.widget.dart';
import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/cache/environment_hive.service.dart';
import 'package:client_ao/src/shared/widgets/dialogs/dialog_template.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final envNameProvider = StateProvider<String>((ref) {
  return ref.watch(selectedEnvironmentProvider) ?? 'No Environment';
});

final envIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class EnvironmentManager extends HookConsumerWidget {
  const EnvironmentManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return DialogTemplate(
      width: size.width * 0.9,
      height: size.height * 0.9,
      title: 'Manage Environments',
      body: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ManageEnvironmentHeader(),
                Expanded(child: _EnvironmentNamesSection()),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
                child: Stack(
              children: [
                const EnvironmentValueTextField(),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    onPressed: () {
                      final index = ref.read(envIndexProvider);
                      final key = ref.watch(envNameProvider);
                      ref.read(environmentHiveServiceProvider).removeEnvironment(key, index);
                    },
                    icon: const Icon(Icons.delete_forever_rounded),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _EnvironmentNamesSection extends ConsumerWidget {
  const _EnvironmentNamesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final environments = ref.watch(environmentsProvider);
    final envName = ref.watch(envNameProvider);

    return SizedBox(
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: environments.length,
        itemBuilder: (context, index) {
          return EnvironmentNameTextField(
            index: index,
            envName: environments[index],
            selectedValue: envName,
            onTap: () {
              ref.read(envIndexProvider.notifier).update((state) => index);
              ref.read(envNameProvider.notifier).update((state) => environments[index]);
            },
          );
        },
      ),
    );
  }
}
