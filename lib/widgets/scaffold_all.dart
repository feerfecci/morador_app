import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';

Widget buildScaffoldAll(context,
    {required Widget? body,
    Widget? floatingActionButton,
    bool? resizeToAvoidBottomInset,
    String title = ''}) {
  // ignore: unused_local_variable
  var size = MediaQuery.of(context).size;
  return Scaffold(
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    floatingActionButton: floatingActionButton,
    appBar: AppBar(
      centerTitle: true,
      title: ConstsWidget.buildTextTitle(context, title, size: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
    ),
    endDrawer: CustomDrawer(),
    body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: body,
        ),
      ],
    ),
  );
}
