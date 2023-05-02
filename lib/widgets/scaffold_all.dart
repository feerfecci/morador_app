import 'package:app_portaria/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';

Widget buildScaffoldAll({required Widget? body}) {
  return Scaffold(
    appBar: AppBar(),
    endDrawer: CustomDrawer(),
    body: body,
  );
}
