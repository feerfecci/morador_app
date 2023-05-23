import 'package:app_portaria/screens/carrinho/pagina1_screen.dart';
import 'package:app_portaria/screens/duvidas/pagina2_screen.dart';
import 'package:app_portaria/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  }

  static const String oneSignalAppId = "cb886dc8-9dc9-4297-9730-7de404a89716";

  Future initPlatFormState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      OneSignal.shared.setExternalUserId('26');
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Image.network(
            'https://www.portariaapp.com/wp-content/uploads/2023/03/portria.png',
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
