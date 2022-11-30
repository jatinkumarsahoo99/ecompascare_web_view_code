import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyManager {
  CopyManager._();

  static Future<void> copyToClipBoard(
      BuildContext context, String textToBeCopied) async {
    Clipboard.setData(ClipboardData(text: textToBeCopied)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to your clipboard !')));
    });
  }
}
