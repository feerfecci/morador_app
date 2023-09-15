// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names
import 'dart:convert';

import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/screens/avisos_chegada/my_visitas_screen.dart';
import 'package:app_portaria/screens/cadastro/listar_total.dart';
import 'package:app_portaria/screens/home/dropAptos.dart';
import 'package:app_portaria/screens/reserva_espaco/listar_reserva.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_all.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../repositories/shared_preferences.dart';
import '../../widgets/alert_dialog/alert_resp_port.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import '../avisos_chegada/chegada_screen.dart';
import '../quadro_avisos/quadro_avisos_screen.dart';
import '../reserva_espaco/listar_espacos.dart';
import 'card_home.dart';
import '../correspondencia/correspondencia_screen.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static int qntCorresp = 0;
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

int qntCorresp = 0;

class _HomePageState extends State<HomePage> {
  List<String> teleforsList1 = [];
  List<String> teleforsList2 = [];
  List<String> teleforsList3 = [];
  var models1 = [
    Model(
      indexOrder: 0,
      title: 'Cartas',
      iconApi: '${Consts.iconApiPort}correspondencias.png',
      pageRoute: CorrespondenciaScreen(
        tipoAviso: 3,
      ),
    ),
    Model(
      indexOrder: 1,
      title: 'Delivery',
      iconApi: '${Consts.iconApiPort}delivery.png',
      pageRoute: ChegadaScreen(tipo: 1),
    ),
    Model(
      indexOrder: 2,
      title: 'Caixas',
      iconApi: '${Consts.iconApiPort}mercadorias.png',
      pageRoute: CorrespondenciaScreen(
        tipoAviso: 4,
      ),
    ),
    Model(
      indexOrder: 3,
      title: 'Visitas',
      iconApi: '${Consts.iconApiPort}visitas.png',
      pageRoute: ChegadaScreen(tipo: 2),
    ),
    Model(
      indexOrder: 4,
      title: 'Quadro de Avisos',
      iconApi: '${Consts.iconApiPort}quadrodeavisos.png',
      pageRoute: QuadroAvisosScreen(),
    ),
    Model(
      indexOrder: 5,
      title: 'Whatsapp Portaria',
      isWhats: true,
      iconApi: '${Consts.iconApiPort}whatsapp.png',
      numberCall: InfosMorador.telefone_portaria,
    ),
    Model(
      indexOrder: 6,
      title: 'Reserva de Espaços',
      iconApi: '${Consts.iconApiPort}reservas.png',
      pageRoute: ListarEspacos(),
    ),
    Model(
      indexOrder: 7,
      title: 'Polícia',
      iconApi: '${Consts.iconApiPort}policia.png',
      numberCall: '190',
    ),
    Model(
      indexOrder: 8,
      title: 'Samu',
      iconApi: '${Consts.iconApiPort}ambulancia.png',
      numberCall: '192',
    ),
    Model(
      indexOrder: 9,
      title: 'Bombeiros',
      iconApi: '${Consts.iconApiPort}bombeiro.png',
      numberCall: '193',
    ),
  ];

  Future initPlatFormState() async {
    NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            sound: RawResourceAndroidNotificationSound('audio_avisos'),
            importance: Importance.max,
            playSound: true));
    OneSignal.shared.setAppId("cb886dc8-9dc9-4297-9730-7de404a89716");
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      OneSignal.shared.setExternalUserId(InfosMorador.idmorador.toString());
      OneSignal.shared.sendTags({
        'idmorador': InfosMorador.idmorador.toString(),
        'idunidade': InfosMorador.idunidade.toString(),
        'idcond': InfosMorador.idcondominio.toString(),
      });
      OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
        message.messageId;
      });
      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        // if (openedResult.notification.buttons != null) {
        //   if (openedResult.notification.buttons!.first.id == 'delivery') {
        //     ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 1));
        //     alertRespondeDelivery(context, tipoAviso: 5);
        //   } else if (openedResult.notification.buttons!.first.id == 'visita') {
        //     ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 2));
        //     alertRespondeDelivery(context, tipoAviso: 6);
        //   }
        // } else {
        if (openedResult.notification.additionalData!.values.last ==
            'corresp') {
          ConstsFuture.navigatorPageRoute(
              context, CorrespondenciaScreen(tipoAviso: 3));
        } else if (openedResult.notification.additionalData!.values.last ==
            'aviso') {
          ConstsFuture.navigatorPageRoute(context, QuadroAvisosScreen());
        } else if (openedResult.notification.additionalData!.values.last ==
            'mercadorias') {
          ConstsFuture.navigatorPageRoute(
              context, CorrespondenciaScreen(tipoAviso: 4));
        } else if (openedResult.notification.additionalData!.values.last ==
            'reserva_espacos') {
          ConstsFuture.navigatorPageRoute(context, ListarReservas());
        } else if (openedResult.notification.additionalData!.values.last ==
            'visita') {
          ConstsFuture.navigatorPageRoute(context, MyVisitasScreen());
        } else if (openedResult.notification.additionalData!.values.last ==
            'delivery') {
          ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 2));
        }
        // }

        //correp
      });
      InfosMorador.email != ''
          ? OneSignal.shared.setEmail(email: InfosMorador.email.toString())
          : null;
    });
  }

  config() async {
    await LocalPreferences.getOrderCards(1).then((value) {
      if (value != null) {
        List<String> lst = value;
        List<Model> list = [];
        list = lst
            .map(
              (String indx) => models1.where((Model item) {
                return int.parse(indx) == item.indexOrder;
              }).first,
            )
            .toList();
        setState(() {
          models1 = list;
        });
      } else {
        setState(() {});
        return models1;
      }
    });
  }

  Future<dynamic> apiPubli({required int local}) {
    return ConstsFuture.changeApi(
        'publicidade/?fn=mostrarPublicidade&idcond=${InfosMorador.idcondominio}&local=$local');
  }

  @override
  void initState() {
    super.initState();
    config();
    // apiPubli(local: 0);
    initPlatFormState();
  }

  Future<dynamic> cliquePubli(String api) async {
    var url = Uri.parse(api);
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      try {
        return json.decode(resposta.body);
      } catch (e) {
        return {'erro': true, 'mensagem': 'Tente Novamente'};
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    apiQuadroAvisos();
  }

  Widget buildDraggableGrid(
      {required int qualModel, required List<Model> models}) {
    return StatefulBuilder(builder: (context, setState) {
      return ReorderableGridView.count(
        childAspectRatio: qualModel == 1 ? 1.6 : 3.25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 0.5,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        crossAxisCount: qualModel == 1 ? 2 : 1,
        children: models
            .map((card) => Container(
                  key: ValueKey(card),
                  child: buildCardHome(
                    context,
                    title: card.title!,
                    indexOrder: card.indexOrder!,
                    iconApi: card.iconApi!,
                    pageRoute: card.pageRoute,
                    isWhats: card.isWhats,
                    numberCall: card.numberCall,
                  ),
                ))
            .toList(),
        onReorder: (oldIndex, newIndex) async {
          var card = models.removeAt(oldIndex);

          setState(() {
            models.insert(newIndex, card);
            LocalPreferences.setOrderCards(
                qualModel: qualModel,
                models.map((m) {
                  return m.indexOrder.toString();
                }).toList());
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //print('Da Home tipo 3 ${CorrespondenciaScreen.listaNovaCorresp3.length}');
    //print('Da Home tipo 4  ${CorrespondenciaScreen.listaNovaCorresp4.length}');
    Widget buildBanerPubli({required int local, required List usarList}) {
      return ConstsWidget.buildPadding001(context,
          child: FutureBuilder(
            future: apiPubli(local: local),
            builder: (context, snapshot) {
              usarList.clear();
              if (snapshot.hasData) {
                if (!snapshot.data!["erro"]) {
                  // if (snapshot.data['publicidade'] != null) {
                  if (snapshot.data['publicidade'][0] != null) {
                    var apiPublicidade = snapshot.data['publicidade'][0];
                    var idpublidade = apiPublicidade['idpublidade'];
                    var idcondominio = apiPublicidade['idcondominio'];
                    var arquivo = apiPublicidade['arquivo'];
                    var email = apiPublicidade['email'];
                    var site = apiPublicidade['site'];
                    var whatsapp = apiPublicidade['whatsapp'];
                    var telefone = apiPublicidade['telefone'];
                    var telefone2 = apiPublicidade['telefone2'];
                    var impressoes = apiPublicidade['impressoes'];
                    var datahora = apiPublicidade['datahora'];
                    var ultima_atualizacao =
                        apiPublicidade['ultima_atualizacao'];

                    bool hasWhats = false;

                    if (whatsapp != '') {
                      usarList.add(whatsapp);
                      hasWhats = true;
                      //print('whatsapp $usarList');
                    }
                    if (telefone != '') {
                      if (telefone != whatsapp) {
                        usarList.add(telefone);
                        //print('telefone $usarList');
                      } else {
                        hasWhats = true;
                      }
                    }
                    if (telefone2 != '') {
                      if (telefone2 != whatsapp && telefone2 != telefone) {
                        usarList.add(telefone2);
                        //print('telefone2 $usarList');
                      } else {
                        hasWhats = true;
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        cliquePubli(
                            'https://a.portariaapp.com/unidade/api/publicidade/?fn=cliquePublicidade&idpublicidade=$idpublidade');

                        if (usarList.length == 1 && email == '' && site == '') {
                          if (hasWhats) {
                            launchUrl(Uri.parse('https://wa.me/+55$whatsapp'),
                                mode: LaunchMode.externalApplication);
                            print('Abrir whats');
                          } else {
                            print('Abrir Telefone');
                          }
                        } else if (usarList.isEmpty &&
                            email == '' &&
                            site != '') {
                          launchUrl(Uri.parse(site),
                              mode: LaunchMode.externalApplication);
                          print('Abrir link no google');
                        } else if (usarList.isEmpty &&
                            site == '' &&
                            email != '') {
                          launchUrl(Uri.parse('mailto:$email'),
                              mode: LaunchMode.externalApplication);
                          print('Abrir o email');
                        } else {
                          showDialogAll(context,
                              title: 'Entrar em contato',
                              barrierDismissible: true,
                              children: [
                                Column(
                                  children: usarList.map((e) {
                                    return MyBoxShadow(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          ConstsWidget.buildTextTitle(
                                              context, e),
                                          Spacer(),
                                          if (hasWhats && e == whatsapp)
                                            IconButton(
                                                onPressed: () {
                                                  launchUrl(
                                                      Uri.parse(
                                                          'https://wa.me/+55$whatsapp'),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                },
                                                icon:
                                                    Icon(Icons.wechat_rounded)),
                                          if (whatsapp != null)
                                            IconButton(
                                                onPressed: () {
                                                  launchUrl(
                                                      Uri.parse('tel:$e'));
                                                },
                                                icon: Icon(Icons.call)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(site),
                                        mode: LaunchMode.inAppWebView);
                                  },
                                  child: MyBoxShadow(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      ConstsWidget.buildTextTitle(
                                          context, 'Acesse o site'),
                                      Spacer(),
                                      if (site != null)
                                        ConstsWidget.buildPadding001(
                                          context,
                                          vertical: 0.015,
                                          horizontal: 0.025,
                                          child: Icon(Icons.wordpress_rounded),
                                        ),
                                    ],
                                  )),
                                )
                              ]);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ConstsWidget.buildFutureImage(context,
                            title: 'Ver mais $idpublidade', iconApi: arquivo),
                      ),
                    );
                    // } else {
                    //   InfosMorador.qtd_publicidade == 0;
                    //   return SizedBox();
                    // }
                  } else {
                    InfosMorador.qtd_publicidade == 0;
                    return Text('');
                  }
                } else {
                  return Text('');
                }
              } else {
                return Text('');
              }
            },
          ));
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          // apiPubli(local: 0);
          // CorrespondenciaScreen.listaNovaCorresp3.clear();
          // CorrespondenciaScreen.listaNovaCorresp4.clear();
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: ConstsWidget.buildTextTitle(
              context, InfosMorador.nome_completo,
              size: SplashScreen.isSmall ? 18 : 20,
              textAlign: TextAlign.center),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          leading: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.025,
                  top: SplashScreen.isSmall
                      ? size.height * 0.02
                      : size.height * 0.012,
                  bottom: SplashScreen.isSmall
                      ? size.height * 0.005
                      : size.height * 0.01),
              child: ConstsWidget.buildFutureImage(context,
                  iconApi: 'https://a.portariaapp.com/img/logo_azul.png')

              //  FutureBuilder(
              //   future: ConstsFuture.apiImageIcon(
              //       'https://a.portariaapp.com/img/logo_azul.png'),
              //   builder: (context, snapshot) {
              //     return SizedBox(child: snapshot.data);
              //   },
              // ),
              ),
          toolbarHeight:
              SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.07,
          elevation: 0,
          leadingWidth:
              SplashScreen.isSmall ? size.height * 0.075 : size.height * 0.06,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.015),
              child: Column(
                children: [
                  if (InfosMorador.qntApto != 1) DropAptos(),
                  if (InfosMorador.qntApto == 1)
                    ConstsWidget.buildPadding001(
                      context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstsWidget.buildTextTitle(context,
                              '${InfosMorador.divisao} - ${InfosMorador.numero}',
                              size: 20),
                        ],
                      ),
                    ),
                  buildDraggableGrid(qualModel: 1, models: models1),
                  SizedBox(
                    height: SplashScreen.isSmall
                        ? size.height * 0.16
                        : size.height * 0.148,
                    width: double.infinity,
                    child: buildCardHome(
                      context,
                      title: 'Ligar na Portaria',
                      iconApi: '${Consts.iconApiPort}ligar.png',
                      numberCall: InfosMorador.telefone_portaria,
                    ),
                  ),
                  if (!InfosMorador.responsavel)
                    SizedBox(
                      height: SplashScreen.isSmall
                          ? size.height * 0.16
                          : size.height * 0.148,
                      width: double.infinity,
                      child: buildCardHome(
                        context,
                        indexOrder: 1,
                        title: 'Cadastros',
                        iconApi: '${Consts.iconApiPort}cadastros.png',
                        pageRoute: ListaTotalUnidade(tipoAbrir: 1),
                      ),
                    ),
                  if (InfosMorador.qtd_publicidade != 0)
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        buildBanerPubli(local: 1, usarList: teleforsList1),
                      ],
                    ),
                  if (InfosMorador.qtd_publicidade != 0)
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.9,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        buildBanerPubli(local: 2, usarList: teleforsList2),
                        buildBanerPubli(local: 3, usarList: teleforsList3),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Model {
  int? indexOrder;
  String? title;
  String? iconApi;
  Widget? pageRoute;
  bool? isWhats;
  String? numberCall;
  Model(
      {required this.indexOrder,
      required this.title,
      required this.iconApi,
      this.pageRoute,
      this.isWhats,
      this.numberCall});

  @override
  String toString() {
    return '$indexOrder : $title';
  }
}
