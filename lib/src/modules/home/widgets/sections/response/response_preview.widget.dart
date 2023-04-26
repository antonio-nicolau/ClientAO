import 'dart:developer';
import 'dart:io';
import 'package:client_ao/src/shared/constants/highlight_view_themes.dart';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponsePreview extends ConsumerWidget {
  const ResponsePreview({super.key, this.response});

  final ResponseModel? response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = response?.requestUri;
    final contentType = response?.headers?[HttpHeaders.contentTypeHeader];
    final mediaType = contentType?.isNotEmpty == true ? MediaType.parse(contentType ?? '') : MediaType('text', 'json');

    return SingleChildScrollView(
      child: getWidgetByContentType(mediaType, url),
    );
  }

  Widget getWidgetByContentType(MediaType mediaType, String? url) {
    switch (mediaType.type) {
      case 'image':
        return Image.network(url ?? '');
      case 'video':
        log('Handling video content');
        break;
      default:
        return HighlightView(
          response?.formattedBody ?? '',
          theme: highlightViewTheme,
          language: mediaType.subtype,
          tabSize: 16,
        );
    }
    return const Text('Content not supported');
  }
}
