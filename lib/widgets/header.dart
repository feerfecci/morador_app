import 'package:morador_app/consts/consts_widget.dart';
import 'package:flutter/material.dart';

Widget buildHeaderPage(
  BuildContext context, {
  String? titulo,
  String? subTitulo,
  required Widget widget,
}) {
  var size = MediaQuery.of(context).size;
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
                  //       color: Theme.of(context).textTheme.bodyLarge!.color),
                  // ),
                  if (titulo != null)
                    ConstsWidget.buildTextTitle(context, titulo,
                        size: 24, textAlign: TextAlign.center),
                  if (subTitulo != null)
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: ConstsWidget.buildTextTitle(context, subTitulo,
                          textAlign: TextAlign.center, size: 20),
                    ),
                  // Text(
                  //   subTitulo,
                  //   style: TextStyle(
                  //       fontSize: 20,
                  //       color: Theme.of(context).textTheme.bodyLarge!.color),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top:
                    subTitulo == null ? size.height * 0.06 : size.height * 0.01,
                right: size.width * 0.02,
                left: size.width * 0.02),
            child: widget,
          ),
        ],
      ),
    ],
  );
}
