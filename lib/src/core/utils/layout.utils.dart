import 'package:client_ao/src/core/constants/enums.dart';
import 'package:flutter/material.dart';

Color getRequestMethodColor(RequestMethod? method) {
  switch (method) {
    case RequestMethod.get:
      return Colors.deepPurpleAccent;
    case RequestMethod.post:
      return Colors.green;
    case RequestMethod.put:
      return Colors.orange;
    case RequestMethod.patch:
      return Colors.yellow;
    case RequestMethod.delete:
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
