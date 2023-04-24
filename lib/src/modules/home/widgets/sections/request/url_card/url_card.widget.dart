import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_card/dropdown_button_request_method.widget.dart';
import 'package:client_ao/src/shared/constants/strings.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UrlCard extends HookConsumerWidget {
  const UrlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();
    final url = collection?.requests?.get(activeId?.requestId)?.url;
    final urlController = useTextEditingController(text: url);
    final focusNode = useFocusNode();

    useEffect(
      () {
        urlController.text = url ?? '';
        return;
      },
      [activeId],
    );

    void sendRequest() {
      final request = collection?.requests;

      if (request != null) {
        ref.read(collectionsNotifierProvider.notifier).sendRequest();
      }
      focusNode.requestFocus();
    }

    return SizedBox(
      height: 50,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DropdownButtonRequestMethod(),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: urlController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: urlHintText,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (value) {
                  ref.read(collectionsNotifierProvider.notifier).updateRequest(url: value);
                },
                onSubmitted: (value) => sendRequest.call(),
              ),
            ),
            FilledButton(
              onPressed: sendRequest,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                )),
              ),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
