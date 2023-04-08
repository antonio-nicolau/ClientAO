import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';

@immutable
class ResponseModel {
  const ResponseModel({
    this.statusCode,
    this.headers,
    this.requestUri,
    this.requestHeaders,
    this.contentType,
    this.mediaType,
    this.body,
    this.formattedBody,
    this.bodyBytes,
    this.time,
  });

  final int? statusCode;
  final Map<String, String>? headers;
  final Map<String, String>? requestHeaders;
  final String? contentType;
  final MediaType? mediaType;
  final String? body;
  final String? formattedBody;
  final Uint8List? bodyBytes;
  final Duration? time;
  final Uri? requestUri;

  factory ResponseModel.fromResponse({
    required Response response,
    Duration? time,
  }) {
    MediaType? mediaType;
    var contentType = response.headers[HttpHeaders.contentTypeHeader];
    try {
      mediaType = MediaType.parse(contentType!);
    } catch (e) {
      mediaType = null;
    }
    final responseHeaders = mergeMaps(
      {HttpHeaders.contentLengthHeader: response.contentLength.toString()},
      response.headers,
    );

    final body = (mediaType?.subtype == 'json') ? utf8.decode(response.bodyBytes) : response.body;
    return ResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestUri: response.request?.url,
      requestHeaders: response.request?.headers,
      contentType: contentType,
      mediaType: mediaType,
      body: body,
      formattedBody: formatBody(body, mediaType),
      bodyBytes: response.bodyBytes,
      time: time,
    );
  }
}

String? formatBody(String? body, MediaType? mediaType) {
  if (mediaType != null && body != null) {
    var subtype = mediaType.subtype;
    try {
      if (subtype.contains('json')) {
        final tmp = jsonDecode(body);
        String result = const JsonEncoder.withIndent('  ').convert(tmp);
        return result;
      }
      if (subtype.contains('xml')) {
        final document = XmlDocument.parse(body);
        String result = document.toXmlString(pretty: true, indent: '  ');
        return result;
      }
      if (subtype == 'html') {
        var len = body.length;
        var lines = const JsonEncoder.withIndent('  ').convert(body);
        var numOfLines = lines.length;
        if (numOfLines != 0 && len / numOfLines <= 200) {
          return body;
        }
      }
    } catch (e) {
      return null;
    }
  }
  return null;
}
