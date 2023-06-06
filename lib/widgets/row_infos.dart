import 'package:flutter/material.dart';

import '../consts/consts_widget.dart';

Widget buildRowInfos(BuildContext context,
    {required String title1,
    required String subTitle1,
    required String title2,
    required String subTitle2}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstsWidget.buildTextSubTitle(context, title1),
            ConstsWidget.buildTextTitle(context, subTitle1),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstsWidget.buildTextSubTitle(context, title2),
            ConstsWidget.buildTextTitle(context, subTitle2),
          ],
        ),
      ],
    ),
  );
}
