import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart' as window_size;

Future<void> setupWindow() async {
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final window = await window_size.getWindowInfo();

      final screen = window.screen;
      if (screen != null) {
        final screenFrame = screen.visibleFrame;
        final width = math.max((screenFrame.width / 2).roundToDouble(), 1200.0);
        final height = math.max((screenFrame.height / 2).roundToDouble(), 800.0);
        final left = ((screenFrame.width - width) / 2).roundToDouble();
        final top = ((screenFrame.height - height) / 3).roundToDouble();
        final frame = Rect.fromLTWH(left, top, width, height);
        window_size.setWindowTitle('ClientAO');
        window_size.setWindowFrame(frame);
        window_size.setWindowMinSize(const Size(900, 600));
        window_size.setWindowMaxSize(Size.infinite);
      }
    }
  }
}
