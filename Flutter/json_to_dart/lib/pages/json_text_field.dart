import 'package:flutter/material.dart';
import 'package:json_to_dart/i18n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json_to_dart/models/json_to_dart_controller.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:provider/provider.dart';

class JsonTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        Provider.of<JsonToDartController>(context, listen: false)
            .textEditingController;
    final AppLocalizations appLocalizations = I18n.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        color: ColorPlate.lightGray,
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: appLocalizations.inputHelp,
          hintStyle: const TextStyle(
            color: ColorPlate.gray,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
