import 'package:client_ao/src/shared/widgets/environment_suggestions.widget.dart';
import 'package:client_ao/src/shared/widgets/text_fields/textField_with_environment_suggestion.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

(double dx,double dy,Size size) getWidgetSize(BuildContext? context) {
    final renderBox = context?.findRenderObject() as RenderBox;
    final local = renderBox.localToGlobal(Offset.zero);
    final dy = local.dy;
    final dx = local.dx;
    final size = renderBox.size;
    return (dx,dy,size);
  }

  void removeOverlayIfExist(WidgetRef ref) {
  final overlayEntry = ref.read(overlayEntryProvider);

  if (overlayEntry != null && overlayEntry.mounted == true) {
    ref.read(overlayEntryProvider)?.remove();
    ref.invalidate(overlayEntryProvider);
  }
}

  
void createOverlayEntry(
    BuildContext? buildContext,
    WidgetRef ref,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    final response = getWidgetSize(buildContext);

    final dx = response.$0;
    final dy = response.$1;
    final size = response.$2;

    ref.read(overlayEntryProvider.notifier).state = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: dy + 35,
              left: dx,
              child: SizedBox(
                width: size.width + 40,
                child: ListViewWithSuggestions(
                  controller: controller,
                  focusNode: focusNode,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
