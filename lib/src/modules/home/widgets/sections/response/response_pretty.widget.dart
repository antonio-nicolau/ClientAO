import 'dart:developer';
import 'dart:io';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/github.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponsePretty extends ConsumerWidget {
  const ResponsePretty({super.key, this.response});

  final ResponseModel? response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = response?.requestUri;
    final contentType = response?.headers?[HttpHeaders.contentTypeHeader];
    final mediaType = contentType?.isNotEmpty == true ? MediaType.parse(contentType ?? '') : MediaType('text', 'json');

    if (response == null || response?.body == null) {
      return const Center(
        child: Text('Enter the URL and click Send to get a response'),
      );
    }

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
          theme: githubTheme,
          language: mediaType.subtype,
        );
    }
    return const Text('Content not supported');
  }
}
