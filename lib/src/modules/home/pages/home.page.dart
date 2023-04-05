import 'package:client_ao/src/modules/home/widgets/sections/collections/collections_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_section.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: const CollectionsSection(),
          ),
          const RequestSection(),
          const Expanded(child: ResponseSection()),
        ],
      ),
    );
  }
}
