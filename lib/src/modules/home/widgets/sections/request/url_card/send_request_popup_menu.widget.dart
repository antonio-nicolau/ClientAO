import 'package:client_ao/src/modules/code_generator/code_generator.page.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/auth/pop_up.model.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
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

    return PopupMenuButton<PopupMenuModel>(
      icon: const Icon(Icons.arrow_drop_down),
      initialValue: selectedMenu.value,
      itemBuilder: (BuildContext context) => sendMethodsOptions.map((e) {
        return PopupMenuItem<PopupMenuModel>(
          value: e,
          child: Text(e.displayName),
          onTap: () {
            switch (e.method) {
              case SendPopUpItem.send:
                sendRequest();
                break;
              case SendPopUpItem.generateCode:
                Future.delayed(
                  const Duration(seconds: 0),
                  () => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(),
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.grey.shade900,
                      content: const CodeGenPage(),
                    ),
                  ),
                );

                break;
            }
          },
        );
      }).toList(),
    );
  }

  void sendRequest() {
    final request = collection?.requests;

    if (request != null) {
      widgetRef.read(collectionsNotifierProvider.notifier).sendRequest();
    }
  }
}
