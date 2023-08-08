// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/avisos_chegada/add_visita.screen.dart';
import 'package:app_portaria/screens/correspondencia/loading_corresp.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_all.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_resp_port.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import '../../widgets/scaffold_all.dart';
import 'my_visitas_screen.dart';

class ChegadaScreen extends StatefulWidget {
  final int tipo;
  const ChegadaScreen({required this.tipo, super.key});

  @override
  State<ChegadaScreen> createState() => _ChegadaScreenState();
}

class _ChegadaScreenState extends State<ChegadaScreen> {
  listarVisitasDlivery({required tipoAviso}) async {
    var url = Uri.parse(
        '${Consts.apiUnidade}historico_avisos/index.php?fn=historicoAvisos&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&tipo=$tipoAviso');

    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          listarVisitasDlivery(tipoAviso: widget.tipo);
        });
      },
      child: buildScaffoldAll(context,
          title: widget.tipo == 1 ? 'Delivery' : 'Histórico Visitas',
          body: Column(
            children: [
              if (widget.tipo == 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildOutlinedButton(
                        context,
                        title: 'Adicionar Visita',
                        onPressed: () {
                          ConstsFuture.navigatorPageRoute(
                              context, AddVisitaScreen());
                        },
                      ),
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildCustomButton(
                        context,
                        'Minhas Visitas',
                        onPressed: () {
                          ConstsFuture.navigatorPageRoute(
                              context, MyVisitasScreen());
                        },
                      ),
                    ),
                  ],
                ),
              FutureBuilder<dynamic>(
                  future: listarVisitasDlivery(tipoAviso: widget.tipo),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingCorresp();
                    } else if (snapshot.hasData) {
                      if (!snapshot.data['erro']) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['historico_avisos'].length,
                          itemBuilder: (context, index) {
                            var apiChegada =
                                snapshot.data['historico_avisos'][index];
                            int id = apiChegada['id'];
                            var idfuncionario = apiChegada['idfuncionario'];
                            var idmorador = apiChegada['idmorador'];
                            var idunidade = apiChegada['idunidade'];
                            var idcond = apiChegada['idcond'];
                            var tipo_msg = apiChegada['tipo_msg'];
                            String titulo = apiChegada['titulo'];
                            String texto = apiChegada['texto'];
                            String datahora = DateFormat('dd/MM/yyyy - HH:mm')
                                .format(DateTime.parse(apiChegada['datahora']));

                            var diferenca = DateTime.now().difference(
                                DateTime.parse(apiChegada['datahora']));
                            var isExperado = diferenca <=
                                Duration(seconds: InfosMorador.tempo_resposta);
                            return MyBoxShadow(
                                imagem: !isExperado,
                                child: ConstsWidget.buildPadding001(
                                  context,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ConstsWidget.buildTextTitle(
                                                  context, titulo,
                                                  size: 18,
                                                  textAlign: TextAlign.center),
                                              ConstsWidget.buildPadding001(
                                                context,
                                                child: SizedBox(
                                                  width: size.width * 0.9,
                                                  child: ConstsWidget
                                                      .buildTextSubTitle(
                                                          context, texto,
                                                          textAlign:
                                                              TextAlign.center),
                                                ),
                                              ),
                                              SizedBox(
                                                child: ConstsWidget
                                                    .buildTextSubTitle(
                                                  context,
                                                  datahora,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (isExperado)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * 0.01),
                                          child: ConstsWidget.buildCustomButton(
                                            context,
                                            color: Color.fromARGB(
                                                255, 251, 80, 93),
                                            'Responder Portaria',
                                            onPressed: () {
                                              alertRespondeDelivery(context,
                                                  tipoAviso:
                                                      widget.tipo == 1 ? 5 : 6);
                                            },
                                          ),
                                        )
                                    ],
                                  ),
                                ));
                          },
                        );
                      } else {
                        return PageVazia(title: snapshot.data['mensagem']);
                      }
                    } else {
                      return PageErro();
                    }
                  }),
            ],
          )),
    );
  }
}
