import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_get/pages/graph/controller.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GraphPageController(),
      builder: (GraphPageController controller) {
        return Container();
      },
    );
  }
}
