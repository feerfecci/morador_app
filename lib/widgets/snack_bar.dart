import 'package:flutter/material.dart';

import '../consts/consts_widget.dart';

buildCustomSnackBar(BuildContext context,
    {required String titulo, required String texto}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.endToStart,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    // action: SnackBarAction(
    //     label: 'entendi',
    //     onPressed: (() {
    //       ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //     })),

    showCloseIcon: true,
    closeIconColor: Colors.white,
    elevation: 8,

    duration: Duration(seconds: 4),
    backgroundColor: Colors.blue,
    behavior: SnackBarBehavior.floating,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstsWidget.buildTextTitle(context, titulo, color: Colors.white
            // color: Theme.of(context).snackBarTheme.actionTextColor,
            ),
        ConstsWidget.buildTextSubTitle(texto, color: Colors.white
            // color: Theme.of(context).snackBarTheme.actionTextColor,
            ),
      ],
    ),
  ));
}
