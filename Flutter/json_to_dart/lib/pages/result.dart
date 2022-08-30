import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:json_to_dart/utils/extension.dart';
import 'package:json_to_dart/widget/button.dart';

class ResultDialog extends StatelessWidget {
  const ResultDialog({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: text);
    return Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  appLocalizations.resultDialogTitle,
                ),
                CloseButton(
                  onPressed: () {
                    SmartDialog.compatible.dismiss();
                  },
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                TapButton(
                  icon: Icons.copy,
                  title: appLocalizations.buttonCopyText,
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: controller.text),
                    );
                    SmartDialog.showToast(appLocalizations.buttonCopySuccess);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
