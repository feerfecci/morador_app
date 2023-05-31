// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/cadastro/listar_moradores.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../consts/consts_widget.dart';
import 'change_theme_button.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buidListTile(
        {required String title,
        required IconData leading,
        IconData trailing = Icons.keyboard_arrow_right_outlined,
        void Function()? onPressed}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: ListTile(
          iconColor: Theme.of(context).iconTheme.color,
          leading: Icon(
            leading,
            size: 25,
          ),
          title: ConstsWidget.buildTextTitle(context, title),
          trailing: IconButton(
            onPressed: onPressed,
            icon: Icon(
              size: 30,
              trailing,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: size.height * 0.95,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.10,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Colors.blue),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (InfosMorador.responsavel)
                buidListTile(
                  title: 'Cadastros',
                  leading: Icons.person,
                  onPressed: () {
                    // ConstsFuture.navigatorPageRoute(context, CadastroScreen());
                  },
                ),
              ChangeThemeButton(),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Sair',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false);
                    LocalPreferences.removeUserLogin();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
