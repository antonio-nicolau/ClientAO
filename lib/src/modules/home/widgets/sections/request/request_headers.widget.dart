import 'package:client_ao/src/modules/home/states/request_headers.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestHeaders extends HookConsumerWidget {
  const RequestHeaders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        _HeadersOptions(),
        _HeadersListView(),
      ],
    );
  }
}

class _HeadersListView extends ConsumerWidget {
  const _HeadersListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headers = ref.watch(requestHeaderNotifierProvider);

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
              ref.read(requestHeaderNotifierProvider.notifier).add();
            },
          ),
          _HeadersButtons(
            label: 'Remove All',
            onTap: () {
              ref.read(requestHeaderNotifierProvider.notifier).removeAll();
            },
          ),
          _HeadersButtons(
            label: 'Toggle Description',
            onTap: () {},
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
