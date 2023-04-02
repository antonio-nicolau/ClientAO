import 'package:client_ao/src/modules/home/widgets/request_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/response_section.widget.dart';
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
          ),
          const RequestSection(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ResponseSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
