import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/utils/overlay.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final overlayEntryProvider = StateProvider<OverlayEntry?>((ref) {
  return null;
});

final textFieldValueProvider = StateProvider<String?>((ref) {
  return null;
});

// A State provider to check wether user is typing into TextField
final isTypingProvider = StateProvider<bool>((ref) {
  return false;
});

final selectedSuggestionTextProvider = StateProvider.family<String?, int>((ref, key) {
  return null;
});

class TextFieldWithEnvironmentSuggestion extends HookConsumerWidget {
  const TextFieldWithEnvironmentSuggestion({
    super.key,
    this.hintText,
    this.onChanged,
    this.rows,
    this.defaultValue,
    this.displaySuggestion = true,
    required this.parentContext,
  });
  final String? hintText;
  final Function(String)? onChanged;
  final List<KeyValueRow>? rows;
  final String? defaultValue;
  final BuildContext parentContext;
  final bool displaySuggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldController = useTextEditingController(text: defaultValue);
    final focusNode = useFocusNode();

    ref.listen(selectedSuggestionTextProvider(textFieldController.hashCode), (previous, next) {
      if (next != null) {
        onChanged?.call(next);
      }
    });

    useEffect(
      () {
        if (!displaySuggestion) return;

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          removeOverlayIfExist(ref);
        });
        return;
      },
      [context],
    );

    void prepareOverlayEntry() {
      if (!displaySuggestion) return;

      removeOverlayIfExist(ref);
      createOverlayEntry(context, ref, textFieldController, focusNode);
    }

    return TextField(
      controller: textFieldController,
      decoration: InputDecoration(
        hintText: hintText ?? 'value',
        hintStyle: Theme.of(parentContext).inputDecorationTheme.hintStyle,
      ),
      style: Theme.of(parentContext).textTheme.titleMedium,
      onChanged: (value) {
        prepareOverlayEntry();

        ref.read(isTypingProvider.notifier).update((state) => true);
        ref.read(textFieldValueProvider.notifier).update((state) => value);

        if (displaySuggestion) {
          showEnvironmentVariablesSuggestions(context, ref);
        }

        onChanged?.call(value);
      },
      onTapOutside: (event) {
        // NOTE: Delay 200ms to don't dismiss Overlay before add text to TextField
        if (ref.read(isTypingProvider)) {
          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            if (context.mounted) {
              ref.read(isTypingProvider.notifier).update((state) => false);
            }
          });
        }
      },
      onSubmitted: (value) {
        if (ref.read(isTypingProvider)) {
          removeOverlayIfExist(ref);
          ref.read(isTypingProvider.notifier).update((state) => false);
        }
      },
    );
  }

  void showEnvironmentVariablesSuggestions(BuildContext context, WidgetRef ref) {
    final overlayEntry = ref.read(overlayEntryProvider);

    if (overlayEntry == null) return;

    Overlay.of(context, debugRequiredFor: this).insert(overlayEntry);
  }
}
