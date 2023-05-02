import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/scaffold_all.dart';

class VisitantesScreen extends StatefulWidget {
  const VisitantesScreen({super.key});

  @override
  State<VisitantesScreen> createState() => _VisitantesScreenState();
}

class _VisitantesScreenState extends State<VisitantesScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
        body: buildHeaderPage(
      context,
      titulo: 'Visitantes',
      subTitulo: 'Confira seus Visitantes',
      widget: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return MyBoxShadow(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consts.buildTextTitle('Fernando Amorim Fecci'),
              Consts.buildTextSubTitle('RG: - 50.900.454-5'),
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
