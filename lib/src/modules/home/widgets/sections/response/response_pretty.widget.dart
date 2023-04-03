import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:highlighter/highlighter.dart' show highlight;

class ResponsePretty extends ConsumerWidget {
  const ResponsePretty({super.key, this.response});

  final Response? response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(highlight.parse(response?.body ?? '', language: 'html').toHtml()), // Text(response?.body ?? 'No data'),
      ),
    );
  }
}
