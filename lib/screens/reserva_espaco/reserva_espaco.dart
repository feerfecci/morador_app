import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../consts/consts_widget.dart';

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
      context,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: ConstsWidget.buildTextTitle(
                          context, 'Salão de Festa'),
                    ),
                    ConstsWidget.buildTextSubTitle('Início:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(
                            context,
                            title: 'Data',
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##/##'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context,
                              title: 'Horario',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##:##'),
                              ]),
                        ),
                      ],
                    ),
                    ConstsWidget.buildTextSubTitle('Término:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context,
                              title: 'Data',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##/##'),
                              ]),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                          child: buildMyTextFormField(context,
                              title: 'Horario',
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##:##'),
                              ]),
                        ),
                      ],
                    ),
                    buildMyTextFormField(
                      context,
                      title: 'Quantidade de Pessoas',
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    ConstsWidget.buildCustomButton(
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
