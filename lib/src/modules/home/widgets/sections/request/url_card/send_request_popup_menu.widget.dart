import 'package:client_ao/src/modules/code_generator/code_generator.page.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:client_ao/src/shared/widgets/client_ao_popup_menu.widget.dart';
import 'package:client_ao/src/shared/widgets/dialogs/repeat_on_interval_dialog.widget.dart';
import 'package:client_ao/src/shared/widgets/dialogs/send_after_delay_dialog.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopUpSendMenu extends HookConsumerWidget {
  const PopUpSendMenu({
    super.key,
    required this.widgetRef,
    required this.collection,
    required this.parentContext,
  });

  final WidgetRef widgetRef;
  final CollectionModel? collection;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = useState<PopupMenuModel?>(null);

    return ClientAoPopupMenu(
      icon: const Icon(Icons.arrow_drop_down),
      initialValue: selectedMenu.value,
      items: sendMethodsOptions,
      callback: (item) => callback(context, item),
    );
  }

  void sendRequest() {
    final request = collection?.requests;

    if (request != null) {
      widgetRef.read(collectionsNotifierProvider.notifier).sendRequest();
    }
  }

  void callback(BuildContext context, PopupMenuModel item) {
    switch (item.method) {
      case SendPopUpItem.send:
        return sendRequest();
      case SendPopUpItem.generateCode:
        return displayDialog(context, const CodeGenPage());
      case SendPopUpItem.sendAfterDelay:
        return displayDialog(context, const SendAfterDelayDialog());
      case SendPopUpItem.repeatRequest:
        return displayDialog(context, const RepeatOnIntervalDialog());
    }
  }
}
