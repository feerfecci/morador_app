// ignore_for_file: prefer_final_fields

import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../widgets/scaffold_all.dart';

class CorrespondenciaScreen extends StatefulWidget {
  const CorrespondenciaScreen({super.key});

  @override
  State<CorrespondenciaScreen> createState() => _CorrespondenciaScreenState();
}

class _CorrespondenciaScreenState extends State<CorrespondenciaScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildCircleStage(
        String title, String subTitle, int stageMail, int thisStatus,
        {double width = 0.19}) {
      Color backColor = Colors.grey;
      Widget child = Icon(
        Icons.cancel_outlined,
        weight: 90,
      );

      if (stageMail == thisStatus) {
        backColor = Colors.green;
        subTitle = 'Retirada';
        child = Icon(
          Icons.check_outlined,
          weight: 90,
        );
      }

      return Column(
        children: [
          CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: backColor,
            child: child,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.005,
            ),
            child: SizedBox(
                width: size.width * width,
                child: Text(
                  subTitle,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      );
    }

    return buildScaffoldAll(
        body: buildHeaderPage(
      context,
      titulo: 'Correspondências',
      subTitulo: 'Confira suas cartas',
      widget: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return MyBoxShadow(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consts.buildTextTitle('Remetente'),
              Consts.buildTextSubTitle('Envelope - 26/04/2023'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCircleStage('2', 'Aguardando Retirada', 2, 2),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: Row(
                  children: [
                    Consts.buildTextSubTitle('Informe o Protocolo: '),
                    Consts.buildTextTitle('12346'),
                  ],
                ),
              )
            ],
          ));
        },
      ),
    ));
  }
}
