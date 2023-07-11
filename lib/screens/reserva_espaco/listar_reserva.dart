// ignore_for_file: non_constant_identifier_names, unused_local_variable
import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/page_erro.dart';

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
      return ConstsWidget.buildPadding001(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstsWidget.buildTextSubTitle(context, titulo),
            ConstsWidget.buildTextTitle(context, texto),
          ],
        ),
      );
    }

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          ConstsFuture.changeApi(
              '${Consts.apiUnidade}reserva_espacos/?fn=listarReservas&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}');
        });
      },
      child: buildScaffoldAll(context,
          title: 'Minhas Solicitações',
          body: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
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
                            child: ListView(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              // crossAxisAlignment: CrossAxisAlignment.start,
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
                                              ? Colors.grey
                                              : status == 1
                                                  ? Consts.kColorVerde
                                                  : Consts.kColorAmarelo,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(size.height * 0.01),
                                        child: ConstsWidget.buildTextTitle(
                                            context, texto_status,
                                            color: Colors.white),
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
                      return PageVazia(
                          title: 'Não há reservas para esta unidade');
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
