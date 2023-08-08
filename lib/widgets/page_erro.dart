import 'package:app_portaria/consts/consts_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageErro extends StatefulWidget {

  PageErro({ super.key});

  @override
  State<PageErro> createState() => _PageErroState();
}

class _PageErroState extends State<PageErro> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset('assets/vazio.png'),
        ),
      ],
    );
  }
}
