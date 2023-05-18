import 'dart:convert';
import 'package:app_portaria/itens_bottom.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../widgets/snack_bar.dart';
import 'consts.dart';

class ConstsFuture {
  static Future navigatorPageRoute(BuildContext context, Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => route,
    ));
  }

  static Future navigatorPopAndPush(BuildContext context, Widget pageRoute) {
    Navigator.pop(context);
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pageRoute,
      ),
    );
  }

  static efetuaLogin(context, String user, String senha) async {
    var senhacripto = md5.convert(utf8.encode(senha)).toString();
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-morador/?fn=login-morador&usuario=$user&senha=$senhacripto');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];
      if (!erro) {
        InfosMorador.id = apiBody['login'][0]['id'];
        InfosMorador.ativo = apiBody['login'][0]['ativo'];
        InfosMorador.idcondominio = apiBody['login'][0]['idcondominio'];
        InfosMorador.nome_condominio = apiBody['login'][0]['nome_condominio'];
        InfosMorador.nome_morador = apiBody['login'][0]['nome_morador'];
        InfosMorador.unidade = apiBody['login'][0]['unidade'];
        InfosMorador.divisao = apiBody['login'][0]['divisao'];
        InfosMorador.login = apiBody['login'][0]['login'];
        InfosMorador.documento = apiBody['login'][0]['documento'];
        InfosMorador.telefone = apiBody['login'][0]['telefone'];
        InfosMorador.data_nascimento = apiBody['login'][0]['data_nascimento'];
        InfosMorador.acessa_sistema = apiBody['login'][0]['acessa_sistema'];
        InfosMorador.datahora_cadastro =
            apiBody['login'][0]['datahora_cadastro'];
        InfosMorador.datahora_ultima_atualizacao =
            apiBody['login'][0]['datahora_ultima_atualizacao'];
        ConstsFuture.navigatorPopAndPush(context, ItensBottom(currentTab: 0));
      } else {
        buildCustomSnackBar(context, "Algo deu errado!!", apiBody['mensagem']);
      }
    }
  }
}
