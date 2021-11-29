import 'package:app_get/pages/status/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  Widget _dataItem({
    required String itemTitle,
    required String itemData,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Flexible(
          child: Container(
            child: Text(
              itemTitle.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            child: Text(
              itemData.toString(),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).backgroundColor,
                  ),
            ),
            alignment: Alignment.center,
            height: 60,
            decoration: const BoxDecoration(color: Colors.white),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

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
                _dataItem(
                  itemTitle: 'Sistema',
                  itemData: dataList[3] == '1' ? 'ON' : 'OFF',
                  context: context,
                ),
                _dataItem(
                  itemTitle: 'Resistencia',
                  itemData: dataList[2] == '1' ? 'ON' : 'OFF',
                  context: context,
                ),
                _dataItem(
                  itemTitle: 'Temperatura',
                  itemData: '${dataList[1]}°C',
                  context: context,
                ),
                _dataItem(
                  itemTitle: 'Hora',
                  itemData: dataList[0],
                  context: context,
                ),
                /* 
                TODO ADD API IN DEVICE
                */
                _dataItem(
                  itemTitle: 'Fecha',
                  itemData: '28/11/2021',
                  context: context,
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            )),
            height: 350,
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
