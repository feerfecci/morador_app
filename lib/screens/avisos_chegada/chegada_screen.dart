import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/scaffold_all.dart';

class ChegadaScreen extends StatelessWidget {
  final int tipo;
  const ChegadaScreen({required this.tipo, super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(context,
        body: buildHeaderPage(
          context,
          titulo: tipo == 1 ? 'Delivery' : 'Visitas',
          subTitulo:
              tipo == 1 ? 'Confira seus Deliveries' : 'Confira seus Visitantes',
          widget: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return MyBoxShadow(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstsWidget.buildTextTitle('Ifood'),
                  ConstsWidget.buildTextSubTitle('Retirada - 26/04/2023'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ],
              ));
            },
          ),
        ));
  }
}
