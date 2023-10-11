import 'package:app_portaria/consts/consts_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageVazia extends StatefulWidget {
  String title;

  PageVazia({required this.title, super.key});

  @override
  State<PageVazia> createState() => _PageVaziaState();
}

class _PageVaziaState extends State<PageVazia> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ConstsWidget.buildCachedImage(context,
              iconApi: 'https://a.portariaapp.com/img/ico-nao-encontrado.png'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: ConstsWidget.buildTextTitle(context, widget.title,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
