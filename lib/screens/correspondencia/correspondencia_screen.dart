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

class CorrespondenciaScreen extends StatefulWidget {
  final int? tipoAviso;
  const CorrespondenciaScreen({required this.tipoAviso, super.key});

  @override
  State<CorrespondenciaScreen> createState() => _CorrespondenciaScreenState();
}

class _CorrespondenciaScreenState extends State<CorrespondenciaScreen> {
  List correspRetirar = <String>[];
  bool loadingRetirada = false;
  String? numeroProtocolo = '';

  void carregandoRetirada() {
    setState(() {
      loadingRetirada = !loadingRetirada;
      numeroProtocolo == '';
    });
    launchSolicitarRetirada(correspRetirar.join(","));

    Timer(Duration(seconds: 2), () {
      setState(() {
        CorrespondenciaScreen(tipoAviso: widget.tipoAviso);
        loadingRetirada = !loadingRetirada;
        buildCustomSnackBar(
          context,
          titulo: 'Retirada Solicitada',
          texto: 'Agora pode retirar suas encomendas',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String numProtocolo = '';
    bool isChecked = false;
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(context,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              apiListarCorrespondencias(widget.tipoAviso);
              correspRetirar.clear();
            });
          },
          child: buildHeaderPage(
            context,
            titulo: widget.tipoAviso == 1 ? 'Correspondências' : 'Encomendas',
            subTitulo: widget.tipoAviso == 1
                ? 'Confira suas cartas'
                : 'Confira suas Caixas',
            widget: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                FutureBuilder<dynamic>(
                    future: apiListarCorrespondencias(widget.tipoAviso),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                        if (snapshot.data['erro'] == true) {
                          return PageVazia(title: snapshot.data['mensagem']);
                        }
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
                              var idcondominio = correspInfos['idcondominio'];
                              var nome_condominio =
                                  correspInfos['nome_condominio'];
                              var idfuncionario = correspInfos['idfuncionario'];
                              var nome_funcionario =
                                  correspInfos['nome_funcionario'];
                              var data_recebimento =
                                  correspInfos['data_recebimento'];
                              var tipo = correspInfos['tipo'];
                              var remetente = correspInfos['remetente'];
                              var descricao = correspInfos['descricao'];
                              var protocolo =
                                  numProtocolo = correspInfos['protocolo'];
                              numeroProtocolo = protocolo;
                              var datahora_cadastro = DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(
                                      correspInfos['datahora_cadastro']));
                              var datahora_ultima_atualizacao =
                                  correspInfos['datahora_ultima_atualizacao'];
                              return ListTile(
                                  title: ConstsWidget.buildTextTitle(
                                      context, remetente),
                                  subtitle: ConstsWidget.buildTextSubTitle(
                                      '$descricao - $datahora_cadastro'),
                                  trailing: SizedBox(
                                    height: size.height * 0.4,
                                    width: size.width * 0.38,
                                    child: loadingRetirada == true
                                        ? Center(
                                            child: ShimmerWidget(
                                            height: size.height * 0.03,
                                            width: size.width * 0.3,
                                          ))
                                        : protocolo == null || protocolo == ''
                                            ? StatefulBuilder(
                                                builder: (context, setState) {
                                                return CheckboxListTile(
                                                  title: Text('Retirar'),
                                                  value: isChecked,
                                                  activeColor: Consts.kColorApp,
                                                  onChanged: (value) {
                                                    setState(
                                                      () {
                                                        isChecked = value!;
                                                        setState(
                                                          () {
                                                            numeroProtocolo =
                                                                protocolo;
                                                          },
                                                        );
                                                        value
                                                            ? correspRetirar.add(
                                                                idcorrespondencia
                                                                    .toString())
                                                            : correspRetirar.remove(
                                                                idcorrespondencia
                                                                    .toString());
                                                        print(correspRetirar);
                                                      },
                                                    );
                                                  },
                                                );
                                              })
                                            : Center(
                                                child:
                                                    ConstsWidget.buildTextTitle(
                                                        context, protocolo)),
                                  ));
                            });
                      }
                    }),
                if (numProtocolo != '')
                  ConstsWidget.buildLoadingButton(
                    context,
                    title: 'Solicitar Retirada',
                    color:
                        numeroProtocolo == '' ? Consts.kColorApp : Colors.grey,
                    isLoading: loadingRetirada,
                    onPressed: numeroProtocolo == ''
                        ? () {
                            carregandoRetirada();
                          }
                        : () {},
                  ),
              ],
            ),
          ),
        ));
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
  print(
      '${Consts.apiUnidade}correspondencias/?fn=solicitarCorrespondencias&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&listacorrespondencias=$listaRetirada');
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}



//SCAFFOLD
        // floatingActionButton: Visibility(
        //   visible: isChecked == true ? true : false,
        //   child: SizedBox(
        //     width: size.width * 0.92,
        //     child: ConstsWidget.buildCustomButton(
        //       context,
        //       'Solicitar Retirada',
        //       onPressed: () {
        //         launchSolicitarRetirada(correspRetirar.join(","));
        //         buildCustomSnackBar(context,
        //             titulo: 'Retirada Solicitada',
        //             texto: 'Agora pode retirar suas encomendas');
        //       },
        //     ),
        //   ),
        // ),
        // FloatingActionButton(
        //     backgroundColor: Consts.kColorApp,

        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(16))),
        //     onPressed: () {
        //       launchSolicitarRetirada(correspRetirar.join(","));
        //       buildCustomSnackBar(context,
        //           titulo: 'Retirada Solicitada',
        //           texto: 'Agora pode retirar suas encomendas');
        //     },
        //     child: Text('')),




//ULTIMO BOTAO
  // SizedBox(
                        //   width: size.width * 0.92,
                        //   child: ConstsWidget.buildCustomButton(
                        //     context,
                        //     'Solicitar Retirada',
                        //     onPressed:
                        //         /*  isChecked == true
                        //         ?*/
                        //         () {
                        //       carregandoRetirada();
                        //     }
                        //     /*   : () {
                        //             buildCustomSnackBar(context,
                        //                 titulo: 'Cuidado',
                        //                 texto:
                        //                     'Selecione uma correspondência para retirar');
                        //           }*/
                        //     ,
                        //   ),
                        // ),

//LISTTILE BOXSHADOW
                // MyBoxShadow(
                              //                                 child: Column(
                              //                               crossAxisAlignment: CrossAxisAlignment.start,
                              //                               children: [
                              //                                 ConstsWidget.buildTextTitle(context,remetente),
                              //                                 ConstsWidget.buildTextSubTitle(
                              //                                     '$descricao - $datahora_cadastro'),
                              //                                 // Padding(
                              //                                 //   padding: EdgeInsets.symmetric(vertical: 10),
                              //                                 //   child: Row(
                              //                                 //     mainAxisAlignment: MainAxisAlignment.center,
                              //                                 //     children: [
                              //                                 //       buildCircleStage(
                              //                                 //           '2', 'Aguardando Retirada', 2, 2),
                              //                                 //     ],
                              //                                 //   ),
                              //                                 // ),
                              //                                 Padding(
                              //                                   padding: EdgeInsets.symmetric(
                              //                                       vertical: size.height * 0.02),
                              //                                   child: Row(
                              //                                     children: [
                              //                                       ConstsWidget.buildTextSubTitle(
                              //                                           'Id Corresp: '),
                              //                                       ConstsWidget.buildTextTitle(context,
                              //                                           '$idcorrespondencia'),
                              //                                     ],
                              //                                   ),
                              //                                 ),
                              //                                 StatefulBuilder(builder: (context, setState) {
                              //                                   return CheckboxListTile(
                              //                                     title: Text('Quero retirar essa corresp'),
                              //                                     value: isChecked,
                              //                                     activeColor: Consts.kColorApp,
                              //                                     onChanged: (value) {
                              //                                       setState(
                              //                                         () {
                              //                                           isChecked = value!;
                              //                                           value
                              //                                               ? correspRetirar
                              //                                                   .add(idcorrespondencia.toString())
                              //                                               : correspRetirar.remove(
                              //                                                   idcorrespondencia.toString());
                              //                                           print(correspRetirar);
                              //                                         },
                              //                                       );
                              //                                     },
                              //                                   );
                              //                                 })
                              //                               ],
                              //                             ));
                              //           );
              