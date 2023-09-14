import 'package:flutter/material.dart';

class PageErro extends StatefulWidget {
  const PageErro({super.key});

  @override
  State<PageErro> createState() => _PageErroState();
}

class _PageErroState extends State<PageErro> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset('assets/erro.png'),
        ),
      ],
    );
  }
}
