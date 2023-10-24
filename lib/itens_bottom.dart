// import 'package:morador_app/consts/consts_future.dart';
// import 'package:morador_app/screens/avisos_chegada/chegada_screen.dart';
// import 'package:morador_app/screens/carrinho/pagina1_screen.dart';
// import 'package:morador_app/screens/correspondencia/correspondencia_screen.dart';
// import 'package:morador_app/screens/duvidas/pagina2_screen.dart';
// import 'package:morador_app/screens/home/home_page.dart';
// import 'package:morador_app/screens/quadro_avisos/quadro_avisos_screen.dart';
// import 'package:morador_app/widgets/alert_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'consts/consts.dart';
// import 'widgets/custom_drawer/custom_drawer.dart';

// // ignore: must_be_immutable
// class ItensBottom extends StatefulWidget {
//   int currentTab;
//   BuildContext? context;
//   ItensBottom({this.context, required this.currentTab, super.key});

//   @override
//   State<ItensBottom> createState() => _ItensBottomState();
// }

// class _ItensBottomState extends State<ItensBottom> {
//   late PageController _pageController;
//     @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       endDrawer: CustomDrawer(),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
//         leading: Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Image.network(
//             'https://a.portariaapp.com/img/logo-portaria.png',
//           ),
//         ),
//         elevation: 0,
//         leadingWidth: 40,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         iconSize: size.height * 0.035,
//         currentIndex: widget.currentTab,
//         onTap: (p) {
//           _pageController.jumpToPage(p);
//         },
//         items: [
//           BottomNavigationBarItem(
//             label: 'Início',
//             icon: Icon(
//               widget.currentTab == 0 ? Icons.home_sharp : Icons.home_outlined,
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               widget.currentTab == 1
//                   ? Icons.shopping_cart_rounded
//                   : Icons.shopping_cart_outlined,
//             ),
//             label: 'Carrinho',
//           ),
//           BottomNavigationBarItem(
//             label: 'Dúvidas',
//             icon: Icon(
//               widget.currentTab == 2
//                   ? Icons.question_mark_sharp
//                   : Icons.question_mark_outlined,
//             ),
//           ),
//         ],
//       ),
//       body: PageView(
//         physics: NeverScrollableScrollPhysics(),
//         controller: _pageController,
//         onPageChanged: (p) {
//           setState(() {
//             widget.currentTab = p;
//           });
//         },
//         children: const [HomePage(), Pagina1(), Pagina2()],
//       ),
//     );
//   }
// }
