import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/reserva_espaco/fazer_reserva.dart';
import 'package:app_portaria/screens/reserva_espaco/listar_reserva.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../consts/consts_widget.dart';

class ListarEspacos extends StatefulWidget {
  const ListarEspacos({super.key});

  @override
  State<ListarEspacos> createState() => ListarEspacosState();
}

class ListarEspacosState extends State<ListarEspacos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTextoEspaco({required titulo, required texto}) {
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
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              ConstsFuture.changeApi(
                  '${Consts.apiUnidade}reserva_espacos/?fn=listarEspacos&idcond=${InfosMorador.idcondominio}');
            });
          },
          color: Colors.transparent,
          child: buildHeaderPage(context,
              titulo: 'Reservar Espaços',
              subTitulo: 'Solicite um espaço',
              widget: Column(
                children: [
                  ConstsWidget.buildCustomButton(context, 'Minhas Solicitações',
                      onPressed: () => ConstsFuture.navigatorPageRoute(
                          context, ListarReservas())),
                  FutureBuilder<dynamic>(
                    future: ConstsFuture.changeApi(
                        '${Consts.apiUnidade}reserva_espacos/?fn=listarEspacos&idcond=${InfosMorador.idcondominio}'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
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
                              String? nome_espaco = apiEspacos['nome_espaco'];
                              int? idcondominio = apiEspacos['idcondominio'];
                              String? descricao = apiEspacos['descricao'];
                              return MyBoxShadow(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildTextoEspaco(
                                      titulo: 'id:',
                                      texto: idespaco.toString(),
                                    ),
                                    buildTextoEspaco(
                                      titulo: 'Nome do Escpaço:',
                                      texto: nome_espaco.toString(),
                                    ),
                                    buildTextoEspaco(
                                      titulo: 'Descrição:',
                                      texto: descricao.toString(),
                                    ),
                                    ConstsWidget.buildCustomButton(
                                      context,
                                      'Solicitar',
                                      onPressed: () {
                                        ConstsFuture.navigatorPageRoute(
                                            context,
                                            FazerReserva(
                                                idespaco: idespaco!,
                                                nomeEspaco:
                                                    nome_espaco.toString(),
                                                descricaoEspaco:
                                                    descricao.toString()));
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Text('Não há nada');
                        }
                      } else {
                        return Text('Algo deu errado');
                      }
                    },
                  )
                ],
              )),
        ));
  }
}
