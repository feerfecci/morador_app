// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_portaria/screens/cadastro/cadastro_screen.dart';
import 'package:app_portaria/screens/profile/my_profile.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../consts.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/scaffold_all.dart';
import '../../widgets/sos_bar.dart';
import '../delivery/delivery_screen.dart';
import '../mercadorias/mercadorias.dart';
import '../visitantes/visitantes_screen.dart';
import 'card_home.dart';
import '../correspondencia/correspondencia_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String number = '11 942169968';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildHeaderPage(
      context,
      titulo: 'Fernando',
      subTitulo: 'Apartamento 35 Bloco 2',
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.025,
          ),
          GridView.count(
              physics: ClampingScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 1.6,
              crossAxisSpacing: 1,
              mainAxisSpacing: 0.5,
              children: [
                buildCardHome(
                  context,
                  title: 'Correspondências',
                  iconApi: 'correspondencias.png',
                  pageRoute: CorrespondenciaScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Delivery',
                  iconApi: 'perfil.png',
                  pageRoute: DeliveryScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Mercadorias',
                  iconApi: 'notificacoes.png',
                  pageRoute: MercadoriaScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Visitantes',
                  iconApi: 'financeiro.png',
                  pageRoute: VisitantesScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Cadastros',
                  iconApi: 'correspondencias.png',
                  pageRoute: CadastroScreen(),
                ),
                MyBoxShadow(
                  paddingAll: 0.0,
                  child: InkWell(
                    onTap: () async {
                      Uri telefone = Uri.parse('https://flutter.dev');
                      if (await launchUrl(telefone)) {
                        print('ligou');
                      } else {
                        print('não ligou');
                      }
                      ;
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.12,
                          height: size.height * 0.075,
                          child: Image.network(
                            '${Consts.iconApi}perfil.png',
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Consts.buildTextTitle('Ligar Portaria'),
                      ],
                    ),
                  ),
                ),
                buildCardHome(
                  context,
                  title: 'Quadro de avisos',
                  iconApi: 'notificacoes.png',
                  pageRoute: CorrespondenciaScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Reserva de Espaços',
                  iconApi: 'financeiro.png',
                  pageRoute: MyProfileScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Samu',
                  iconApi: 'correspondencias.png',
                  pageRoute: MyProfileScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Sos Portaria',
                  iconApi: 'perfil.png',
                  pageRoute: MyProfileScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Polícia',
                  iconApi: 'notificacoes.png',
                  pageRoute: CorrespondenciaScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Bombeiros',
                  iconApi: 'financeiro.png',
                  pageRoute: MyProfileScreen(),
                ),
                //////
                // buildCardHome(
                //   context,
                //   title: 'Enquete',
                //   iconApi: 'financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Classificados',
                //   iconApi: 'financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Sequestro',
                //   iconApi: 'financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Propaganda',
                //   iconApi: 'financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
              ]),
          // SosBar()
        ],
      ),
    );
  }
}
