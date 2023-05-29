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
    String? numberCall}) {
  var size = MediaQuery.of(context).size;

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }

  Widget tryImage() {
    apiImage() async {
      var url = Uri.parse(iconApi);
      var resposta = await http.get(url);
      if (resposta.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

    return FutureBuilder<dynamic>(
      future: apiImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerWidget(
            height: size.height * 0.08,
            width: size.width * 0.2,
          );
        } else if (snapshot.hasError) {
          return Text('Deu ruim');
        }
        return Image.network(
          iconApi,
        );
      },
    );
  }

  return MyBoxShadow(
    child: InkWell(
      onTap: () {
        if (InfosMorador.responsavel && title == 'Cadastros') {
          numberCall != null
              ? launchNumber(numberCall)
              : ConstsFuture.navigatorPageRoute(context, pageRoute!);
        } else if ((!InfosMorador.responsavel || InfosMorador.responsavel) &&
            title != 'Cadastros') {
          numberCall != null
              ? launchNumber(numberCall)
              : ConstsFuture.navigatorPageRoute(context, pageRoute!);
        } else {
          buildCustomSnackBar(context,
              titulo: 'Desculpe', texto: 'Você não tem acesso');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: size.width * 0.12,
              height: size.height * 0.075,
              child: tryImage()),
          ConstsWidget.buildTextTitle(context, title),
        ],
      ),
    ),
  );
}
