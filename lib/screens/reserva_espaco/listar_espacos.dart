// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/reserva_espaco/fazer_reserva.dart';
import 'package:app_portaria/screens/reserva_espaco/listar_reserva.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_erro.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import '../../consts/consts_widget.dart';
import '../correspondencia/loading_corresp.dart';

class ListarEspacos extends StatefulWidget {
  const ListarEspacos({super.key});

  @override
  State<ListarEspacos> createState() => ListarEspacosState();
}

class ListarEspacosState extends State<ListarEspacos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Future apiListarEspacos() {
      //print('listarEspacos');
      return ConstsFuture.changeApi(
          'reserva_espacos/?fn=listarEspacos&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}');
    }

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {});
      },
      child: buildScaffoldAll(context,
          title: 'Reservar Espaços',
          body: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.005, bottom: size.height * 0.02),
                child: ConstsWidget.buildCustomButton(
                    context, 'Minhas Solicitações',
                    // icon: Icons.content_paste_go,
                    color: Consts.kColorAzul,
                    onPressed: () => ConstsFuture.navigatorPageRoute(
                        context, ListarReservas())),
              ),
              FutureBuilder<dynamic>(
                future: apiListarEspacos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingCorresp();
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data['lista_espacos'].length,
                        itemBuilder: (context, index) {
                          var apiEspacos =
                              snapshot.data['lista_espacos'][index];
                          bool? ativo = apiEspacos['ativo'];
                          int? idespaco = apiEspacos['idespaco'];
                          String nome_espaco = apiEspacos['nome_espaco'];
                          int? idcondominio = apiEspacos['idcondominio'];
                          String? descricao = apiEspacos['descricao'];
                          List datas_reservadas_ini =
                              apiEspacos['datas_ini_reservadas'];
                          List datas_reservadas_fim =
                              apiEspacos['datas_fim_reservadas'];

                          return MyBoxShadow(
                            child: Column(
                              children: [
                                // buildTextoEspaco(
                                //   titulo: 'id:',
                                //   texto: idespaco.toString(),
                                // // ),
                                // buildTextoEspaco(
                                //   titulo: 'Nome do Espaço',
                                //   texto: nome_espaco.toString(),
                                // ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                SizedBox(
                                  width: size.height * 0.9,
                                  child: ConstsWidget.buildTextTitle(
                                      context, nome_espaco,
                                      size: 20, textAlign: TextAlign.center),
                                ),
                                ConstsWidget.buildPadding001(
                                  context,
                                  child: ConstsWidget.buildTextSubTitle(
                                      context, descricao!,
                                      textAlign: TextAlign.center, size: 16),
                                ),
                                ConstsWidget.buildPadding001(
                                  context,
                                  child: ConstsWidget.buildTextSubTitle(
                                      context, idespaco.toString(),
                                      textAlign: TextAlign.center, size: 16),
                                ),
                                ConstsWidget.buildPadding001(
                                  context,
                                  child: ConstsWidget.buildCustomButton(
                                    context,
                                    'Solicitar Reserva',
                                    color: Consts.kColorRed,
                                    // icon: Icons.calendar_month_outlined,
                                    onPressed: () {
                                      ConstsFuture.navigatorPageRoute(
                                        context,
                                        FazerReserva(
                                          idespaco: idespaco!,
                                          dataReservadaIni:
                                              datas_reservadas_ini,
                                          dataReservadaFim:
                                              datas_reservadas_fim,
                                          nomeEspaco: nome_espaco.toString(),
                                          descricaoEspaco: descricao.toString(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return PageVazia(
                          title: 'Não há espaços para alugar no condomínio');
                    }
                  } else {
                    return PageErro();
                  }
                },
              )
            ],
          )),
    );
  }
}
