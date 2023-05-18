import 'package:flutter/material.dart';

import '../consts/consts_widget.dart';

buildCustomSnackBar(BuildContext context, String titulo, String texto) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    action: SnackBarAction(
        label: 'entendi',
        onPressed: (() {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        })),
    elevation: 8,
    duration: Duration(seconds: 4),
    backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
    behavior: SnackBarBehavior.floating,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstsWidget.buildTextTitle(
          titulo,
          // color: Theme.of(context).snackBarTheme.actionTextColor,
        ),
        ConstsWidget.buildTextSubTitle(
          texto,
          // color: Theme.of(context).snackBarTheme.actionTextColor,
        ),
      ],
    ),
  ));
}
