import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/hive.service.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:client_ao/src/shared/widgets/textField_with_environment_suggestion.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final environmentByEnvironmentProvider = StateProvider.family<List<MapEntry>?, String?>((ref, search) {
  if (search == null || search.isEmpty) return [];

  final key = ref.watch(selectedEnvironmentProvider) ?? '';

  final envKeys = ref.read(hiveServiceProvider).getEnvironmentValuesByKey(key);

  final result = envKeys?.entries.where((e) => e.key.toString().contains(search)).toList();

  return result;
});

class ListViewWithSuggestions extends HookConsumerWidget {
  const ListViewWithSuggestions({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldValue = ref.watch(textFieldValueProvider);
    final end = controller.selection.end;
    final currentText = textFieldValue?.getStringFromEnd(end);
    final envKeys = ref.watch(environmentByEnvironmentProvider(currentText?.$0.trim()));

    useEffect(
      () {
        if (textFieldValue == null || textFieldValue.isEmpty) {
          removeOverlay(ref);
        }

        return;
      },
      [textFieldValue],
    );

    return Material(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: envKeys?.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${envKeys?.get(index)?.key}'),
            onTap: () {
              final key = envKeys?.get(index)?.key.toString();

              if (key != null) {
                final response = controller.text.split(' ');

                response[currentText?.$1 ?? 0] = '{{$key}}';
                final newString = response.join(' ');

                controller.text = newString;
                focusNode.requestFocus();

                ref.read(selectedSuggestionTextProvider(controller.hashCode).notifier).state = envKeys?.get(index)?.value.toString();
              }

              removeOverlay(ref);
            },
          );
        },
      ),
    );
  }
}
