import 'package:flutter/material.dart';

import '../consts/consts.dart';
import '../consts/consts_widget.dart';

buildCustomSnackBar(BuildContext context,
    {required String titulo, required String texto, bool hasError = false}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.endToStart,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    showCloseIcon: true,
    closeIconColor: Colors.white,
    elevation: 8,
    duration: Duration(seconds: 4),
    backgroundColor: hasError ? Consts.kColorRed : Consts.kColorVerde,
    behavior: SnackBarBehavior.floating,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstsWidget.buildTextTitle(context, titulo, color: Colors.white
            // color: Theme.of(context).snackBarTheme.actionTextColor,
            ),
        ConstsWidget.buildTextSubTitle(context, texto, color: Colors.white
            // color: Theme.of(context).snackBarTheme.actionTextColor,
            ),
      ],
    ),
  ));
}
