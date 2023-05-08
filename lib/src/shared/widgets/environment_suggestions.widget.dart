import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/environment_hive.service.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:client_ao/src/shared/utils/overlay.utils.dart';
import 'package:client_ao/src/shared/widgets/text_fields/textField_with_environment_suggestion.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// provider responsible to check what environments should be suggested to user
/// based on inserted text
final environmentByInsertedTextProvider = StateProvider.family<List<MapEntry>?, String?>((ref, search) {
  if (search == null || search.isEmpty) return [];
  final isTyping = ref.watch(isTypingProvider);

  if (!isTyping) return [];

  final key = ref.watch(selectedEnvironmentProvider) ?? '';

  final envKeys = ref.read(environmentHiveServiceProvider).getEnvironmentValuesByKey(key);

  final result = envKeys?.entries.where((e) => e.key.toString().contains(search)).toList();

  return result;
});

class ListViewWithSuggestions extends HookConsumerWidget {
  /// ListView with environment suggestion based on [TextFieldWithEnvironmentSuggestion] text
  /// *controller - TextEdittingController from [TextFieldWithEnvironmentSuggestion]
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
    final envKeys = ref.watch(environmentByInsertedTextProvider(currentText?.$0.trim()));

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: envKeys?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                color: Colors.grey.shade800,
                height: 30,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      child: Text(
                        'x',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '_.${envKeys?.get(index)?.key}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
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

                removeOverlayIfExist(ref);
              },
            );
          },
        ),
      ),
    );
  }
}
