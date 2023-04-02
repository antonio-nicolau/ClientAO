import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

class ResponsePretty extends ConsumerWidget {
  const ResponsePretty({super.key, this.response});

  final Response? response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(response?.body ?? 'No data'),
    );
  }
}
