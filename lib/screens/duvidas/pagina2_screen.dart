import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';

class Pagina2 extends StatefulWidget {
  const Pagina2({super.key});

  @override
  State<Pagina2> createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildHeaderPage(
        context,
        titulo: 'Duvidas',
        subTitulo: 'Tire suas dúvidas',
        widget: Container(),
      ),
    );
  }
}
