import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_layout_by_auth_method.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_tab.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/headers_tab/request_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_params_tab/request_url_params.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_card/url_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestSection extends HookConsumerWidget {
  const RequestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final tabController = useTabController(
      initialLength: 4,
      initialIndex: 2,
    );

    return Container(
      key: Key(activeId.toString()),
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1),
          right: BorderSide(width: 1),
        ),
      ),
      child: Column(
        children: [
          const UrlCard(),
          const SizedBox(height: 16),
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Params'),
              AuthTab(),
              Tab(text: 'Headers'),
              Tab(text: 'Body'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                const RequestUrlParams(),
                const AuthLayoutBasedOnMethod(),
                const RequestHeaders(),
                Container(
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
