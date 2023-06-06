import 'dart:convert';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_future.dart';
import '../../../consts/consts_widget.dart';
import '../../../forms/form_morador.dart';
import '../../../widgets/header.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/my_text_form_field.dart';
import '../../../widgets/page_vazia.dart';
import '../../../widgets/row_infos.dart';
import '../../../widgets/scaffold_all.dart';
import '../listar_total.dart';
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
      children: [
        ConstsWidget.buildCustomButton(
          context,
          'Adicionar Morador',
          icon: Icons.add,
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
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: PageVazia(title: snapshot.data['mensagem']),
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
                            title1: 'Login:',
                            subTitle1: login,
                            title2: 'Telefone:',
                            subTitle2: '($ddd) $telefone'),
                        buildRowInfos(context,
                            title1: 'Documento:',
                            subTitle1: documento,
                            title2: 'Nascimento:',
                            subTitle2: DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(
                                    bodyMorador['data_nascimento']))),
                        ConstsWidget.buildTextSubTitle(context, 'Email:'),
                        ConstsWidget.buildTextTitle(context, email),
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
                                email: email,
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
    );
  }
}
