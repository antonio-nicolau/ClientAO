import 'package:client_ao/src/core/constants/enums.dart';
import 'package:flutter/material.dart';

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
