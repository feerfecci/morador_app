import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/avisos_chegada/chegada_screen.dart';
import 'package:app_portaria/screens/carrinho/pagina1_screen.dart';
import 'package:app_portaria/screens/correspondencia/correspondencia_screen.dart';
import 'package:app_portaria/screens/duvidas/pagina2_screen.dart';
import 'package:app_portaria/screens/home/home_page.dart';
import 'package:app_portaria/screens/quadro_avisos/quadro_avisos_screen.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'consts/consts.dart';
import 'widgets/custom_drawer/custom_drawer.dart';

// ignore: must_be_immutable
class ItensBottom extends StatefulWidget {
  int currentTab;
  BuildContext? context;
  ItensBottom({this.context, required this.currentTab, super.key});

  @override
  State<ItensBottom> createState() => _ItensBottomState();
}

class _ItensBottomState extends State<ItensBottom> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initPlatFormState();
    // initSons();
  }

  // Future initSons() async {
  //   // NotificationServiceCorresp.showNotification();
  //   return NotificationServiceCorresp.initNotificationCorresp();
  //   // NotificationServiceCorresp.notificationDetailsCorresp();
  // }

  Future initPlatFormState() async {
    OneSignal.shared.setAppId("cb886dc8-9dc9-4297-9730-7de404a89716");
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      OneSignal.shared.setExternalUserId(InfosMorador.idmorador.toString());
      OneSignal.shared.sendTags({
        'idmorador': InfosMorador.idmorador.toString(),
        'idunidade': InfosMorador.idunidade.toString(),
        'idcond': InfosMorador.idcondominio.toString()
      });
      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        print(
            'Nosso print ${openedResult.notification.additionalData!.values.first}');
        //correp
        if (openedResult.notification.additionalData!.values.first ==
            'corresp') {
          ConstsFuture.navigatorPageRoute(
              context, CorrespondenciaScreen(tipoAviso: 1));
        }
        //delivery
        else if (openedResult.notification.additionalData!.values.first ==
            'delivery') {
          ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 1));
        }

        //visita
        else if (openedResult.notification.additionalData!.values.first ==
            'visita') {
          ConstsFuture.navigatorPageRoute(context, ChegadaScreen(tipo: 2));
        }
        //aviso
        else if (openedResult.notification.additionalData!.values.first ==
            'aviso') {
          ConstsFuture.navigatorPageRoute(context, QuadroAvisosScreen());
        } else {
          ConstsFuture.navigatorPageRoute(
              context, CorrespondenciaScreen(tipoAviso: 1));
        }
      });
      InfosMorador.email != ''
          ? OneSignal.shared.setEmail(email: InfosMorador.email.toString())
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.menu_rounded,
        //         size: size.height * 0.045,
        //       ))
        // ],
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
      bottomNavigationBar: BottomNavigationBar(
        iconSize: size.height * 0.035,
        currentIndex: widget.currentTab,
        onTap: (p) {
          _pageController.jumpToPage(p);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Início',
            icon: Icon(
              widget.currentTab == 0 ? Icons.home_sharp : Icons.home_outlined,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.currentTab == 1
                  ? Icons.shopping_cart_rounded
                  : Icons.shopping_cart_outlined,
            ),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            label: 'Dúvidas',
            icon: Icon(
              widget.currentTab == 2
                  ? Icons.question_mark_sharp
                  : Icons.question_mark_outlined,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (p) {
          setState(() {
            widget.currentTab = p;
          });
        },
        children: const [HomePage(), Pagina1(), Pagina2()],
      ),
    );
  }
}
