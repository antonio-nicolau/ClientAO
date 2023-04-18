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
