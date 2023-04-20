import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/request_status.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_pretty.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_preview_tabs.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final displayResponsePreviewTabProvider = StateProvider<bool>((ref) {
  return false;
});

class ResponseSection extends HookConsumerWidget {
  const ResponseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final hideTabBars = ref.watch(displayResponsePreviewTabProvider);
    final tabController = useTabController(initialLength: 2);
    final responseAsync = ref.watch(responseStateProvider(activeId));

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RequestStatus(),
          Visibility(
            visible: hideTabBars,
            child: ResponsePreviewTabs(tabController: tabController),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: responseAsync?.when(
                    data: (response) {
                      if (response == null || response.body == null) {
                        Future.microtask(() {
                          ref.read(displayResponsePreviewTabProvider.notifier).update((state) => false);
                        });
                        return const NoRequestSentPage();
                      }

                      Future.microtask(() {
                        ref.read(displayResponsePreviewTabProvider.notifier).update((state) => true);
                      });
                      return ResponsePretty(response: response);
                    },
                    error: (error, _) {
                      return Text('$error');
                    },
                    loading: () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitThreeBounce(
                          color: Theme.of(context).primaryColor,
                          size: 60.0,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading...',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const ResponseHeaders(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NoRequestSentPage extends StatelessWidget {
  const NoRequestSentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Send a request to start playing around',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Icon(Icons.send, size: 50),
      ],
    );
  }
}
