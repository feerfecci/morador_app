import 'dart:async';
import 'dart:convert';
import 'package:app_portaria/screens/home/home_page.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../repositories/shared_preferences.dart';
import '../screens/cadastro/morador/cadastro_morador.dart';
import '../screens/termodeuso/aceitar_alert.dart';
import '../screens/correspondencia/correspondencia_screen.dart';
import '../screens/home/dropAptos.dart';
import '../screens/quadro_avisos/quadro_avisos_screen.dart';
import '../widgets/alert_dialog/alert_all.dart';
import '../widgets/snack_bar.dart';
import 'consts.dart';
import 'consts_widget.dart';

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

  static Future efetuaLogin(context, String user, String senha,
      {String? idUnidade, bool reLogin = false}) async {
    alertSenhaPadrao() {
      if (!InfosMorador.senha_alterada) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialogAll(
              title: Stack(
                alignment: Alignment.center,
                children: [
                  ConstsWidget.buildTextTitle(context, 'Senha Padrão',
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close)),
                    ],
                  )
                ],
              ),
              children: [
                ConstsWidget.buildTextTitle(context,
                    'Sua senha é a padrão. Acesse seu Perfil para trocar para uma senha personalizada e garantir sua segurança',
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                ConstsWidget.buildCustomButton(
                  context,
                  'Trocar Senha',
                  onPressed: () => ConstsFuture.navigatorPopAndPush(
                      context,
                      CadastroMorador(
                        idmorador: InfosMorador.idmorador,
                        iddivisao: InfosMorador.iddivisao,
                        idunidade: InfosMorador.idunidade,
                        numero: InfosMorador.numero,
                        login: InfosMorador.login,
                        documento: InfosMorador.documento,
                        acesso: InfosMorador.acessa_sistema ? 1 : 0,
                        ativo: InfosMorador.ativo,
                        ddd: InfosMorador.dddtelefone,
                        telefone: InfosMorador.telefone,
                        email: InfosMorador.email,
                        nascimento: InfosMorador.data_nascimento,
                        nome_completo: InfosMorador.nome_completo,
                        isDrawer: true,
                      )),
                )
              ]),
        );
      }
    }

    CorrespondenciaScreen.listaNovaCorresp3.clear();
    CorrespondenciaScreen.listaNovaCorresp4.clear();
    InfosMorador.user = user;
    criptoSenha(senha).then((senhaCrip) async {
      InfosMorador.senhaCripto = idUnidade == null
          ? senhaCrip
          : reLogin
              ? senhaCrip
              : senha;
      // Timer(Duration(hours: 1), () {
      //   LocalPreferences.removeUserLogin();
      // });
      var url = Uri.parse(
          'https://a.portariaapp.com/api/login-morador/?fn=login-morador&usuario=$user&senha=${idUnidade == null ? senhaCrip : InfosMorador.senhaCripto}${idUnidade != null ? '&idunidade=$idUnidade' : ''}');
      var resposta = await http.get(url);
      if (resposta.statusCode == 200) {
        var apiBody = json.decode(resposta.body);
        bool erro = apiBody['erro'];
        if (!erro && apiBody['mensagem'] != "") {
          if (idUnidade == null) DropAptos.listAptos = apiBody['login'];
          // if (DropAptos.listAptos.length != 1) {
          //   DropAptos.listAptos.map((e) {
          //     String? getIdMorador;
          //     LocalPreferences.getIdLogin().then((value) {
          //       getIdMorador == value;
          //     });
          //     if (DropAptos.listAptos.contains(getIdMorador)) {
          //       print(e);
          //     }
          //   }).toSet();
          // }

          var apiInfos = apiBody['login'][0];
          if (apiInfos['acessa_sistema'] == null ||
              apiInfos['acessa_sistema']) {
            if (idUnidade == null) {
              InfosMorador.listIdMorador.clear();
              InfosMorador.qntApto = 0;
              InfosMorador.qntApto = apiBody['login'].length;
              for (var i = 0; i < InfosMorador.qntApto; i++) {
                InfosMorador.listIdMorador.add(!apiBody['login'][i]
                        ['responsavel']
                    ? apiBody['login'][i]['id'].toString()
                    : apiBody['login'][i]['idunidade'].toString());
                InfosMorador.listIdCond
                    .add(apiBody['login'][i]['idcondominio'].toString());
                InfosMorador.listIdUnidade
                    .add(apiBody['login'][i]['idunidade'].toString());
              }
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
            InfosMorador.qtd_publicidade = apiInfos['qtd_publicidade'];
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
            InfosMorador.tempo_resposta = apiInfos['tempo_respostas'];
            InfosMorador.convida_visita = apiInfos['convida_visita'];
            InfosMorador.aceitou_termos = apiInfos['aceitou_termos'];
            InfosMorador.datahora_ultima_atualizacao =
                apiInfos['datahora_ultima_atualizacao'];
            InfosMorador.senha_alterada = apiInfos['senha_alterada'];
            LocalPreferences.setIdLogin('${InfosMorador.idunidade}');
          } else {
            buildCustomSnackBar(context,
                hasError: true,
                titulo: "Algo deu errado!!",
                texto: 'Você não tem acesso!');

            return navigatorPopAndPush(context, LoginScreen());
          }
          CorrespondenciaScreen.listaNovaCorresp3.clear();
          CorrespondenciaScreen.listaNovaCorresp4.clear();
          QuadroAvisosScreen.qntAvisos.clear();

          return apiListarCorrespondencias(3).whenComplete(() {
            apiListarCorrespondencias(4).whenComplete(() {
              apiQuadroAvisos().whenComplete(() {
                if (!InfosMorador.aceitou_termos) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AceitarTermosScreen(
                            idUnidade:
                                idUnidade != null ? int.parse(idUnidade) : 0);
                      });
                } else {
                  idUnidade == null
                      ? ConstsFuture.navigatorPopAndPush(context, HomePage())
                      : Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                  alertSenhaPadrao();
                }
              });
            });
          });
          // if (apiBody['login'].length >= 1) {
          //   alertDialogTrocarAp(context);
          // }
        } else {
          ConstsFuture.navigatorPopAndPush(context, LoginScreen());
          LocalPreferences.removeUserLogin();
          buildCustomSnackBar(context,
              hasError: true,
              titulo: "Algo deu errado!!",
              texto: apiBody['mensagem']);
        }
      }
    });
  }

  static Future<dynamic> changeApi(String api) async {
    var url = Uri.parse("${Consts.apiUnidade}$api");
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
    try {
      return resposta.statusCode == 200
          ? Image.network(iconApi)
          : Image.asset('assets/ico-error.png');
    } catch (e) {
      return Image.asset('assets/ico-error.png');
    }
  }

  static Future<void> show(BuildContext context, {required Widget page}) async {
    await Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) => page));
  }

  static Future apiListarCorrespondencias(int? tipoAviso) async {
    // CorrespondenciaScreen.listaNovaCorresp3.clear();
    var resposta = await http.get(Uri.parse(
        '${Consts.apiUnidade}correspondencias/?fn=listarCorrespondencias&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}&idunidade=${InfosMorador.idunidade}&tipo=$tipoAviso'));
    if (resposta.statusCode == 200) {
      var respostaBody = json.decode(resposta.body);
      for (var i = 0; i <= respostaBody['correspondencias'].length - 1; i++) {
        if (respostaBody['correspondencias'][i]['protocolo'] == '') {
          if (tipoAviso == 3) {
            //   //print(
            //       'tipo 3 ${respostaBody['correspondencias'][i]['status_entrega']}');
            CorrespondenciaScreen.listaNovaCorresp3
                .add(respostaBody['correspondencias'][i]['idcorrespondencia']);
          } else {
            //   //print(
            //       'tipo 4 ${respostaBody['correspondencias'][i]['status_entrega']}');
            CorrespondenciaScreen.listaNovaCorresp4
                .add(respostaBody['correspondencias'][i]['idcorrespondencia']);
          }
        }
      }
      return json.decode(resposta.body);
    } else {
      return false;
    }
  }
}
