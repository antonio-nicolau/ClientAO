import 'dart:developer';
import 'dart:io';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:client_ao/src/shared/widgets/code_highlight_view.widget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponsePreview extends ConsumerWidget {
  const ResponsePreview({super.key, this.response});

  final ResponseModel? response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themesProvider);
    final url = response?.requestUri;
    final contentType = response?.headers?[HttpHeaders.contentTypeHeader];
    final mediaType = contentType?.isNotEmpty == true ? MediaType.parse(contentType ?? '') : MediaType('text', 'json');

    return SingleChildScrollView(
      child: getWidgetByContentType(
        context: context,
        mediaType: mediaType,
        url: url,
        theme: theme,
      ),
    );
  }

  Widget getWidgetByContentType({
    required BuildContext context,
    required MediaType mediaType,
    String? url,
    ThemeMode? theme,
  }) {
    switch (mediaType.type) {
      case 'image':
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.network(
            url ?? '',
            fit: BoxFit.cover,
          ),
        );
      case 'video':
        log('Handling video content');
        break;
      default:
        return CodeHighlightView(
          code: response?.formattedBody ?? '',
          language: mediaType.subtype,
          tabSize: 16,
        );
    }
    return const Text('Content not supported');
  }
}
