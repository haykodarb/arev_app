import 'package:flutter/material.dart';

class DataItem extends StatelessWidget {
  const DataItem({
    Key? key,
    required this.itemTitle,
    required this.itemData,
  }) : super(key: key);

  final String itemTitle;
  final String itemData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: <Flexible>[
          Expanded(
            flex: 8,
            child: Container(
              child: Text(
                itemTitle.toString(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 20,
                    ),
              ),
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
          Expanded(
            flex: 5,
            child: Container(
              child: Text(
                itemData.toString(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 20,
                    ),
              ),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
