// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:morador_app/consts/consts_widget.dart';
import 'package:morador_app/screens/cadastro/listar_total.dart';
import 'package:morador_app/screens/home/dropAptos.dart';
import 'package:morador_app/screens/splash_screen/splash_screen.dart';
import 'package:morador_app/widgets/alert_dialog/alert_all.dart';
import 'package:morador_app/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../repositories/shared_preferences.dart';
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
  DateTime timeBackPressed = DateTime.now();
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
      title: 'Reservar Espaços',
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
  int indexList = 0;
  String openedNotificationRote = '';
  bool hasButton = false;
  final versionChecker = AppVersionChecker(
      appId: 'com.portariapp.morador_app1',
      androidStore: AndroidStore.googlePlayStore);

  checkerVersion() {
    versionChecker.checkUpdate().then((value) {
      if (!value.canUpdate) {
        print(value.currentVersion);
        print(value.newVersion);
      }
    });
  }

  Future initPlatFormState() async {
    OneSignal.shared.setAppId('4ab8b6f9-4715-4cae-83ca-d315015fdc06');
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      for (var i = 0; i <= (InfosMorador.listIdCond.length - 1); i++) {
        OneSignal.shared.deleteTags(['idcond', 'idmorador', 'idunidade']);
        OneSignal.shared.deleteTags([
          'idcond${InfosMorador.listIdCond[i]}',
          'idmorador${InfosMorador.listIdMorador[i]}',
          'idunidade${InfosMorador.listIdUnidade[i]}'
        ]);

        OneSignal.shared.sendTags({
          'idcond${InfosMorador.listIdCond[i]}': InfosMorador.listIdCond[i],
          'idmorador${InfosMorador.listIdMorador[i]}':
              InfosMorador.listIdMorador[i],
          'idunidade${InfosMorador.listIdUnidade[i]}':
              InfosMorador.listIdUnidade[i],
        });
      }
    });
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      ConstsFuture.efetuaLogin(
          context, InfosMorador.login, InfosMorador.senhaCripto,
          idUnidade: openedResult.notification.additionalData!['idunidade'],
          reLogin: true,
          openedResult: openedResult);
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
    checkerVersion();
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
  }

  Widget buildDraggableGrid(
      {required int qualModel, required List<Model> models}) {
    return StatefulBuilder(builder: (context, setState) {
      return ReorderableGridView.count(
        childAspectRatio: qualModel == 1 ? 1.495 : 3.25,
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
                    }
                    if (telefone != '') {
                      if (telefone != whatsapp) {
                        usarList.add(telefone);
                      } else {
                        hasWhats = true;
                      }
                    }
                    if (telefone2 != '') {
                      if (telefone2 != whatsapp && telefone2 != telefone) {
                        usarList.add(telefone2);
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
                          } else {
                            launchUrl(
                              Uri.parse('tel:${usarList.first}'),
                            );
                          }
                        } else if (usarList.isEmpty &&
                            email == '' &&
                            site != '') {
                          launchUrl(Uri.parse(site),
                              mode: LaunchMode.externalApplication);
                        } else if (usarList.isEmpty &&
                            site == '' &&
                            email != '') {
                          launchUrl(Uri.parse('mailto:$email'),
                              mode: LaunchMode.externalApplication);
                        } else {
                          showDialogAll(context,
                              title: ConstsWidget.buildTextSubTitle(
                                  context, 'Entrar em contato'),
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
                        child: ConstsWidget.buildCachedImage(context,
                            title: 'Ver mais $idpublidade', iconApi: arquivo),
                      ),
                    );
                    // } else {
                    //   InfosMorador.qtd_publicidade == 0;
                    //   return SizedBox();
                    // }
                  } else {
                    InfosMorador.qtd_publicidade == 0;
                    return SizedBox();
                  }
                } else {
                  InfosMorador.qtd_publicidade == 0;
                  return SizedBox();
                }
              } else {
                InfosMorador.qtd_publicidade == 0;
                return SizedBox();
              }
            },
          ));
    }

    return WillPopScope(
      onWillPop: () async {
        final differenceBack = DateTime.now().difference(timeBackPressed);
        final isExitWarning = differenceBack >= Duration(seconds: 1);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          Fluttertoast.showToast(
              msg: 'Pressione novamente para sair',
              fontSize: 18,
              backgroundColor: Colors.black);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            // apiPubli(local: 0);
            // ConstsFuture.apiListarCorrespondencias(3).whenComplete(() {
            //   ConstsFuture.apiListarCorrespondencias(4).whenComplete(() {
            //     apiQuadroAvisos().whenComplete(() {});
            //   });
            // });
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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.bodyLarge!.color),
            toolbarHeight:
                SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.07,
            elevation: 0,
            leading: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.025,
                    top: SplashScreen.isSmall
                        ? size.height * 0.02
                        : size.height * 0.012,
                    bottom: SplashScreen.isSmall
                        ? size.height * 0.005
                        : size.height * 0.01),
                child: ConstsWidget.buildCachedImage(context,
                    iconApi: 'https://a.portariaapp.com/img/logo_azul.png')

                //  FutureBuilder(
                //   future: ConstsFuture.apiImageIcon(
                //       'https://a.portariaapp.com/img/logo_azul.png'),
                //   builder: (context, snapshot) {
                //     return SizedBox(child: snapshot.data);
                //   },
                // ),
                ),
            leadingWidth:
                SplashScreen.isSmall ? size.height * 0.08 : size.height * 0.06,
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.015),
                child: Column(
                  children: [
                    // if (InfosMorador.qntApto != 1)
                    DropAptos(),
                    // if (InfosMorador.qntApto == 1)
                    //   ConstsWidget.buildPadding001(
                    //     context,
                    //     vertical: 0.02,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         ConstsWidget.buildTextTitle(context,
                    //             '${InfosMorador.divisao} - ${InfosMorador.numero}',
                    //             size: 20),
                    //       ],
                    //     ),
                    //   ),
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
