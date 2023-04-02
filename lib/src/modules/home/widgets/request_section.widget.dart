import 'package:client_ao/src/modules/home/widgets/url_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestSection extends ConsumerWidget {
  const RequestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1),
          right: BorderSide(width: 1),
        ),
      ),
      child: Column(
        children: const [
          UrlCard(),
        ],
      ),
    );
  }
}
