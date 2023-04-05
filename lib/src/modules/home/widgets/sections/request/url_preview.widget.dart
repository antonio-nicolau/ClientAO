import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UrlPreview extends HookConsumerWidget {
  const UrlPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final collection = ref.watch(collectionsNotifierProvider)[collectionIndex];
    final urlToPreview = useState<String?>('');

    useEffect(
      () {
        final urlParamsList = collection.requestModel?.urlParams;
        final url = Uri.tryParse(collection.requestModel?.url ?? '');

        if (url != null) {
          final queryParams = <String, String>{};

          final currentQueryParams = url.queryParameters;
          if (currentQueryParams.isNotEmpty) {
            queryParams.addAll(currentQueryParams);
          }

          for (final e in urlParamsList ?? <HttpHeader>[]) {
            if (e.key != null) {
              queryParams[e.key.toString()] = e.value ?? '';
            }
          }

          urlToPreview.value = url.replace(queryParameters: queryParams).toString();
        }

        return;
      },
    );

    if (collection.requestModel?.url == null || collection.requestModel?.url?.isEmpty == true) {
      return const SizedBox.shrink();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text('${urlToPreview.value}')),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: collection.requestModel?.url)).then(
              (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('URL Copied to clipboard')),
                );
              },
            );
          },
          icon: const Icon(Icons.copy_outlined),
        ),
      ]),
    );
  }
}
