import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:client_ao/src/modules/home/states/request_headers.state.dart';
import 'package:client_ao/src/modules/home/states/request_url_params.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedMethodProvider = StateProvider<RequestMethod>((ref) {
  return RequestMethod.get;
});

class UrlCard extends HookConsumerWidget {
  const UrlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlController = useTextEditingController(text: 'https://jsonplaceholder.typicode.com/comments?postId=1');

    void request() {
      final uri = ref.read(urlStateProvider);
      final method = ref.read(selectedMethodProvider);
      final headers = ref.read(requestHeadersStateProvider);
      print(headers.entries.map((e) => e.value.value));
      if (uri != null) {
        final requestModel = RequestModel(
          uri: uri,
          body: 'body',
          method: method,
          headers: headers.entries.map((e) => e.value).toList(),
        );

        ref.read(apiRequestNotifierProvider.notifier).request(requestModel);
      }
    }

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          const DropdownButtonRequestMethod(),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: urlController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter API endpoint like api.foss42.com/country/codes",
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                if (ref.read(urlStateProvider) != null) {
                  final uri = Uri.tryParse(value);
                  final queryParameters = ref.read(urlStateProvider)?.queryParameters;

                  final newUri = Uri(
                    scheme: uri?.scheme,
                    path: uri?.path,
                    host: uri?.host,
                    queryParameters: queryParameters,
                  );

                  ref.read(urlStateProvider.notifier).state = newUri;
                  return;
                }
                ref.read(urlStateProvider.notifier).state = Uri.tryParse(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: request,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class DropdownButtonRequestMethod extends HookConsumerWidget {
  const DropdownButtonRequestMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    // final activeId = ref.watch(activeIdStateProvider);
    // final collection = ref.read(collectionStateNotifierProvider)!;
    // final idIdx = collection.indexWhere((m) => m.id == activeId);
    final method = ref.watch(selectedMethodProvider);
    return DropdownButton<RequestMethod>(
      focusColor: surfaceColor,
      value: method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (RequestMethod? value) {
        ref.read(selectedMethodProvider.notifier).state = value ?? RequestMethod.get;
      },
      items: RequestMethod.values.map<DropdownMenuItem<RequestMethod>>((RequestMethod value) {
        return DropdownMenuItem<RequestMethod>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
