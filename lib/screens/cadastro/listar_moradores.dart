// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/cadastro/cadastro_morador.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../consts/consts_widget.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/page_vazia.dart';

class ListaMoradores extends StatefulWidget {
  final int? idunidade;
  final String? numero;
  final int? idvisisao;
  const ListaMoradores(
      {super.key, this.idunidade, this.numero, this.idvisisao});

  @override
  State<ListaMoradores> createState() => _ListaMoradoresState();
}

class _ListaMoradoresState extends State<ListaMoradores> {
  Future apiMoradores() async {
    var url = Uri.parse(
        'https://a.portariaapp.com/unidade/api/moradores/?fn=listarMoradores&idunidade=${InfosMorador.idunidade}&idcond=${InfosMorador.idcondominio}');
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

    Widget buildInfosMorador(
        {required String title1,
        required String subTitle1,
        required String title2,
        required String subTitle2}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(title1),
                ConstsWidget.buildTextTitle(context, subTitle1),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(title2),
                ConstsWidget.buildTextTitle(context, subTitle2),
              ],
            ),
          ],
        ),
      );
    }

    return buildScaffoldAll(
      context,
      body: buildHeaderPage(
        context,
        titulo: 'Cadastro',
        subTitulo: '${InfosMorador.divisao} - ${InfosMorador.numero}',
        widget: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            ConstsWidget.buildCustomButton(
              context,
              'Adicionar Morador',
              onPressed: () {
                ConstsFuture.navigatorPageRoute(context, CadastroMorador());
              },
            ),
            FutureBuilder<dynamic>(
              future: apiMoradores(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Algo deu errado');
                } else {
                  if (snapshot.hasData && snapshot.data['erro']) {
                    return Column(
                      children: [
                        Text(snapshot.data['mensagem']),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['morador'].length,
                      itemBuilder: (context, index) {
                        var bodyMorador = snapshot.data['morador'][index];
                        var idmorador = bodyMorador['idmorador'];
                        var idunidade = bodyMorador['idunidade'];
                        var idcondominio = bodyMorador['idcondominio'];
                        var iddivisao = bodyMorador['iddivisao'];
                        var ativo = bodyMorador['ativo'];
                        var nome_condominio = bodyMorador['nome_condominio'];
                        var nome_divisao = bodyMorador['nome_divisao'];
                        var dividido_por = bodyMorador['dividido_por'];
                        var numero = bodyMorador['numero'];
                        var nome_morador = bodyMorador['nome_morador'];
                        var login = bodyMorador['login'];
                        var documento = bodyMorador['documento'];
                        var ddd = bodyMorador['ddd'];
                        var telefone = bodyMorador['telefone'];
                        var acessa_sistema = bodyMorador['acessa_sistema'];
                        var data_nascimento = bodyMorador['data_nascimento'];
                        return MyBoxShadow(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstsWidget.buildTextTitle(
                                    context, nome_morador),
                                ConstsWidget.buildAtivoInativo(context, ativo),
                              ],
                            ),
                            buildInfosMorador(
                                title1: 'Login:',
                                subTitle1: login,
                                title2: 'Telefone:',
                                subTitle2: '($ddd) $telefone'),
                            buildInfosMorador(
                                title1: 'Documento:',
                                subTitle1: documento,
                                title2: 'Nascimento:',
                                subTitle2: DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(
                                        bodyMorador['data_nascimento']))),
                            ListTile(
                              title: ConstsWidget.buildTextTitle(
                                  context, 'Permitir acesso ao sistema'),
                              trailing:
                                  StatefulBuilder(builder: (context, setState) {
                                return SizedBox(
                                    width: size.width * 0.125,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Checkbox(
                                            value: acessa_sistema,
                                            activeColor: Consts.kColorApp,
                                            onChanged: (bool? value) {}),
                                      ],
                                    ));
                              }),
                            ),
                            ConstsWidget.buildCustomButton(
                                context, 'Editar Morador', onPressed: () {
                              ConstsFuture.navigatorPageRoute(
                                  context,
                                  CadastroMorador(
                                    idunidade: idunidade,
                                    iddivisao: iddivisao,
                                    idmorador: idmorador,
                                    nome_morador: nome_morador,
                                    login: login,
                                    numero: numero,
                                    ativo: ativo,
                                    nascimento: data_nascimento,
                                    documento: documento,
                                    ddd: ddd,
                                    telefone: telefone,
                                    acesso: acessa_sistema ? 1 : 0,
                                  ));
                            })
                          ],
                        ));
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
