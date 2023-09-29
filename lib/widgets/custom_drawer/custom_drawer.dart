// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/cadastro/morador/cadastro_morador.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:app_portaria/screens/politica/politica_screen.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/screens/termodeuso/termo_de_uso.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      return ConstsWidget.buildPadding001(
        context,
        child: GestureDetector(
          onTap: onPressed,
          child: ListTile(
            iconColor: Theme.of(context).iconTheme.color,
            leading: Icon(
              leading,
              size: SplashScreen.isSmall ? 18 : 21,
            ),
            title: ConstsWidget.buildTextTitle(context, title, size: 16),
            trailing: Icon(
              size: SplashScreen.isSmall ? 25 : 30,
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
          child: ListView(
            children: [
              SizedBox(
                height: SplashScreen.isSmall
                    ? size.height * 0.12
                    : size.height * 0.08,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                      ),
                      color: Colors.blue),
                  child: Text(
                    'Menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              buidListTile(
                title: 'Meu Perfil',
                leading: Icons.person_2_outlined,
                onPressed: () {
                  ConstsFuture.navigatorPopAndPush(
                      context,
                      CadastroMorador(
                        idmorador: InfosMorador.idmorador,
                        iddivisao: InfosMorador.iddivisao,
                        idunidade: InfosMorador.idunidade,
                        numero: InfosMorador.numero,
                        login: InfosMorador.login,
                        documento: InfosMorador.documento,
                        acesso: InfosMorador.acessa_sistema ? 1 : 0,
                        ativo: InfosMorador.ativo,
                        ddd: InfosMorador.dddtelefone,
                        telefone: InfosMorador.telefone,
                        email: InfosMorador.email,
                        nascimento: InfosMorador.data_nascimento,
                        nome_completo: InfosMorador.nome_completo,
                        isDrawer: true,
                      ));
                },
              ),
              buidListTile(
                title: 'Seja um Representante',
                leading: Icons.business_center_outlined,
                onPressed: () => launchUrl(
                    Uri.parse(
                        'https://www.portariaapp.com/seja-um-representante'),
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Termos de uso',
                leading: Icons.supervised_user_circle,
                onPressed: () => ConstsFuture.navigatorPageRoute(
                    context, TermoDeUsoScreen()),
              ),
              buidListTile(
                title: 'Política de privacidade',
                leading: Icons.privacy_tip_outlined,
                onPressed: () =>
                    ConstsFuture.navigatorPageRoute(context, PoliticaScreen()),
              ),
              buidListTile(
                title: 'Indicar para Amigos',
                leading: Icons.add_reaction_outlined,
                onPressed: () => launchUrl(
                    Uri.parse('https://www.portariaapp.com/indicar-para-amigo'),
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Central de Ajuda',
                leading: Icons.support_outlined,
                onPressed: () => launchUrl(
                    Uri.parse(
                      'https://www.portariaapp.com/central-de-ajuda',
                    ),
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Efetuar logoff',
                leading: Icons.logout_outlined,
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
              ChangeThemeButton(),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SplashScreen.isSmall
                        ? size.height * 0.01
                        : size.height * 0.035,
                    horizontal: size.width * 0.02),
                child: ConstsWidget.buildOutlinedButton(
                  context, title: 'Fechar Menu',
                  // icon: Icons.logout_outlined,
                  onPressed: () {
                    Navigator.pop(context);
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
