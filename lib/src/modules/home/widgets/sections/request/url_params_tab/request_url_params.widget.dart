import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_header_field.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_params_tab/url_param_field.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_preview.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        _HeadersListView(),
      ],
    );
  }
}

class _HeadersListView extends HookConsumerWidget {
  const _HeadersListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final index = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final urlParamsRows = ref.watch(collectionsNotifierProvider)[index].requestModel?.headers;

    List<_HeadersButtons>? buttons;

    useEffect(
      () {
        buttons = [
          _HeadersButtons(
            label: 'Add',
            onTap: () {
              urlParamsRows?.add(HttpHeader());
              ref.read(collectionsNotifierProvider.notifier).updateUrlParams(
                    activeId,
                    urlParams: urlParamsRows,
                  );
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
        ListView.builder(
          itemCount: urlParamsRows?.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return UrlParamField(
              index: index,
              row: urlParamsRows?[index] ?? HttpHeader(),
            );
          },
        ),
      ],
    );
  }
}

class _HeadersButtons {
  final String label;
  final VoidCallback? onTap;

  _HeadersButtons({required this.label, this.onTap});
}
