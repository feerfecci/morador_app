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
      children: [
        Center(
          child: ConstsWidget.buildFutureImage(context,
              iconApi: 'https://a.portariaapp.com/img/ico-nao-encontrado.png'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ConstsWidget.buildTextTitle(context, widget.title),
        ),
      ],
    );
  }
}
