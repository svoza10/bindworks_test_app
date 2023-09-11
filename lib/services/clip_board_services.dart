import 'dart:async';

import 'package:flutter/services.dart';

class FlutterClipboard {
  /// copy receives a string text and saves to Clipboard
  /// returns void
  static Future<void> copy(String text) async {
    if (text.isNotEmpty) {
      unawaited(Clipboard.setData(ClipboardData(text: text)));
      return;
    } else {
      throw ('Please enter a string');
    }
  }
}
