import 'dart:convert';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

Color getRequestMethodColor(HttpVerb? method) {
  switch (method) {
    case HttpVerb.get:
      return Colors.deepPurpleAccent;
    case HttpVerb.post:
      return Colors.green;
    case HttpVerb.put:
      return Colors.orange;
    case HttpVerb.patch:
      return Colors.yellow;
    case HttpVerb.delete:
      return Colors.red;
    default:
      return Colors.deepPurpleAccent;
  }
}

String getRequestTitleFromUrl(String? url) {
  if (url == null || url.trim() == "") {
    return "untitled";
  }
  if (url.contains("://")) {
    String rem = url.split("://")[1];
    if (rem.trim() == "") {
      return "untitled";
    }
    return rem;
  }
  return url;
}

String toHumanizeDuration(Duration? duration) {
  if (duration == null) {
    return "";
  }
  if (duration.inMinutes >= 1) {
    final min = duration.inMinutes;
    final secs = duration.inSeconds.remainder(60) * 100 ~/ 60;
    final secondsPadding = secs < 10 ? "0" : "";
    return "$min.$secondsPadding$secs m";
  }
  if (duration.inSeconds >= 1) {
    final secs = duration.inSeconds;
    final milliseconds = duration.inMilliseconds.remainder(1000) ~/ 10;
    final millisecondsPadding = milliseconds < 10 ? "0" : "";
    return "$secs.$millisecondsPadding$milliseconds s";
  } else {
    return "${duration.inMilliseconds} ms";
  }
}

// Convert to KB, MB, or GB
String toHumanizeResponseSize(int responseSize) {
  if (responseSize < 1024) {
    return '$responseSize bytes';
  } else if (responseSize < (1024 * 1024)) {
    return '${(responseSize / 1024).toStringAsFixed(2)} KB';
  } else if (responseSize < (1024 * 1024 * 1024)) {
    return '${(responseSize / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else {
    return '${(responseSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
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

Map<String, String>? listToMap(List<KeyValueRow>? rows, {bool isHeader = false}) {
  if (rows == null) return null;

  if (rows.isNotEmpty && rows.first.key == null) return null;

  return Map.fromEntries(
    rows.map((e) => MapEntry<String, String>(e.key ?? '', e.value ?? '')),
  );
}

String addPaddingToMultilineString(String text, int padding) {
  var lines = const LineSplitter().convert(text);

  for (int start = 1; start < lines.length; start++) {
    lines[start] = ' ' * padding + lines[start];
  }
  return lines.join("\n");
}

void copyToClipboard({
  required BuildContext context,
  required String? text,
  String? successMessage,
}) async {
  Clipboard.setData(ClipboardData(text: text)).then(
    (value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage ?? 'URL Copied to clipboard')),
      );
    },
  );
}

(double dy,double dx,Size size) getWidgetSize(BuildContext? context) {
    final renderBox = context?.findRenderObject() as RenderBox;
    final local = renderBox.localToGlobal(Offset.zero);
    final dy = local.dy;
    final dx = local.dx;
    final size = renderBox.size;
    return (dx,dy,size);
  }