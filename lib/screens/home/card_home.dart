import 'package:app_portaria/screens/correspondencia/correspondencia_screen.dart';
import 'package:app_portaria/screens/quadro_avisos/quadro_avisos_screen.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';
import 'package:badges/badges.dart' as badges;

Widget buildCardHome(BuildContext context,
    {required String title,
    int? indexOrder,
    int qntCorresp = 0,
    Widget? pageRoute,
    required String iconApi,
    bool? isWhats,
    String? numberCall}) {
  var size = MediaQuery.of(context).size;

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }

  double meuwidth =
      SplashScreen.isSmall ? size.width * 0.14 : size.width * 0.138;
  double meuheigth = meuwidth;

  return MyBoxShadow(
    paddingAll: 0,
    child: InkWell(
      onTap: numberCall == null
          ? () {
              ConstsFuture.navigatorPageRoute(context, pageRoute!);
            }
          : () {
              if (isWhats != null) {
                launchUrl(Uri.parse('https://wa.me/+55$numberCall'),
                    mode: LaunchMode.externalApplication);
              } else {
                launchNumber(numberCall);
              }
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.005,
          ),
          ConstsWidget.buildBadge(
            context,
            position: badges.BadgePosition.topEnd(
                top: -size.height * 0.01, end: -size.width * 0.15),
            title: title == 'Caixas'
                ? CorrespondenciaScreen.listaNovaCorresp4.length
                : title == 'Cartas'
                    ? CorrespondenciaScreen.listaNovaCorresp3.length
                    : QuadroAvisosScreen.qntAvisos.length,
            showBadge: title == 'Caixas' &&
                    CorrespondenciaScreen.listaNovaCorresp4.isNotEmpty
                ? true
                : title == 'Cartas' &&
                        CorrespondenciaScreen.listaNovaCorresp3.isNotEmpty
                    ? true
                    : title == "Quadro de Avisos" &&
                            QuadroAvisosScreen.qntAvisos.isNotEmpty
                        ? true
                        : false,
            child: ConstsWidget.buildCachedImage(context,
                iconApi: iconApi,
                height: meuheigth,
                width: meuwidth,
                meuWidth: true),
          ),
          // Spacer(),
          SizedBox(
            height: size.height * 0.011,
          ),
          SizedBox(
              width: size.width * 0.9,
              child: ConstsWidget.buildTextTitle(
                context,
                title,
                textAlign: TextAlign.center,
                size: 16,
              )),
          Spacer(),
        ],
      ),
    ),
  );
}
