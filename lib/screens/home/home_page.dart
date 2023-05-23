// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_portaria/screens/cadastro/cadastro_screen.dart';
import 'package:app_portaria/screens/profile/my_profile.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/scaffold_all.dart';
import '../../widgets/sos_bar.dart';
import '../delivery/delivery_screen.dart';
import '../mercadorias/mercadorias.dart';
import '../quadro_avisos/quadro_avisos_screen.dart';
import '../reserva_espaco/reserva_espaco.dart';
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
  String telefonePortaria = '(11) 942169968';

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildCardCall(
        {required String title,
        required String iconApi,
        required String numberCall}) {
      return MyBoxShadow(
        paddingAll: 0.0,
        child: InkWell(
          onTap: () {
            launchNumber(numberCall);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.12,
                height: size.height * 0.075,
                child: Image.network(
                  iconApi,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              ConstsWidget.buildTextTitle(title),
            ],
          ),
        ),
      );
    }

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
                  iconApi: '${Consts.iconApi}correspondencias.png',
                  pageRoute: CorrespondenciaScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Delivery',
                  iconApi: '${Consts.iconApiPort}delivery.png',
                  pageRoute: DeliveryScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Mercadorias',
                  iconApi: '${Consts.iconApiPort}mercadorias.png',
                  pageRoute: MercadoriaScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Visitantes',
                  iconApi: '${Consts.iconApiPort}visitas.png',
                  pageRoute: VisitantesScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Cadastros',
                  iconApi: '${Consts.iconApi}perfil.png',
                  pageRoute: CadastroScreen(),
                ),
                buildCardCall(
                    title: 'Ligar Portaria',
                    iconApi: '${Consts.iconApiPort}ligar.png',
                    numberCall: telefonePortaria),
                buildCardHome(
                  context,
                  title: 'Quadro de avisos',
                  iconApi: '${Consts.iconApi}notificacoes.png',
                  pageRoute: QuadroAvisosScreen(),
                ),
                buildCardHome(
                  context,
                  title: 'Reserva de Espaços',
                  iconApi: '${Consts.iconApi}financeiro.png',
                  pageRoute: ReservaEspacos(),
                ),
                buildCardCall(
                  title: 'Samu',
                  iconApi: '${Consts.iconApi}correspondencias.png',
                  numberCall: '192',
                ),
                buildCardHome(
                  context,
                  title: 'Sos Portaria',
                  iconApi: '${Consts.iconApi}perfil.png',
                  pageRoute: MyProfileScreen(),
                ),
                buildCardCall(
                  title: 'Polícia',
                  iconApi: '${Consts.iconApi}notificacoes.png',
                  numberCall: '190',
                ),
                buildCardCall(
                  title: 'Bombeiros',
                  iconApi: '${Consts.iconApi}financeiro.png',
                  numberCall: '193',
                ),
                //////
                // buildCardHome(
                //   context,
                //   title: 'Enquete',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Classificados',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Sequestro',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
                // buildCardHome(
                //   context,
                //   title: 'Propaganda',
                //   iconApi: '${Consts.iconApi}financeiro.png',
                //   pageRoute: MyProfileScreen(),
                // ),
              ]),
        ],
      ),
    );
  }
}
