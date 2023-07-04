// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/screens/cadastro/listar_total.dart';
import 'package:app_portaria/screens/home/dropAptos.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Widget buildCard() {
  //   if (InfosMorador.responsavel) {
  //     return buildCardHome(
  //       context,
  //       title: 'Delivery',
  //       iconApi: '${Consts.iconApiPort}delivery.png',
  //       pageRoute: ChegadaScreen(tipo: 1),
  //     );
  //   } else {
  //     return null;
  //   }
  // }
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

  // var models2 = [
  //   Model(
  //     indexOrder: 0,
  //     title: 'Ligar na Portaria',
  //     iconApi: '${Consts.iconApiPort}ligar.png',
  //     numberCall: InfosMorador.telefone_portaria,
  //   ),
  //   Model(
  //     indexOrder: 1,
  //     title: 'Cadastros',
  //     iconApi: '${Consts.iconApiPort}cadastros.png',
  //     pageRoute: ListaTotalUnidade(tipoAbrir: 1),
  //   )
  // ];

  Future initPlatFormState() async {
    OneSignal.shared.setAppId("cb886dc8-9dc9-4297-9730-7de404a89716");
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      OneSignal.shared.setExternalUserId(InfosMorador.idmorador.toString());
      OneSignal.shared.sendTags({
        'idmorador': InfosMorador.idmorador.toString(),
        'idunidade': InfosMorador.idunidade.toString(),
        'idcond': InfosMorador.idcondominio.toString(),
      });
      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        print(openedResult.notification.buttons!.first.id);
        if (openedResult.notification.buttons!.first.id != '') {
          if (openedResult.notification.buttons!.first.id == 'delivery') {
            ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 1));
            alertRespondeDelivery(context, tipoAviso: 5);
          } else if (openedResult.notification.buttons!.first.id == 'visita') {
            ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 2));
            alertRespondeDelivery(context, tipoAviso: 6);
          }
        } else {
          print(openedResult.notification.additionalData!.values.first);
          if (openedResult.notification.additionalData!.values.first ==
              'corresp') {
            ConstsFuture.navigatorPageRoute(
                context, CorrespondenciaScreen(tipoAviso: 3));
          }
          // //delivery
          // else if (openedResult.notification.additionalData!.values.first ==
          //     'delivery') {
          //   ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 1));
          // }

          // //visita
          // else if (openedResult.notification.additionalData!.values.first ==
          //     'visita') {
          //   ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 2));
          // }
          //aviso
          else if (openedResult.notification.additionalData!.values.first ==
              'aviso') {
            ConstsFuture.navigatorPageRoute(context, QuadroAvisosScreen());
          } else if (openedResult.notification.additionalData!.values.first ==
              'mercadorias') {
            ConstsFuture.navigatorPageRoute(
                context, CorrespondenciaScreen(tipoAviso: 4));
          }
        }

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

  // config2() async {
  //   await LocalPreferences.getOrderCards(2).then((value2) {
  //     print(value2);
  //     if (value2 != null) {
  //       List<String> lst2 = value2;
  //       List<Model> list2 = [];
  //       if (lst2 != null && lst2.isNotEmpty) {
  //         list2 = lst2
  //             .map(
  //               (String indx) => models2.where((Model item) {
  //                 return int.parse(indx) == item.indexOrder;
  //               }).first,
  //             )
  //             .toList();
  //         setState(() {
  //           models2 = list2;
  //         });
  //       } else {
  //         setState(() {});
  //         return models2;
  //       }
  //     } else {
  //       setState(() {});
  //       return models2;
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    config();
    // config2();
    initPlatFormState();
  }

  Widget buildDraggableGrid(
      {required int qualModel, required List<Model> models}) {
    var size = MediaQuery.of(context).size;
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
                  child: buildCardHome(context,
                      title: card.title!,
                      indexOrder: card.indexOrder!,
                      iconApi: card.iconApi!,
                      pageRoute: card.pageRoute,
                      isWhats: card.isWhats,
                      numberCall: card.numberCall),
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
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: ConstsWidget.buildTextTitle(context, InfosMorador.nome_completo,
            size: 20, textAlign: TextAlign.center),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        leading: Padding(
          padding: EdgeInsets.only(left: size.width * 0.025),
          child: FutureBuilder(
            future: ConstsFuture.apiImageIcon(
                'https://a.portariaapp.com/img/logo_azul.png'),
            builder: (context, snapshot) {
              return SizedBox(child: snapshot.data);
            },
          ),
        ),
        elevation: 0,
        leadingWidth: size.height * 0.06,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.015),
            child: Column(
              children: [
                if (InfosMorador.qntApto != 1) DropAptos(),
                if (InfosMorador.qntApto == 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
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
                  height: size.height * 0.148,
                  width: double.infinity,
                  child: buildCardHome(
                    context,
                    title: 'Ligar na Portaria',
                    iconApi: '${Consts.iconApiPort}ligar.png',
                    numberCall: InfosMorador.telefone_portaria,
                  ),
                ),
                if (InfosMorador.responsavel)
                  SizedBox(
                    height: size.height * 0.148,
                    width: double.infinity,
                    child: buildCardHome(
                      context,
                      indexOrder: 1,
                      title: 'Cadastros',
                      iconApi: '${Consts.iconApiPort}cadastros.png',
                      pageRoute: ListaTotalUnidade(tipoAbrir: 1),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: MyBoxShadow(
                      imagem: true,
                      child: SizedBox(
                        height: 300,
                        width: double.maxFinite,
                      )),
                ),
              ],
            ),
          )
        ],
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
