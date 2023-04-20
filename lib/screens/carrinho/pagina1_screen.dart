import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});

  @override
  State<Pagina1> createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildHeaderPage(context,
          titulo: 'Carinho', subTitulo: 'Confira seu carrinho', widget: Container()),
    );
  }
}
