import 'package:client_ao/src/modules/home/states/request_headers.state.dart';
import 'package:client_ao/src/modules/home/states/request_url_params.state.dart';
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
        _HeadersOptions(),
        _UrlPreview(),
        _HeadersListView(),
      ],
    );
  }
}

class _UrlPreview extends ConsumerWidget {
  const _UrlPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlPreview = ref.watch(urlStateProvider);

    if (urlPreview.toString().isEmpty) return const SizedBox.shrink();

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text(urlPreview.toString())),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: urlPreview.toString())).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('URL Copied to clipboard')),
              );
            });
          },
          icon: const Icon(Icons.copy_outlined),
        ),
      ]),
    );
  }
}

class _HeadersListView extends ConsumerWidget {
  const _HeadersListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headers = ref.watch(requestUrlParamsNotifierProvider);

    return ListView.builder(
      itemCount: headers?.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return headers?[index];
      },
    );
  }
}

class _HeadersOptions extends HookConsumerWidget {
  const _HeadersOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<_HeadersButtons>? buttons;

    useEffect(
      () {
        buttons = [
          _HeadersButtons(
            label: 'Add',
            onTap: () {
              ref.read(requestUrlParamsNotifierProvider.notifier).add();
            },
          ),
          _HeadersButtons(
            label: 'Remove All',
            onTap: () {
              ref.read(requestUrlParamsNotifierProvider.notifier).removeAll();
            },
          ),
        ];
        return;
      },
    );

    return SizedBox(
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
    );
  }
}

class _HeadersButtons {
  final String label;
  final VoidCallback? onTap;

  _HeadersButtons({required this.label, this.onTap});
}
