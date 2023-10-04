// ignore_for_file: non_constant_identifier_names, unused_local_variable
import 'dart:convert';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/correspondencia/loading_corresp.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/page_erro.dart';
import 'package:app_portaria/widgets/page_vazia.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import 'package:badges/badges.dart' as badges;

class QuadroAvisosScreen extends StatefulWidget {
  static List qntAvisos = [];

  const QuadroAvisosScreen({super.key});

  @override
  State<QuadroAvisosScreen> createState() => _QuadroAvisosScreenState();
}

Future apiQuadroAvisos() async {
  //print('listarAvisos');
  var url = Uri.parse(
      '${Consts.apiUnidade}/quadro_avisos/index.php?fn=listarAvisos&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}');
  var resposta = await get(url);

  if (resposta.statusCode == 200) {
    var jsonResposta = json.decode(resposta.body);
    if (!jsonResposta['erro']) {
      comparaAvisos(jsonResposta)
          .whenComplete(() => LocalPreferences.setDateLogin());
    }

    return json.decode(resposta.body);
  } else {
    return false;
  }
}

Future comparaAvisos(jsonResposta) async {
  List apiAvisos = jsonResposta['avisos'];
  QuadroAvisosScreen.qntAvisos.clear();

  LocalPreferences.getDateLogin().then((value) {
    List listApiAvisos = apiAvisos;
    listApiAvisos.map((e) {
      if (value != null) {
        DateTime dateValue = DateTime.parse(value);
        DateTime dateAvisos = DateTime.parse(e['datahora']);

        if (!QuadroAvisosScreen.qntAvisos.contains(e['idaviso'])) {
          if (dateAvisos.compareTo(dateValue) > 0 &&
              dateAvisos.compareTo(DateTime.now()) < 0) {
            QuadroAvisosScreen.qntAvisos.add(e['idaviso']);
          }
        }
      } else {
        QuadroAvisosScreen.qntAvisos.add(e['idaviso']);
      }
    }).toSet();
  });
}

class _QuadroAvisosScreenState extends State<QuadroAvisosScreen> {
  @override
  void dispose() {
    super.dispose();
    apiQuadroAvisos();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        // QuadroAvisosScreen.apiQuadroAvisos();
        setState(() {});
      },
      child: buildScaffoldAll(
        context,
        title: 'Quadro de Avisos',
        body: FutureBuilder<dynamic>(
            future: apiQuadroAvisos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingCorresp();
              } else if (snapshot.hasData) {
                if (!snapshot.data['erro']) {
                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data['avisos'].length,
                    itemBuilder: (context, index) {
                      var apiQuadro = snapshot.data['avisos'][index];
                      var idaviso = apiQuadro['idaviso'];
                      var tipo = apiQuadro['tipo'];
                      var titulo = apiQuadro['titulo'];
                      var txt_tipo = apiQuadro['txt_tipo'];
                      var texto = apiQuadro['texto'];
                      var arquivo = apiQuadro['arquivo'];
                      var datahora = DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(apiQuadro['datahora']));
                      bool bolinha = false;
                      if (QuadroAvisosScreen.qntAvisos.contains(idaviso)) {
                        bolinha = true;
                      }
                      return badges.Badge(
                        showBadge: bolinha,
                        position: badges.BadgePosition.custom(
                            start: size.width * 0.83,
                            top: size.height * 0.02,
                            end: -size.width * 0.04),
                        child: MyBoxShadow(
                            // imagem: true,
                            child: ConstsWidget.buildExpandedTile(
                          context,
                          onExpansionChanged: (p0) {
                            if (QuadroAvisosScreen.qntAvisos
                                .contains(idaviso)) {
                              QuadroAvisosScreen.qntAvisos.remove(idaviso);
                            }
                          },
                          title: Column(
                            children: [
                              ConstsWidget.buildTextTitle(
                                context,
                                titulo,
                                textAlign: TextAlign.center,
                              ),
                              ConstsWidget.buildTextSubTitle(context, datahora),
                            ],
                          ),
                          expandedAlignment: Alignment.centerLeft,
                          children: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ConstsWidget.buildTextSubTitle(
                                    context,
                                    texto,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  if (arquivo != '')
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            width: size.width * 0.005,
                                            color: Colors.blue),
                                        shape: StadiumBorder(),
                                      ),
                                      onPressed: () {
                                        launchUrl(Uri.parse(arquivo),
                                            mode: LaunchMode
                                                .externalNonBrowserApplication);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.023),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ConstsWidget.buildTextSubTitle(
                                              context,
                                              'Ver Anexo',
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        )),
                      );
                    },
                  );
                } else {
                  return PageVazia(title: snapshot.data['mensagem']);
                }
              } else {
                return PageErro();
              }
            }),
      ),
    );
  }
}
