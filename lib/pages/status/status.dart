import 'package:app_get/pages/common/data_item.dart';
import 'package:app_get/pages/status/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  Widget _webSocketData({
    required BuildContext context,
    required StatusPageController controller,
  }) {
    return StreamBuilder<dynamic>(
      stream: controller.createWebSocketStream(),
      builder: (context, snapshot) {
        final List<String> dataList = snapshot.data.toString().split(',');
        if (snapshot.hasData) {
          return SizedBox(
            height: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DataItem(
                  itemTitle: 'Sistema',
                  itemData: dataList[3] == '1' ? 'ON' : 'OFF',
                ),
                DataItem(
                  itemTitle: 'Resistencia',
                  itemData: dataList[2] == '1' ? 'ON' : 'OFF',
                ),
                DataItem(
                  itemTitle: 'Temperatura',
                  itemData: '${dataList[1]}°C',
                ),
                DataItem(
                  itemTitle: dataList[0],
                  itemData: '28/11/2021',
                ),
                /* 
                TODO ADD API FOR DATE GET IN DEVICE
                */
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 350,
            width: 350,
            child: Center(
              child: SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 7.0,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _configButtons({
    required BuildContext context,
    required StatusPageController controller,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextButton(
              onPressed: () {},
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 60,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    'Configurar',
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextButton(
              onPressed: () {},
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 60,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    'Ajustar Fecha',
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StatusPageController(),
      builder: (StatusPageController controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _webSocketData(
              context: context,
              controller: controller,
            ),
            _configButtons(
              context: context,
              controller: controller,
            ),
          ],
        );
      },
    );
  }
}
