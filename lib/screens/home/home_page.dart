// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:app_portaria/screens/cadastro/listar_total.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import '../avisos_chegada/chegada_screen.dart';
import '../quadro_avisos/quadro_avisos_screen.dart';
import '../reserva_espaco/listar_espacos.dart';
import 'card_home.dart';
import '../correspondencia/correspondencia_screen.dart';

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
  @override
  void initState() {
    super.initState();
    initPlatFormState();
  }

  Future initPlatFormState() async {
    OneSignal.shared.setAppId("cb886dc8-9dc9-4297-9730-7de404a89716");
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      OneSignal.shared.setExternalUserId(InfosMorador.idmorador.toString());
      OneSignal.shared.sendTags({
        'idmorador': InfosMorador.idmorador.toString(),
        'idunidade': InfosMorador.idunidade.toString(),
        'idcond': InfosMorador.idcondominio.toString(),
      });
      OneSignal.shared;
      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        if (openedResult.notification.buttons!.first.id != '') {
          if (openedResult.notification.buttons!.first.id == 'delivery') {
            ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 1));
            alertRespondeDelivery(context, tipoAviso: 5);
          } else if (openedResult.notification.buttons!.first.id == 'visita') {
            ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 2));
            alertRespondeDelivery(context, tipoAviso: 6);
          }
        } else {
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildGridView({required List<Widget> children}) {
      return GridView.count(
        physics: ClampingScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1.6,
        crossAxisSpacing: 15,
        mainAxisSpacing: 0.5,
        children: children,
      );
    }

    return Scaffold(
        endDrawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Image.network(
              'https://a.portariaapp.com/img/logo-portaria.png',
            ),
          ),
          elevation: 0,
          leadingWidth: 40,
        ),
        body: buildHeaderPage(
          context,
          titulo: InfosMorador.nome_completo,
          subTitulo: '${InfosMorador.divisao} - ${InfosMorador.numero}',
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!InfosMorador.responsavel)
                buildGridView(
                  children: [
                    buildCardHome(
                      context,
                      title: 'Ligar na Portaria',
                      iconApi: '${Consts.iconApiPort}ligar.png',
                      numberCall: InfosMorador.telefone_portaria,
                    ),
                    buildCardHome(
                      context,
                      title: 'Whatsapp Portaria',
                      isWhats: true,
                      iconApi: '${Consts.iconApiPort}ligar.png',
                      numberCall: InfosMorador.telefone_portaria,
                    ),
                    buildCardHome(
                      context,
                      title: 'Correspondências',
                      iconApi: '${Consts.iconApi}correspondencias.png',
                      pageRoute: CorrespondenciaScreen(
                        tipoAviso: 3,
                      ),
                    ),
                    buildCardHome(
                      context,
                      title: 'Delivery',
                      iconApi: '${Consts.iconApiPort}delivery.png',
                      pageRoute: ChegadaScreen(tipo: 1),
                    ),
                    buildCardHome(
                      context,
                      title: 'Mercadorias',
                      iconApi: '${Consts.iconApiPort}mercadorias.png',
                      pageRoute: CorrespondenciaScreen(
                        tipoAviso: 4,
                      ),
                    ),
                    buildCardHome(
                      context,
                      title: 'Visitantes',
                      iconApi: '${Consts.iconApiPort}visitas.png',
                      pageRoute: ChegadaScreen(tipo: 2),
                    ),
                  ],
                ),
              if (InfosMorador.responsavel)
                SizedBox(
                  height: size.height * 0.148,
                  width: double.infinity,
                  child: buildCardHome(
                    context,
                    title: 'Cadastros',
                    iconApi: '${Consts.iconApi}financeiro.png',
                    pageRoute: ListaTotalUnidade(tipoAbrir: 1),
                  ),
                ),
              // if (!InfosMorador.responsavel)
              SizedBox(
                height: size.height * 0.148,
                width: double.infinity,
                child: buildCardHome(
                  context,
                  title: 'Quadro de avisos',
                  iconApi: '${Consts.iconApiPort}avisos.png',
                  pageRoute: QuadroAvisosScreen(),
                ),
              ),
              buildGridView(children: [
                // buildCardHome(
                //   context,
                //   title: 'Quadro de avisos',
                //   iconApi: '${Consts.iconApiPort}avisos.png',
                //   pageRoute: QuadroAvisosScreen(),
                // ),

                // buildCardHome(
                //   context,
                //   title: 'Cadastros',
                //   iconApi: '${Consts.iconApi}perfil.png',
                //   pageRoute: ListaMoradores(),
                // ),
                if (!InfosMorador.responsavel)
                  buildCardHome(
                    context,
                    title: 'Reserva de Espaços',
                    iconApi: '${Consts.iconApi}financeiro.png',
                    pageRoute: ListarEspacos(),
                  ),
                if (!InfosMorador.responsavel)
                  buildCardHome(
                    context,
                    title: 'Polícia',
                    iconApi: '${Consts.iconApi}notificacoes.png',
                    numberCall: '190',
                  ),

                if (!InfosMorador.responsavel)
                  buildCardHome(
                    context,
                    title: 'Samu',
                    iconApi: '${Consts.iconApi}correspondencias.png',
                    numberCall: '192',
                  ),
                // buildCardHome(
                //   context,
                //   title: 'Sos Portaria',
                //   iconApi: '${Consts.iconApi}perfil.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                if (!InfosMorador.responsavel)
                  buildCardHome(
                    context,
                    title: 'Bombeiros',
                    iconApi: '${Consts.iconApi}financeiro.png',
                    numberCall: '193',
                  ),
                //////
                // buildCardHome(
                //   context,
                //   title: 'Enquete',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Classificados',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Sequestro',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Propaganda',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
              ]),
            ],
          ),
        ));
  }
}
