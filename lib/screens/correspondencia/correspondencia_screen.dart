// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:app_portaria/screens/correspondencia/loading_corresp.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
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

      Widget buildRowCodigo(title, protocoloRet, codigoConf) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ConstsWidget.buildTextSubTitle(
                      context, 'Protocolo de Retirada'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: ConstsWidget.buildTextTitle(
                      context,
                      protocoloRet.toString(),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ConstsWidget.buildTextSubTitle(
                      context, 'Código de Confirmação'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: ConstsWidget.buildTextTitle(
                      context,
                      codigoConf.toString(),
                    ),
                  ),
                ],
              ),
            ],
          )),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            apiListarCorrespondencias(tipoAviso);
            isChecked = false;
            correspRetirar.clear();
          });
        },
        child: buildScaffoldAll(context,
            title: tipoAviso == 3 ? 'Cartas' : 'Caixas',
            body: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.005, bottom: size.height * 0.02),
                  child: ConstsWidget.buildLoadingButton(context,
                      title: 'Solicitar Retirada',
                      color: Color.fromARGB(255, 251, 80, 93),
                      isLoading: loadingRetirada, onPressed: () {
                    correspRetirar.isNotEmpty
                        ? carregandoRetirada()
                        // print(correspRetirar)
                        : buildCustomSnackBar(context,
                            titulo: 'Atenção',
                            texto: 'Selecione um ou mais itens para retirada');
                  }),
                ),
                FutureBuilder<dynamic>(
                    future: apiListarCorrespondencias(tipoAviso),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingCorresp();
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
                                  var correspInfos =
                                      snapshot.data!['correspondencias'][index];
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
                                  var statusCorresp =
                                      correspInfos['status_entrega'];

                                  var datahora_cadastro = DateFormat(
                                          'dd/MM/yyyy')
                                      .format(DateTime.parse(
                                          correspInfos['datahora_cadastro']));
                                  var datahora_ultima_atualizacao =
                                      correspInfos[
                                          'datahora_ultima_atualizacao'];
                                  return MyBoxShadow(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.01),
                                    child: Column(
                                      children: [
                                        ConstsWidget.buildTextTitle(
                                            context, remetente,
                                            textAlign: TextAlign.center,
                                            size: 18),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.height * 0.01),
                                          child: ConstsWidget.buildTextSubTitle(
                                              context,
                                              '$descricao - $datahora_cadastro'),
                                        ),
                                        if (loadingRetirada)
                                          Center(
                                              child: ShimmerWidget(
                                            height: size.height * 0.03,
                                            width: size.width * 0.3,
                                          )),
                                        if (!statusCorresp && protocolo == '')
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                            return ConstsWidget.buildCheckBox(
                                                context,
                                                isChecked: isChecked,
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
                                            }, title: 'Solicitar Retirar');
                                          }),
                                        if (protocolo != 'Senha' &&
                                            protocolo != '' &&
                                            !statusCorresp)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.01),
                                            child: ConstsWidget.buildTextTitle(
                                                context,
                                                'Dados para retirada por terceiros',
                                                color: Color.fromARGB(
                                                    255, 43, 135, 219)),
                                          ),
                                        if (protocolo == 'Senha' &&
                                            statusCorresp)
                                          ConstsWidget.buildTextTitle(context,
                                              'Retirada com senha do usuario',
                                              color: Colors.red),
                                        if (protocolo != 'Senha' &&
                                            protocolo != '' &&
                                            statusCorresp)
                                          ConstsWidget.buildTextTitle(context,
                                              'Retirada com protocolo'),
                                        if (protocolo != 'Senha' &&
                                            protocolo != '' &&
                                            !statusCorresp)
                                          buildRowCodigo(
                                              'Protocolo de Retirada',
                                              protocolo.toString(),
                                              protocolo_entrega),
                                        if (protocolo != 'Senha' &&
                                            protocolo != '' &&
                                            !statusCorresp)
                                          ConstsWidget.buildTextSubTitle(
                                              context,
                                              'Pode utilizar a senha de retirada para validar a entrega',
                                              color: Colors.red)
                                      ],
                                    ),
                                  ));
                                });
                          }
                        }
                      }
                    }),
              ],
            )),
      );
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
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}
