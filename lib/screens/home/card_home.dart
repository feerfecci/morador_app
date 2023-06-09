import 'dart:convert';
import 'dart:io';

import 'package:app_portaria/widgets/shimmer.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';

Widget buildCardHome(BuildContext context,
    {required String title,
    Widget? pageRoute,
    required String iconApi,
    bool? isWhats,
    String? numberCall}) {
  var size = MediaQuery.of(context).size;

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }

  Future<Widget> apiImage() async {
    var url = Uri.parse(iconApi);
    var resposta = await http.get(url);

    return resposta.statusCode == 200
        ? Image.network(
            iconApi,
          )
        : Image.asset('assets/erro_png.png');
  }

  return MyBoxShadow(
    child: InkWell(
      onTap: numberCall == null
          ? () {
              ConstsFuture.navigatorPageRoute(context, pageRoute!);
            }
          : () {
              if (isWhats != null) {
                launchUrl(Uri.parse('https://api.whatsapp.com/send?phone='));
              } else {
                launchNumber(numberCall);
              }
            },
      //  () {
      //   if (InfosMorador.responsavel && title == 'Cadastros') {
      //     numberCall != null
      //         ? launchNumber(numberCall)
      //         : ConstsFuture.navigatorPageRoute(context, pageRoute!);
      //   } else if ((!InfosMorador.responsavel || InfosMorador.responsavel) &&
      //       title != 'Cadastros') {
      //     numberCall != null
      //         ? launchNumber(numberCall)
      //         : ConstsFuture.navigatorPageRoute(context, pageRoute!);
      //   } else {
      //     buildCustomSnackBar(context,
      //         titulo: 'Desculpe', texto: 'Você não tem acesso');
      //   }
      // },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: apiImage(),
              builder: (context, snapshot) => SizedBox(
                  width: size.width * 0.12,
                  height: size.height * 0.075,
                  child: snapshot.data)),
          ConstsWidget.buildTextTitle(context, title),
        ],
      ),
    ),
  );
}
