import 'dart:async';
import 'dart:convert';

import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/scaffold_all.dart';
import '../../widgets/snack_bar.dart';

class CorrespondenciaScreen extends StatelessWidget {
  final int? tipoAviso;
  const CorrespondenciaScreen({required this.tipoAviso, super.key});

  @override
  Widget build(BuildContext context) {
    List correspRetirar = <String>[];
    bool loadingRetirada = false;
    bool isChecked = false;
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      void carregandoRetirada() {
        setState(() {
          loadingRetirada = !loadingRetirada;
        });
        launchSolicitarRetirada(correspRetirar.join(","));

        Timer(Duration(seconds: 2), () {
          setState(() {
            CorrespondenciaScreen(tipoAviso: tipoAviso);
            loadingRetirada = !loadingRetirada;
            buildCustomSnackBar(
              context,
              titulo: 'Retirada Solicitada',
              texto: 'Agora pode retirar suas encomendas',
            );
          });
        });
      }

      return buildScaffoldAll(context,
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                apiListarCorrespondencias(tipoAviso);
                isChecked == true;
                correspRetirar.clear();
              });
            },
            child: buildHeaderPage(
              context,
              titulo: tipoAviso == 1 ? 'Correspondências' : 'Encomendas',
              subTitulo: tipoAviso == 1
                  ? 'Confira suas cartas'
                  : 'Confira suas Caixas',
              widget: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  FutureBuilder<dynamic>(
                      future: apiListarCorrespondencias(tipoAviso),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            subtitle: ShimmerWidget(
                              height: size.height * 0.02,
                              width: size.width * 0.01,
                            ),
                            title: ShimmerWidget(
                                height: size.height * 0.03,
                                width: size.width * 0.03),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return Text('Algo deu errado! Volte Mais tarde!');
                        } else {
                          if (snapshot.data['erro']) {
                            return PageVazia(title: snapshot.data['mensagem']);
                          } else {
                            if (loadingRetirada) {
                              return ListTile(
                                subtitle: ShimmerWidget(
                                  height: size.height * 0.02,
                                  width: size.width * 0.01,
                                ),
                                title: ShimmerWidget(
                                    height: size.height * 0.03,
                                    width: size.width * 0.03),
                              );
                            } else {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount:
                                      snapshot.data!['correspondencias'].length,
                                  itemBuilder: (context, index) {
                                    var correspInfos = snapshot
                                        .data!['correspondencias'][index];
                                    var idcorrespondencia =
                                        correspInfos['idcorrespondencia'];
                                    var idunidade = correspInfos['idunidade'];
                                    var unidade = correspInfos['unidade'];
                                    var divisao = correspInfos['divisao'];
                                    var idcondominio =
                                        correspInfos['idcondominio'];
                                    var nome_condominio =
                                        correspInfos['nome_condominio'];
                                    var idfuncionario =
                                        correspInfos['idfuncionario'];
                                    var nome_funcionario =
                                        correspInfos['nome_funcionario'];
                                    var data_recebimento =
                                        correspInfos['data_recebimento'];
                                    var tipo = correspInfos['tipo'];
                                    var remetente = correspInfos['remetente'];
                                    var descricao = correspInfos['descricao'];
                                    var protocolo = correspInfos['protocolo'];
                                    var protocolo_entrega =
                                        correspInfos['protocolo_entrega'];

                                    var datahora_cadastro = DateFormat(
                                            'dd/MM/yyyy')
                                        .format(DateTime.parse(
                                            correspInfos['datahora_cadastro']));
                                    var datahora_ultima_atualizacao =
                                        correspInfos[
                                            'datahora_ultima_atualizacao'];
                                    return MyBoxShadow(
                                        child: Column(
                                      children: [
                                        ConstsWidget.buildTextTitle(
                                            context, remetente),
                                        ConstsWidget.buildTextSubTitle(context,
                                            '$descricao - $datahora_cadastro'),
                                        if (loadingRetirada)
                                          Center(
                                              child: ShimmerWidget(
                                            height: size.height * 0.03,
                                            width: size.width * 0.3,
                                          )),
                                        if (protocolo == null ||
                                            protocolo == '')
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return CheckboxListTile(
                                              title: Text('Retirar'),
                                              value: isChecked,
                                              activeColor: Consts.kColorApp,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    isChecked = value!;
                                                    value
                                                        ? correspRetirar.add(
                                                            idcorrespondencia
                                                                .toString())
                                                        : correspRetirar.remove(
                                                            idcorrespondencia
                                                                .toString());
                                                  },
                                                );
                                                print(correspRetirar);
                                              },
                                            );
                                          }),
                                        if (protocolo.toString() != 'null')
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.01),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    ConstsWidget.buildTextSubTitle(
                                                        context,
                                                        'Protocolo de retirada:'),
                                                    ConstsWidget.buildTextTitle(
                                                      context,
                                                      protocolo.toString(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    ConstsWidget.buildTextSubTitle(
                                                        context,
                                                        'Protocolo de entrega:'),
                                                    ConstsWidget.buildTextTitle(
                                                        context,
                                                        protocolo_entrega
                                                            .toString()),
                                                  ],
                                                )
                                              ],
                                            )),
                                          ),
                                      ],
                                    ));
                                  });
                            }
                          }
                        }
                      }),
                  ConstsWidget.buildLoadingButton(context,
                      title: 'Solicitar Retirada',
                      color: Consts.kColorApp,
                      isLoading: loadingRetirada, onPressed: () {
                    correspRetirar.isNotEmpty
                        ? carregandoRetirada()
                        // print(correspRetirar)
                        : buildCustomSnackBar(context,
                            titulo: 'Cuidado',
                            texto: 'Selecione um item para retirada');
                  }),
                ],
              ),
            ),
          ));
    });
  }
}

apiListarCorrespondencias(int? tipoAviso) async {
  var resposta = await http.get(Uri.parse(
      '${Consts.apiUnidade}correspondencias/?fn=listarCorrespondencias&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&tipo=$tipoAviso'));
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}

launchSolicitarRetirada(listaRetirada) async {
  var resposta = await http.get(Uri.parse(
      '${Consts.apiUnidade}correspondencias/?fn=solicitarCorrespondencias&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&listacorrespondencias=$listaRetirada'));
  // print(
  //     '${Consts.apiUnidade}correspondencias/?fn=solicitarCorrespondencias&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&listacorrespondencias=$listaRetirada');
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}
