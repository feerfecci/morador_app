// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_portaria/screens/mails/mails_screen.dart';
import 'package:app_portaria/screens/profile/my_profile.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';
import '../../consts.dart';
import '../../widgets/sos_bar.dart';
import 'card_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    buildTopShortCuts({required IconData icon, required String title}) {
      return Column(
        children: [
          Container(
            height: size.height * 0.075,
            width: size.height * 0.075,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(5, 5), // changes position of shadow
              ),
            ], shape: BoxShape.circle, color: Colors.white),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  size: size.height * 0.04,
                )),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Consts.buildTextTitle(title)
        ],
      );
    }

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: buildHeaderPage(
        context,
        titulo: 'Fernando',
        subTitulo: 'Apartamento 35 Bloco 2',
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTopShortCuts(
                    icon: Icons.person_add_alt_rounded, title: 'Novo Perfil'),
                buildTopShortCuts(
                    icon: Icons.person_add_alt_rounded, title: 'Editar'),
                buildTopShortCuts(
                    icon: Icons.person_add_alt_rounded, title: 'Ssdas'),
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            GridView.count(
                physics: ClampingScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 1.2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                children: [
                  buildCardHome(
                    context,
                    title: 'Correspondências',
                    iconApi: 'correspondencias.png',
                    pageRoute: MailScreen(),
                  ),
                  buildCardHome(
                    context,
                    title: 'Perfil',
                    iconApi: 'perfil.png',
                    pageRoute: MyProfileScreen(),
                  ),
                  buildCardHome(
                    context,
                    title: 'Notificações',
                    iconApi: 'notificacoes.png',
                    pageRoute: MailScreen(),
                  ),
                  buildCardHome(
                    context,
                    title: 'Faturas',
                    iconApi: 'financeiro.png',
                    pageRoute: MyProfileScreen(),
                  ),
                ]),
            SosBar()
          ],
        ),
      ),
    );
  }
}
