// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:morador_app/consts/consts.dart';
import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/repositories/shared_preferences.dart';
import 'package:morador_app/screens/cadastro/morador/cadastro_morador.dart';
import 'package:morador_app/screens/login/login_screen.dart';
import 'package:morador_app/screens/politica/politica_screen.dart';
import 'package:morador_app/screens/splash_screen/splash_screen.dart';
import 'package:morador_app/screens/termodeuso/termo_de_uso.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts_widget.dart';
import '../alert_dialog/alert_trocar_senha.dart';
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
        vertical: 0.009,
        child: GestureDetector(
          onTap: onPressed,
          child: ListTile(
            iconColor: Theme.of(context).iconTheme.color,
            leading: Icon(
              leading,
              size: SplashScreen.isSmall ? 20 : 30,
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
        width: size.width * 0.775,
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
                      color: Consts.kColorAzul),
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
                title: 'Adicionar Outras Unidades',
                leading: Icons.lock_person_outlined,
                onPressed: () => trocarSenhaAlert(context, isChecked: true),
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
                title: 'Política de Privacidade',
                leading: Icons.privacy_tip_outlined,
                onPressed: () =>
                    ConstsFuture.navigatorPageRoute(context, PoliticaScreen()),
              ),
              buidListTile(
                title: 'Termos de Uso',
                leading: Icons.assignment_outlined,
                onPressed: () => ConstsFuture.navigatorPageRoute(
                    context, TermoDeUsoScreen()),
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
                title: 'Efetuar Logoff',
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
              ConstsWidget.buildPadding001(context,
                  vertical: 0.008, child: ChangeThemeButton()),
              // SizedBox(
              //   height: size.height * 0.03,
              // ),
              Padding(
                padding: EdgeInsets.only(
                  top: SplashScreen.isSmall
                      ? size.height * 0.01
                      : size.height * 0.0,
                  right: size.width * 0.02,
                  left: size.width * 0.02,
                ),
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
