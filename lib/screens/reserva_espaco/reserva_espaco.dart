import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

import '../../consts.dart';

class ReservaEspacos extends StatefulWidget {
  const ReservaEspacos({super.key});

  @override
  State<ReservaEspacos> createState() => ReservaEspacosState();
}

class ReservaEspacosState extends State<ReservaEspacos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      body: buildHeaderPage(context,
          titulo: 'Reservar Espaços',
          subTitulo: 'Solicite um espaço',
          widget: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return MyBoxShadow(
                child: Column(
                  children: [
                    Consts.buildTextTitle('Salão de Festa'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context, 'Data Início'),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context, 'Data Fim'),
                        ),
                      ],
                    ),
                    buildMyTextFormField(context, 'Quantidade de Pessoas'),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Consts.buildCustomButton(
                      context,
                      'Solicitar',
                      onPressed: () {},
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
