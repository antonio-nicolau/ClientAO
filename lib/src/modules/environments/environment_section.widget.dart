import 'package:client_ao/src/modules/environments/manage_environment.widget.dart';
import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:client_ao/src/shared/services/hive.service.dart';
import 'package:client_ao/src/shared/widgets/client_ao_popup_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnvironmentSection extends HookConsumerWidget {
  const EnvironmentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environments = ref.watch(environmentsProvider);
    final selectedEnvironment = ref.watch(selectedEnvironmentProvider);
    final itemsFromEnv = List.generate(environments.length, (index) {
      return PopupMenuModel(label: environments[index]);
    }).toList();

    useEffect(
      () {
        itemsFromEnv.add(const PopupMenuModel(
          label: 'No environment',
          dividerAfterItem: true,
          dividerLabel: 'General',
        ));
        itemsFromEnv.add(PopupMenuModel(
          label: 'Manage environments',
          icon: Icons.precision_manufacturing_outlined,
          callback: () {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(content: EnvironmentManager());
              },
            );
          },
        ));
        return;
      },
    );

    return Row(
      children: [
        Text(selectedEnvironment ?? 'No Environment'),
        ClientAoPopupMenu(
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: itemsFromEnv,
          callback: (item) {
            if (item.callback != null) return item.callback?.call();

            ref.read(hiveServiceProvider).saveSelectedEnvironment(item.label);
            ref.read(selectedEnvironmentProvider.notifier).update((state) => item.label);
          },
        ),
      ],
    );
  }
}
