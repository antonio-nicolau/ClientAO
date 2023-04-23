import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/modules/environments/environment_name_textfield.widget.dart';
import 'package:client_ao/src/modules/environments/environment_value_textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubEnvironments extends HookConsumerWidget {
  const SubEnvironments({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final selectedEnvironment = ref.watch(selectedEnvironmentProvider);
    final selectedValue = useState<String>(selectedEnvironment ?? '');

    return Row(
      children: [
        _EnvironmentNamesSection(selectedValue: selectedValue),
        SizedBox(
          height: size.height,
          child: const VerticalDivider(thickness: 2),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: EnvironmentValueTextField(
              selectedValue.value,
              key: Key(selectedValue.value),
            ),
          ),
        ),
      ],
    );
  }
}

class _EnvironmentNamesSection extends ConsumerWidget {
  const _EnvironmentNamesSection({
    super.key,
    required this.selectedValue,
  });

  final ValueNotifier<String> selectedValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final environments = ref.watch(environmentsProvider);

    return SizedBox(
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: environments.length,
        itemBuilder: (context, index) {
          return EnvironmentNameTextField(
            index: index,
            envName: environments[index],
            selectedValue: selectedValue.value,
            onTap: () => selectedValue.value = environments[index],
          );
        },
      ),
    );
  }
}
