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
    return Row(
      children: <Flexible>[
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
}
