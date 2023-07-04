import 'dart:async';
import 'dart:convert';
import 'package:app_portaria/screens/home/home_page.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../repositories/shared_preferences.dart';
import '../screens/home/dropAptos.dart';
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

  static Future navigatorPopAndReplacement(
      BuildContext context, Widget pageRoute) {
    Navigator.pop(context);
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => pageRoute,
      ),
    );
  }

  static Future criptoSenha(String senha) async {
    String senhacripto = md5.convert(utf8.encode(senha)).toString();
    return senhacripto;
  }

  static efetuaLogin(context, String user, String senha, {int? idUnidade}) {
    InfosMorador.user = user;
    criptoSenha(senha).then((senhaCrip) async {
      InfosMorador.senhaCripto = idUnidade == null ? senhaCrip : senha;
      Timer(Duration(hours: 1), () {
        LocalPreferences.removeUserLogin();
      });
      var url = Uri.parse(
          'https://a.portariaapp.com/api/login-morador/?fn=login-morador&usuario=$user&senha=${idUnidade == null ? senhaCrip : InfosMorador.senhaCripto}${idUnidade != null ? '&idunidade=$idUnidade' : ''}');
      var resposta = await http.get(url);
      if (resposta.statusCode == 200) {
        var apiBody = json.decode(resposta.body);
        bool erro = apiBody['erro'];
        if (!erro) {
          if (idUnidade == null) DropAptos.listAptos = apiBody['login'];
          var apiInfos = apiBody['login'][0];
          if (apiInfos['acessa_sistema'] == null ||
              apiInfos['acessa_sistema']) {
            //login morador
            if (idUnidade == null) {
              InfosMorador.qntApto = apiBody['login'].length;
            }
            InfosMorador.responsavel = apiInfos['responsavel'];
            InfosMorador.idmorador = !apiInfos['responsavel']
                ? apiInfos['id']
                : apiInfos['idunidade'];
            InfosMorador.iddivisao = apiInfos['iddivisao'];
            InfosMorador.ativo = apiInfos['ativo'];
            InfosMorador.idcondominio = apiInfos['idcondominio'];
            InfosMorador.idunidade = apiInfos['idunidade'];
            InfosMorador.nome_condominio = apiInfos['nome_condominio'];
            InfosMorador.nome_completo = apiInfos['responsavel']
                ? apiInfos['nome_responsavel']
                : apiInfos['nome_morador'] ?? '';
            InfosMorador.numero = apiInfos['unidade'];
            InfosMorador.divisao = apiInfos['divisao'];
            InfosMorador.login = apiInfos['login'];
            InfosMorador.documento = apiInfos['documento'];
            InfosMorador.telefone = apiInfos['telefone'];
            InfosMorador.dddtelefone = apiInfos['dddtelefone'] ?? '';
            InfosMorador.email = apiInfos['email'] ?? '';
            InfosMorador.data_nascimento = apiInfos['data_nascimento'];
            InfosMorador.acessa_sistema =
                InfosMorador.responsavel ? true : apiInfos['acessa_sistema'];
            InfosMorador.datahora_cadastro = apiInfos['datahora_cadastro'];
            InfosMorador.telefone_portaria = apiInfos['telefone_portaria'];
            InfosMorador.datahora_ultima_atualizacao =
                apiInfos['datahora_ultima_atualizacao'];
          } else {
            buildCustomSnackBar(context,
                titulo: "Algo deu errado!!", texto: 'Você não tem acesso!');

            return navigatorPopAndPush(context, LoginScreen());
          }

          return idUnidade == null
              ? ConstsFuture.navigatorPopAndPush(context, HomePage())
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                  (route) => false);
          // if (apiBody['login'].length >= 1) {
          //   alertDialogTrocarAp(context);
          // }
        } else {
          ConstsFuture.navigatorPopAndPush(context, LoginScreen());
          LocalPreferences.removeUserLogin();
          buildCustomSnackBar(context,
              titulo: "Algo deu errado!!", texto: apiBody['mensagem']);
        }
      }
    });
  }

  static Future<dynamic> changeApi(String api) async {
    var url = Uri.parse(api);
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      try {
        return json.decode(resposta.body);
      } catch (e) {
        return {'erro': true, 'mensagem': 'Tente Novamente'};
      }
    } else {
      return false;
    }
  }

  static Future<Widget> apiImageIcon(String iconApi) async {
    var url = Uri.parse(iconApi);
    var resposta = await http.get(url);

    return resposta.statusCode == 200
        ? Image.network(iconApi)
        : Image.asset('assets/ico-error.png');
  }
}
