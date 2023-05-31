// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../../consts/consts_widget.dart';

class QuadroAvisosScreen extends StatefulWidget {
  const QuadroAvisosScreen({super.key});

  @override
  State<QuadroAvisosScreen> createState() => _QuadroAvisosScreenState();
}

class _QuadroAvisosScreenState extends State<QuadroAvisosScreen> {
  Future apiQuadroAvisos() async {
    var url = Uri.parse(
        '${Consts.apiUnidade}/quadro_avisos/index.php?fn=listarAvisos&idcond=${InfosMorador.idcondominio}');
    var resposta = await get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      body: buildHeaderPage(context,
          titulo: 'Quadro de Avisos',
          subTitulo: 'Confira as novidade',
          widget: FutureBuilder<dynamic>(
              future: apiQuadroAvisos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Algo deu errado');
                } else {
                  if (snapshot.data['erro']) {
                    return PageVazia(title: snapshot.data['mensagem']);
                  } else {
                    return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data['avisos'].length,
                      itemBuilder: (context, index) {
                        var apiQuadro = snapshot.data['avisos'][index];
                        var idaviso = apiQuadro['idaviso'];
                        var tipo = apiQuadro['tipo'];
                        var titulo = apiQuadro['titulo'];
                        var txt_tipo = apiQuadro['txt_tipo'];
                        var texto = apiQuadro['texto'];
                        var datahora = DateFormat('dd/MM/yyyy HH:mm')
                            .format(DateTime.parse(apiQuadro['datahora']));
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01),
                          child: ListTile(
                            leading: SizedBox(
                              width: size.height * 0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  txt_tipo == 'Manutenção'
                                      ? Icon(
                                          Icons.engineering,
                                          size: 40,
                                        )
                                      : Icon(
                                          Icons.warning,
                                          size: 40,
                                        ),
                                  ConstsWidget.buildTextSubTitle(txt_tipo)
                                ],
                              ),
                            ),
                            title: ConstsWidget.buildTextTitle(context, titulo),
                            subtitle: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildTextSubTitle(texto),
                                  ConstsWidget.buildTextSubTitle(datahora),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              })),
    );
  }
}
