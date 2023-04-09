import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/core/utils/tables.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_params_tab/url_preview.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestUrlParams extends HookConsumerWidget {
  const RequestUrlParams({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        UrlPreview(),
        Expanded(child: _UrlParamsRowsList()),
      ],
    );
  }
}

class _UrlParamsRowsList extends HookConsumerWidget {
  const _UrlParamsRowsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final index = ref.watch(collectionsNotifierProvider.notifier).indexOfId();
    final urlParamsRows = ref.watch(collectionsNotifierProvider)[index].requestModel?[activeId?.requestId ?? 0]?.headers;

    List<_HeadersButtons>? buttons;

    useEffect(
      () {
        buttons = [
          _HeadersButtons(
            label: 'Add',
            onTap: () {
              urlParamsRows?.add(KeyValueRow());
              ref.read(collectionsNotifierProvider.notifier).updateUrlParams(urlParamsRows);
            },
          ),
          _HeadersButtons(
            label: 'Remove All',
            onTap: () {
              ref.read(collectionsNotifierProvider.notifier).removeAllUrlParams();
            },
          ),
        ];
        return;
      },
    );

    final daviModel = createDaviTable(
      rows: urlParamsRows,
      keyColumnName: 'Keys',
      valueColumnName: 'Values',
      onFieldsChange: (rows) {
        ref.read(collectionsNotifierProvider.notifier).updateUrlParams(rows);
      },
      onRemoveTaped: () {},
    );

    return Column(
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
        Expanded(child: Davi<KeyValueRow>(daviModel)),
      ],
    );
  }
}

class _HeadersButtons {
  final String label;
  final VoidCallback? onTap;

  _HeadersButtons({required this.label, this.onTap});
}
