// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:ffi';

import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/reserva_espaco/fazer_reserva.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../consts/consts_widget.dart';

class ListarReservas extends StatefulWidget {
  const ListarReservas({super.key});

  @override
  State<ListarReservas> createState() => ListarReservasState();
}

class ListarReservasState extends State<ListarReservas> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTextReserva({required titulo, required texto}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstsWidget.buildTextSubTitle(context, titulo),
            ConstsWidget.buildTextTitle(context, texto),
          ],
        ),
      );
    }

    return buildScaffoldAll(context,
        body: buildHeaderPage(context,
            titulo: 'Reservar Espaços',
            subTitulo: 'Solicite um espaço',
            widget: Column(
              children: [
                FutureBuilder<dynamic>(
                  future: ConstsFuture.changeApi(
                      '${Consts.apiUnidade}reserva_espacos/?fn=listarReservas&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      if (!snapshot.data['erro']) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['reserva_espacos'].length,
                          itemBuilder: (context, index) {
                            var apiEspacos =
                                snapshot.data['reserva_espacos'][index];
                            int status = apiEspacos['status'];
                            String texto_status = apiEspacos['texto_status'];
                            int idespaco = apiEspacos['idespaco'];
                            String nome_espaco = apiEspacos['nome_espaco'];
                            int idcondominio = apiEspacos['idcondominio'];
                            String nome_condominio =
                                apiEspacos['nome_condominio'];
                            int idmorador = apiEspacos['idmorador'];
                            String nome_morador = apiEspacos['nome_morador'];
                            int idunidade = apiEspacos['idunidade'];
                            String unidade = apiEspacos['unidade'];
                            String data_reserva = DateFormat('dd/MM/yy').format(
                                DateTime.parse(apiEspacos['data_reserva']));
                            String datahora = apiEspacos['datahora'];

                            return MyBoxShadow(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      buildTextReserva(
                                        titulo: 'Nome do Escpaço:',
                                        texto: nome_espaco.toString(),
                                      ),
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: status == 0
                                                ? Colors.red
                                                : status == 1
                                                    ? Colors.green
                                                    : Color.fromARGB(
                                                        255, 244, 177, 54),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              size.height * 0.01),
                                          child: ConstsWidget.buildTextTitle(
                                            context,
                                            texto_status,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      buildTextReserva(
                                        titulo: 'Data:',
                                        texto: data_reserva.toString(),
                                      ),
                                      Spacer(),
                                      buildTextReserva(
                                        titulo: 'Reservado por:',
                                        texto: nome_morador.toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Text(snapshot.data['mensagem']);
                      }
                    } else {
                      return Text('Algo deu errado');
                    }
                  },
                )
              ],
            )));
  }
}
