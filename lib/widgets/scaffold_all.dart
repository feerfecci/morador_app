import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen/splash_screen.dart';

Widget buildScaffoldAll(context,
    {required Widget? body,
    Widget? floatingActionButton,
    bool? resizeToAvoidBottomInset,
    bool hasDrawer = true,
    Widget? bottomNavigationBar,
    String title = ''}) {
  // ignore: unused_local_variable
  var size = MediaQuery.of(context).size;
  return Scaffold(
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomNavigationBar,
    appBar: AppBar(
      centerTitle: true,
      title: Column(
        children: [
          ConstsWidget.buildTextTitle(context, title,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              size: SplashScreen.isSmall ? 20 : 24),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme:
          IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
    ),
    endDrawer: hasDrawer ? CustomDrawer() : null,
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
