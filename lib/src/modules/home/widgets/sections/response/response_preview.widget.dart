import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

class ResponsePreview extends ConsumerWidget {
  const ResponsePreview({super.key, this.response});

  final Response? response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = '${response!.request!.url.origin}${response!.request!.url.path}';
    final contentType = response?.headers[HttpHeaders.contentTypeHeader];
    final mediaType = MediaType.parse(contentType!);

    return Container(
      padding: const EdgeInsets.all(16),
      child: getWidgetByContentType(mediaType, url),
    );
  }

  Widget getWidgetByContentType(MediaType mediaType, String url) {
    switch (mediaType.type) {
      case 'image':
        return Image.network(url);
      case 'video':
        log('Handling video content');
        break;
      default:
        return Html(data: response?.body);
    }
    return const Text('Content not supported');
  }
}
