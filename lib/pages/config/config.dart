import 'package:app_get/models/config_body.dart';
import 'package:app_get/pages/config/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/get.dart';

class ConfigDialog extends StatelessWidget {
  const ConfigDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ConfigDialogController(),
      builder: (ConfigDialogController controller) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 60,
              horizontal: 40,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 700,
                maxWidth: 800,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[],
              ),
            ),
          ),
        );
      },
    );
  }
}
