import 'package:app_portaria/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';

Widget buildScaffoldAll(context,
    {required Widget? body,
    Widget? floatingActionButton,
    bool? resizeToAvoidBottomInset}) {
  return Scaffold(
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    floatingActionButton: floatingActionButton,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
    ),
    endDrawer: CustomDrawer(),
    body: body,
  );
}
