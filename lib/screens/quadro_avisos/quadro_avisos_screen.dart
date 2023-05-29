import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';
import '../../consts/consts_widget.dart';

class QuadroAvisosScreen extends StatefulWidget {
  const QuadroAvisosScreen({super.key});

  @override
  State<QuadroAvisosScreen> createState() => _QuadroAvisosScreenState();
}

class _QuadroAvisosScreenState extends State<QuadroAvisosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      body: buildHeaderPage(context,
          titulo: 'Quadro de Avisos',
          subTitulo: 'Confira as novidade',
          widget: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return MyBoxShadow(
                child: Column(
                  children: [
                    ConstsWidget.buildTextTitle('Asdasf asdasd'),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    ConstsWidget.buildTextSubTitle(
                        'Adaosdasd asdoaisjd asodkbdqwor ryeryoidsldnff. Safsbfb abasud, ashdwem m, aosjda hfpake jfaijs qpkeiin jadnhdpa\nKasf jahfi keoqou, foqye. Afjqnubf ashuel jouhe e, ashasf huahf ja hfpqhrias.\n\nAdaosdasd asdoaisjd asodkbdqwor ryeryoidsldnff. Safsbfb abasud, ashdwem m, aosjda hfpake jfaijs qpkeiin jadnhdpa\nKasf jahfi keoqou, foqye. Afjqnubf ashuel jouhe e, ashasf huahf ja hfpqhrias.\nAdaosdasd asdoaisjd asodkbdqwor ryeryoidsldnff. Safsbfb abasud, ashdwem m, aosjda hfpake jfaijs qpkeiin jadnhdpa\nKasf jahfi keoqou, foqye. Afjqnubf ashuel jouhe e, ashasf huahf ja hfpqhrias.')
                  ],
                ),
              );
            },
          )),
    );
  }
}
