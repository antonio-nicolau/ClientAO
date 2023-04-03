import 'package:client_ao/src/core/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedAuthOptionProvider = StateProvider<Auth>((ref) {
  return const Auth(label: 'Auth', method: AuthMethod.noAuthentication);
});

class DropdownButtonAuthOptions extends HookConsumerWidget {
  const DropdownButtonAuthOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    // final activeId = ref.watch(activeIdStateProvider);
    // final collection = ref.read(collectionStateNotifierProvider)!;
    // final idIdx = collection.indexWhere((m) => m.id == activeId);

    late List<Auth> values;

    useEffect(() {
      values = const [
        Auth(label: 'Api Key', method: AuthMethod.apiKeyAuth),
        Auth(label: 'Bearer', method: AuthMethod.bearerToken),
        Auth(label: 'Basic', method: AuthMethod.basic),
        Auth(label: 'Auth', method: AuthMethod.noAuthentication),
      ];
      return;
    });

    final method = ref.watch(selectedAuthOptionProvider);
    return DropdownButton<Auth>(
      focusColor: surfaceColor,
      value: method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (Auth? value) {
        ref.read(selectedAuthOptionProvider.notifier).state = value ??
            const Auth(
              label: 'Auth',
              method: AuthMethod.noAuthentication,
            );
      },
      items: values.map<DropdownMenuItem<Auth>>((Auth value) {
        return DropdownMenuItem<Auth>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.label.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
