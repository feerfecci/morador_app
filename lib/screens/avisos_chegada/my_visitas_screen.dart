// ignore_for_file: unused_local_variable, non_constant_identifier_names
import 'package:morador_app/consts/consts.dart';
import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/consts/consts_widget.dart';
import 'package:morador_app/screens/correspondencia/loading_corresp.dart';
import 'package:morador_app/widgets/alert_dialog/alert_all.dart';
import 'package:morador_app/widgets/my_box_shadow.dart';
import 'package:morador_app/widgets/page_erro.dart';
import 'package:morador_app/widgets/page_vazia.dart';
import 'package:morador_app/widgets/scaffold_all.dart';
import 'package:morador_app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../splash_screen/splash_screen.dart';

class MyVisitasScreen extends StatefulWidget {
  const MyVisitasScreen({super.key});

  @override
  State<MyVisitasScreen> createState() => MysVisitasScreenState();
}

bool isChecked = false;

class MysVisitasScreenState extends State<MyVisitasScreen> {
  int filtrar = 1;
  List<int> listIdVisita = <int>[];
  clearValues() {
    setState(() {
      listIdVisita.clear();
      isChecked = false;
    });
  }

  Future apiVisitar() {
    return ConstsFuture.changeApi(
        'lista_visitantes/?fn=listarVisitantes&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}&idunidade=${InfosMorador.idunidade}&confirmado=${filtrar == 0 ? 0 : 1}&autorizado=${filtrar == 0 ? 0 : filtrar == 1 ? 0 : 1}');
  }

  @override
  void initState() {
    apiVisitar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          clearValues();
        });
      },
      child: buildScaffoldAll(context,
          title: 'Minhas Visitas',
          body: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    filtrar == 0
                        ? ConstsWidget.buildCustomButton(
                            context,
                            'Convites',
                            rowSpacing: SplashScreen.isSmall ? 0.01 : 0.015,
                            fontSize: 15,
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                filtrar = 0;
                                listIdVisita.clear();
                                isChecked = false;
                              });
                            },
                          )
                        : ConstsWidget.buildOutlinedButton(
                            context,
                            title: 'Convites',
                            fontSize: 15,
                            rowSpacing: SplashScreen.isSmall ? 0.017 : 0.033,
                            onPressed: () {
                              setState(() {
                                filtrar = 0;
                                listIdVisita.clear();
                                isChecked = false;
                              });
                            },
                          ),
                    filtrar == 1
                        ? ConstsWidget.buildCustomButton(
                            context,
                            'Pendentes',
                            rowSpacing: SplashScreen.isSmall ? 0.01 : 0.0155,
                            fontSize: 15,
                            color: Consts.kColorAmarelo,
                            onPressed: () {
                              setState(() {
                                filtrar = 1;
                                listIdVisita.clear();
                                isChecked = false;
                              });
                            },
                          )
                        : ConstsWidget.buildOutlinedButton(
                            context,
                            title: 'Pendentes',
                            fontSize: 15,
                            rowSpacing: SplashScreen.isSmall ? 0.01 : 0.03,
                            onPressed: () {
                              setState(() {
                                filtrar = 1;
                                listIdVisita.clear();
                                isChecked = false;
                              });
                            },
                          ),
                    filtrar == 2
                        ? ConstsWidget.buildCustomButton(
                            context,
                            'Autorizados',
                            rowSpacing: SplashScreen.isSmall ? 0.001 : 0.002,
                            fontSize: SplashScreen.isSmall ? 14 : 15,
                            color: Consts.kColorVerde,
                            onPressed: () {
                              setState(() {
                                filtrar = 2;
                                clearValues();
                              });
                            },
                          )
                        : ConstsWidget.buildOutlinedButton(
                            context,
                            title: 'Autorizados',
                            rowSpacing: SplashScreen.isSmall ? 0.002 : 0.0035,
                            fontSize: SplashScreen.isSmall ? 14 : 15,
                            onPressed: () {
                              setState(() {
                                filtrar = 2;
                                clearValues();
                              });
                            },
                          ),
                  ],
                ),
              ),
              if (filtrar == 1 || filtrar == 2)
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    filtrar == 1 ? 'Autorizar Visita' : 'Cancelar Visita',
                    color: Consts.kColorRed,
                    onPressed: () {
                      if (listIdVisita.isNotEmpty) {
                        showDialogAll(context,
                            title: ConstsWidget.buildTextTitle(
                                context,
                                filtrar == 1
                                    ? 'Autorizar Visita'
                                    : 'Cancelar Visita'),
                            children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: 'Tem certeza que deseja ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                      children: [
                                        TextSpan(
                                          text: filtrar == 1
                                              ? 'Autorizar '
                                              : 'Cancelar',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color),
                                        ),
                                        TextSpan(
                                          text: ' esta solicitação de visita',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color),
                                        ),
                                      ])),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ConstsWidget.buildOutlinedButton(
                                    context,
                                    rowSpacing:
                                        SplashScreen.isSmall ? 0.09 : 0.1,
                                    title: 'Não',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ConstsWidget.buildCustomButton(
                                    context,
                                    'Sim',
                                    color: Consts.kColorRed,
                                    rowSpacing:
                                        SplashScreen.isSmall ? 0.051 : 0.054,
                                    onPressed: () {
                                      ConstsFuture.changeApi(
                                              'lista_visitantes/?fn=autorizarVisitante&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}&idunidade=${InfosMorador.idunidade}&listavisita=${listIdVisita.join(',')}&autorizado=${filtrar == 1 ? 1 : 0}')
                                          .then((value) {
                                        if (!value['erro']) {
                                          Navigator.pop(context);
                                          clearValues();

                                          buildCustomSnackBar(context,
                                              titulo: 'Obrigado',
                                              texto: value['mensagem']);
                                          setState(() {});
                                        } else {
                                          buildCustomSnackBar(context,
                                              titulo: 'Algo saiu mal!',
                                              hasError: true,
                                              texto: value['mensagem']);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ]);
                      } else {
                        buildCustomSnackBar(context,
                            titulo: 'Cuidado!',
                            hasError: true,
                            texto: 'Selecione pelo menos uma solicitação');
                      }
                    },
                  ),
                ),
              FutureBuilder(
                future: apiVisitar(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingCorresp();
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data['ListaVisitantes'].length,
                        itemBuilder: (context, index) {
                          var apiVisitante =
                              snapshot.data['ListaVisitantes'][index];
                          var idvisita = apiVisitante['idvisita'];
                          int? idcond = apiVisitante['idcond'];
                          String? nome_condominio =
                              apiVisitante['nome_condominio'];
                          int? idunidade = apiVisitante['idunidade'];
                          String? unidade = apiVisitante['unidade'];
                          String? convidado_por = apiVisitante['convidado_por'];
                          String? email = apiVisitante['email'];
                          int? idmorador = apiVisitante['idmorador'];
                          String? nome_convidado =
                              apiVisitante['nome_convidado'];
                          String? doc_convidado = apiVisitante['doc_convidado'];
                          String? acompanhante = apiVisitante['acompanhante'];
                          String? datahora_visita =
                              DateFormat('dd/MM/yyyy • HH:mm').format(
                                  DateTime.parse(
                                      apiVisitante['datahora_visita']));
                          String? datahora_enviado =
                              DateFormat('dd/MM/yyyy • HH:mm').format(
                                  DateTime.parse(
                                      apiVisitante['datahora_enviado']));
                          bool confirmado = apiVisitante['confirmado'];
                          bool autorizado = apiVisitante['autorizado'];
                          bool compareceu = apiVisitante['autorizado'];

                          // Duration difference = DateTime.now().difference(
                          //     DateTime.parse(apiVisitante['datahora_visita']));
                          // bool isExpired = difference > Duration(seconds: 1);

                          return MyBoxShadow(
                              child: ConstsWidget.buildPadding001(
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!confirmado && !autorizado)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildTextSubTitle(
                                          context, 'Convite Enviado para'),
                                      SizedBox(
                                        width: size.width * 0.9,
                                        child: ConstsWidget.buildTextTitle(
                                          context,
                                          email!,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      ConstsWidget.buildTextSubTitle(
                                          context, 'Data e Hora do Envio'),
                                      ConstsWidget.buildTextTitle(
                                        context,
                                        datahora_enviado,
                                      )
                                    ],
                                  ),
                                if (nome_convidado != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildTextSubTitle(
                                          context, 'Nome do Convidado'),
                                      ConstsWidget.buildTextTitle(
                                          context, nome_convidado),
                                    ],
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // if (nome_convidado != null)

                                    // if (!confirmado && !autorizado)
                                    //   Column(
                                    //     children: [
                                    //       ConstsWidget.buildTextTitle(context,
                                    //           'Já foi enviado convite para'),
                                    //       ConstsWidget.buildTextSubTitle(
                                    //           context, email!),
                                    //     ],
                                    //   ),
                                    if (nome_convidado != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Column(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     ConstsWidget.buildTextSubTitle(
                                          //         context, 'Nome convidado'),
                                          //     ConstsWidget.buildTextTitle(
                                          //         context, nome_convidado),
                                          //   ],
                                          // ),

                                          ConstsWidget.buildPadding001(
                                            context,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ConstsWidget.buildTextSubTitle(
                                                    context,
                                                    'Convite Enviado para'),
                                                ConstsWidget.buildTextTitle(
                                                    context, email!),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstsWidget.buildTextSubTitle(
                                                  context,
                                                  'Documento do Convidado'),
                                              ConstsWidget.buildTextTitle(
                                                  context, doc_convidado!),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: size.height * 0.01,
                                          // ),
                                          if (acompanhante != '')
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ConstsWidget.buildTextSubTitle(
                                                    context,
                                                    'Nome Acompanhate'),
                                                ConstsWidget.buildTextTitle(
                                                    context, acompanhante!),
                                              ],
                                            ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstsWidget.buildTextSubTitle(
                                            context, 'Visita Agendada para'),
                                        ConstsWidget.buildTextTitle(
                                            context, datahora_visita),
                                      ],
                                    ),
                                    if (filtrar != 0)
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return ConstsWidget.buildCheckBox(
                                          context,
                                          isChecked: isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              isChecked = value!;
                                              value
                                                  ? listIdVisita.add(idvisita)
                                                  : listIdVisita
                                                      .remove(idvisita);
                                            });
                                          },
                                          title: 'Selecionar Visita',
                                        );
                                      }),

                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceEvenly,
                                    //   children: [
                                    //     Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         ConstsWidget.buildTextSubTitle(
                                    //             context, 'confirmado'),
                                    //         ConstsWidget.buildTextTitle(
                                    //           context,
                                    //           confirmado,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         ConstsWidget.buildTextSubTitle(
                                    //             context, 'autorizado'),
                                    //         ConstsWidget.buildTextTitle(
                                    //             context, autorizado.toString()),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ));
                        },
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: PageVazia(title: snapshot.data['mensagem']),
                      );
                    }
                  } else {
                    return PageErro();
                  }
                },
              ),
            ],
          )),
    );
  }
}
