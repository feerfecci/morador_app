import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_all.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_erro.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:app_portaria/widgets/shimmer.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Convidados',
                      fontSize: 18,
                      backgroundColor: filtrar == 0 ? Colors.grey[300] : null,
                      onPressed: () {
                        setState(() {
                          filtrar = 0;
                          listIdVisita.clear();
                          isChecked = false;
                        });
                      },
                    ),
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Confirmados',
                      fontSize: 18,
                      backgroundColor: filtrar == 1 ? Colors.grey[300] : null,
                      onPressed: () {
                        setState(() {
                          filtrar = 1;
                          listIdVisita.clear();
                          isChecked = false;
                        });
                      },
                    ),
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Autorizados',
                      fontSize: 18,
                      backgroundColor: filtrar == 2 ? Colors.grey[300] : null,
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
                    filtrar == 1 ? 'Confirmar' : 'Anular',
                    color: Consts.kColorRed,
                    onPressed: () {
                      if (listIdVisita.isNotEmpty) {
                        showDialogAll(context,
                            title: 'Confirmar Visita',
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: 'Tem certeza de deseja ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      children: [
                                    TextSpan(
                                      text: filtrar == 1
                                          ? 'Confirmar '
                                          : 'Anular ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    TextSpan(
                                      text: 'esta solicitação de visita',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ])),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Spacer(
                                    flex: 2,
                                  ),
                                  ConstsWidget.buildOutlinedButton(
                                    context,
                                    title: 'Cancelar',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Spacer(),
                                  ConstsWidget.buildCustomButton(
                                    context,
                                    filtrar == 1 ? 'Confirmar ' : 'Anular ',
                                    color: Consts.kColorRed,
                                    onPressed: () {
                                      // print(listIdVisita);
                                      ConstsFuture.changeApi(
                                              'lista_visitantes/?fn=autorizarVisitante&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&listavisita=${listIdVisita.join(',')}&autorizado=${filtrar == 1 ? 1 : 0}')
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
                                              titulo: 'Algo saiu mau!',
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
                            texto: 'Selecione pelo menos uma solicitação');
                      }
                    },
                  ),
                ),
              FutureBuilder(
                future: ConstsFuture.changeApi(
                    'lista_visitantes/?fn=listarVisitantes&idcond=${InfosMorador.idcondominio}&idunidade=45&confirmado=${filtrar == 0 ? 0 : 1}&autorizado=${filtrar == 0 ? 0 : filtrar == 1 ? 0 : 1}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerWidget(height: size.height * 0.01);
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
                              DateFormat('dd/MM/yyyy HH:mm').format(
                                  DateTime.parse(
                                      apiVisitante['datahora_visita']));
                          bool confirmado = apiVisitante['confirmado'];
                          bool autorizado = apiVisitante['autorizado'];
                          bool compareceu = apiVisitante['autorizado'];

                          return MyBoxShadow(
                              child: ConstsWidget.buildPadding001(
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                if (!confirmado && !autorizado)
                                  Column(
                                    children: [
                                      ConstsWidget.buildTextTitle(context,
                                          'Já foi enviado convite para'),
                                      ConstsWidget.buildTextSubTitle(
                                          context, email!),
                                    ],
                                  ),
                                if (nome_convidado != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstsWidget.buildTextSubTitle(
                                              context, 'Nome convidado'),
                                          ConstsWidget.buildTextTitle(
                                              context, nome_convidado),
                                        ],
                                      ),
                                      ConstsWidget.buildPadding001(
                                        context,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ConstsWidget.buildTextSubTitle(
                                                    context,
                                                    'Email Cadastrado'),
                                                ConstsWidget.buildTextTitle(
                                                    context, email!),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ConstsWidget.buildTextSubTitle(
                                                    context,
                                                    'Documento convidado'),
                                                ConstsWidget.buildTextTitle(
                                                    context, doc_convidado!),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (acompanhante != '')
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstsWidget.buildTextSubTitle(
                                                context, 'Nome Acompanhate'),
                                            ConstsWidget.buildTextTitle(
                                                context, acompanhante!),
                                          ],
                                        ),
                                    ],
                                  ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        context, 'Data da Visita'),
                                    ConstsWidget.buildTextTitle(
                                        context, datahora_visita),
                                  ],
                                ),
                                if (filtrar != 0)
                                  StatefulBuilder(builder: (context, setState) {
                                    return ConstsWidget.buildCheckBox(context,
                                        isChecked: isChecked,
                                        onChanged: (value) {
                                      setState(() {
                                        isChecked = value!;
                                        value
                                            ? listIdVisita.add(idvisita)
                                            : listIdVisita.remove(idvisita);
                                        print(listIdVisita);
                                      });
                                    }, title: 'Selecionar Visita');
                                  })

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
                          ));
                        },
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
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
