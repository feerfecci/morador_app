import 'dart:io';

import 'package:flutter/material.dart';

import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';

Widget buildCardHome(BuildContext context,
    {required String title,
    required Widget pageRoute,
    required String iconApi}) {
  Image tryImage() {
    try {
      return Image.network(
        iconApi,
      );
    } on HttpException catch (e) {
      return Image.asset('erro_png');
    }
  }

  var size = MediaQuery.of(context).size;
  return MyBoxShadow(
    paddingAll: 0.0,
    child: InkWell(
      onTap: () {
        ConstsFuture.navigatorPageRoute(context, pageRoute);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: size.width * 0.12,
              height: size.height * 0.075,
              child: tryImage()),
          SizedBox(
            height: size.height * 0.01,
          ),
          ConstsWidget.buildTextTitle(title),
        ],
      ),
    ),
  );
}
