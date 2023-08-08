// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:app_portaria/screens/cadastro/loading_cadastro.dart';
import 'package:app_portaria/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_future.dart';
import '../../../consts/consts_widget.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/page_erro.dart';
import '../../../widgets/page_vazia.dart';
import '../../../widgets/row_infos.dart';
import 'cadastro_morador.dart';

class ListarMorador extends StatefulWidget {
  const ListarMorador({super.key});

  @override
  State<ListarMorador> createState() => _ListarMoradorState();
}

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

class _ListarMoradorState extends State<ListarMorador> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      // shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: [
        ConstsWidget.buildPadding001(
          context,
          child: ConstsWidget.buildCustomButton(
            context,
            color: Consts.kColorRed,
            'Adicionar Morador',
            icon: Icons.add,
            onPressed: () {
              ConstsFuture.navigatorPageRoute(context, CadastroMorador());
            },
          ),
        ),
        FutureBuilder<dynamic>(
          future: apiMoradores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingCadastro();
            } else if (snapshot.hasData) {
              if (!snapshot.data['erro']) {
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
                    var email = bodyMorador['email'];
                    var acessa_sistema = bodyMorador['acessa_sistema'];
                    var data_nascimento = bodyMorador['data_nascimento'];
                    return MyBoxShadow(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstsWidget.buildTextTitle(context, nome_morador),
                            ConstsWidget.buildAtivoInativo(context, ativo),
                          ],
                        ),
                        buildRowInfos(context,
                            title1: 'Login',
                            subTitle1: login,
                            title2: 'Telefone',
                            subTitle2: '($ddd) $telefone'),
                        buildRowInfos(context,
                            title1: 'Documento',
                            subTitle1: documento,
                            title2: 'Nascimento',
                            subTitle2: DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(
                                    bodyMorador['data_nascimento']))),
                        ConstsWidget.buildTextSubTitle(context, 'Email'),
                        ConstsWidget.buildTextTitle(context, email),
                        StatefulBuilder(builder: (context, setState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstsWidget.buildCheckBox(context,
                                  isChecked: acessa_sistema,
                                  onChanged: (bool? value) {},
                                  title: 'Permitir acesso ao sistema')
                            ],
                          );
                        }),
                        ConstsWidget.buildCustomButton(
                            context, 'Editar Morador', onPressed: () {
                          ConstsFuture.navigatorPageRoute(
                              context,
                              CadastroMorador(
                                idunidade: idunidade,
                                iddivisao: iddivisao,
                                idmorador: idmorador,
                                email: email,
                                nome_completo: nome_morador,
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
              } else {
                return ConstsWidget.buildPadding001(
                  context,
                  child: PageVazia(title: snapshot.data['mensagem']),
                );
              }
            } else {
              return PageErro();
            }
          },
        ),
      ],
    );
  }
}
