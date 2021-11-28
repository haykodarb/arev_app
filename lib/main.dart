import 'package:app_get/pages/theme.dart';
import 'package:app_get/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Arev',
      getPages: routes(),
      initialRoute: RouteNames.startPage,
      theme: darkTheme,
    );
  }
}
