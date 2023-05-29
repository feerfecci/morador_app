import 'dart:convert';

import 'package:app_portaria/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/scaffold_all.dart';

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
    return buildScaffoldAll(context,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              listarVisitasDlivery(tipoAviso: widget.tipo);
            });
          },
          child: buildHeaderPage(
            context,
            titulo: widget.tipo == 1 ? 'Delivery' : 'Visitas',
            subTitulo: widget.tipo == 1
                ? 'Confira seus Deliveries'
                : 'Confira seus Visitantes',
            widget: FutureBuilder<dynamic>(
                future: listarVisitasDlivery(tipoAviso: widget.tipo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data['historico_avisos'] == null) {
                    return Text('Algo deu errado');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data['historico_avisos'].length,
                    itemBuilder: (context, index) {
                      var apiChegada = snapshot.data['historico_avisos'][index];
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

                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: ListTile(
                          title: ConstsWidget.buildTextTitle(context, titulo),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstsWidget.buildTextTitle(
                                context,
                                texto,
                              ),
                              ConstsWidget.buildTextSubTitle(
                                datahora,
                              ),
                            ],
                          ),
                          //     child: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     ConstsWidget.buildTextTitle(context,'$id'),
                          //     ConstsWidget.buildTextSubTitle(aviso_enviado),
                          //     ConstsWidget.buildTextTitle(context,'$datahora'),
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [],
                          //     ),
                          //   ],
                          // )
                        ),
                      );
                    },
                  );
                }),
          ),
        ));
  }
}
