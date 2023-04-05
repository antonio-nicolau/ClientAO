import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_header_field.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestHeaders extends HookConsumerWidget {
  const RequestHeaders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final index = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final headerRows = ref.watch(collectionsNotifierProvider)[index].requestModel?.headers;
    List<_HeadersButtons>? buttons;

    useEffect(
      () {
        buttons = [
          _HeadersButtons(
            label: 'Add',
            onTap: () {
              headerRows?.add(HttpHeader());
              ref.read(collectionsNotifierProvider.notifier).updateHeaders(
                    activeId,
                    headers: headerRows,
                  );
            },
          ),
          _HeadersButtons(
            label: 'Remove All',
            onTap: () {
              ref.read(collectionsNotifierProvider.notifier).removeAllHeaders();
            },
          ),
        ];
        return;
      },
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: buttons?.length,
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  onPressed: buttons?[index].onTap,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  ),
                  child: Text('${buttons?[index].label}'),
                );
              },
            ),
          ),
          ListView.builder(
            itemCount: headerRows?.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return RequestHeaderField(
                UniqueKey(),
                index: index,
                row: headerRows?[index] ?? HttpHeader(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeadersButtons {
  final String label;
  final VoidCallback? onTap;

  _HeadersButtons({required this.label, this.onTap});
}
