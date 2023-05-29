import 'dart:async';
import 'dart:convert';
import 'package:app_portaria/itens_bottom.dart';
import 'package:app_portaria/notifications/notifi_service_delivery.dart';
import 'package:app_portaria/notifications/notifi_service_visitas.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../notifications/notifi_service.dart';
import '../notifications/notifi_service_corresp.dart';
import '../repositories/shared_preferences.dart';
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
    // NotificationServiceCorresp().notificationDetailsCorresp();
    // NotificationServiceDelivery().notificationDetailsDelivery();
    // NotificationServiceVisitas().notificationDetailsVisitas();
    // NotificationDetailsAvisos().notificationDetailsAvisos();
    // NotificationServiceCorresp.initNotificationCorresp();
    // NotificationServiceCorresp.notificationDetailsCorresp();
    var senhacripto = md5.convert(utf8.encode(senha)).toString();
    Timer(Duration(hours: 1), () {
      LocalPreferences.removeUserLogin();
    });
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-morador/?fn=login-morador&usuario=$user&senha=$senhacripto');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];
      var apiInfos = apiBody['login'][0];
      if (!erro) {
        InfosMorador.idmorador = apiInfos['id'];
        InfosMorador.ativo = apiInfos['ativo'];
        InfosMorador.idcondominio = apiInfos['idcondominio'];
        InfosMorador.idunidade = apiInfos['idunidade'];
        InfosMorador.nome_condominio = apiInfos['nome_condominio'];
        InfosMorador.nome_morador = apiInfos['nome_morador'];
        InfosMorador.unidade = apiInfos['unidade'];
        InfosMorador.divisao = apiInfos['divisao'];
        InfosMorador.login = apiInfos['login'];
        InfosMorador.documento = apiInfos['documento'];
        InfosMorador.telefone = apiInfos['telefone'];
        InfosMorador.email = apiInfos['email'];
        InfosMorador.data_nascimento = apiInfos['data_nascimento'];
        InfosMorador.acessa_sistema = apiInfos['acessa_sistema'];
        InfosMorador.datahora_cadastro = apiInfos['datahora_cadastro'];
        InfosMorador.telefone_portaria = apiInfos['telefone_portaria'];
        InfosMorador.datahora_ultima_atualizacao =
            apiInfos['datahora_ultima_atualizacao'];
        ConstsFuture.navigatorPopAndPush(context, ItensBottom(currentTab: 0));
      } else {
        ConstsFuture.navigatorPopAndPush(context, LoginScreen());
        buildCustomSnackBar(context,
            titulo: "Algo deu errado!!", texto: apiBody['mensagem']);
      }
    }
  }
}
