import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
              var year = DateTime.now().year.toString();
              return MyBoxShadow(
                child: Column(
                  children: [
                    Consts.buildTextTitle('Salão de Festa'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context, 'Data Início',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##/##'),
                              ]),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context, 'Horario Início',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##:##'),
                              ]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context, 'Data Término',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##/##'),
                              ]),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(
                              context, 'Horario Término',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##:##'),
                              ]),
                        ),
                      ],
                    ),
                    buildMyTextFormField(
                      context,
                      'Quantidade de Pessoas',
                    ),
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
