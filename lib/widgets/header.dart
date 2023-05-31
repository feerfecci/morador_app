import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:flutter/material.dart';

Widget buildHeaderPage(
  BuildContext context, {
  required String titulo,
  required String subTitulo,
  required Widget widget,
}) {
  var size = MediaQuery.of(context).size;
  return StatefulBuilder(builder: (context, setState) {
    return ListView(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              child: TweenAnimationBuilder(
                curve: Curves.easeIn,
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                duration: Duration(milliseconds: 800),
                child: Column(
                  children: [
                    // Text(
                    //   titulo,
                    //   style: TextStyle(
                    //       fontSize: 40,
                    //       fontWeight: FontWeight.bold,
                    //       color: Theme.of(context).colorScheme.primary),
                    // ),
                    ConstsWidget.buildTextTitle(context, titulo,
                        size: 24, textAlign: TextAlign.center),
                    ConstsWidget.buildTextTitle(context, subTitulo,
                        textAlign: TextAlign.center),
                    // Text(
                    //   subTitulo,
                    //   style: TextStyle(
                    //       fontSize: 20,
                    //       color: Theme.of(context).colorScheme.primary),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.1,
              ),
              child: widget,
            ),
          ],
        ),
      ],
    );
  });
  ;
}
