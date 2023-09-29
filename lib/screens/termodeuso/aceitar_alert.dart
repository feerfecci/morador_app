import 'dart:convert';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import '../home/home_page.dart';

class AceitarTermosScreen extends StatefulWidget {
  final int? idUnidade;
  const AceitarTermosScreen({required this.idUnidade, super.key});

  @override
  State<AceitarTermosScreen> createState() => _AceitarTermosScreenState();
}

politicaApi() async {
  final url = Uri.parse(
      '${Consts.apiUnidade}termo_uso/?fn=mostrarTermo&idcond=${InfosMorador.idcondominio}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    return null;
  }
}

bool isChecked = false;

class _AceitarTermosScreenState extends State<AceitarTermosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      content: SizedBox(
        width: size.width * 0.98,
        child: Column(
          children: [
            FutureBuilder<dynamic>(
                future: politicaApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      var texto = snapshot.data['termo_uso'][0]['texto'];
                      return SizedBox(
                        height: SplashScreen.isSmall
                            ? size.height * 0.57
                            : size.height * 0.63,
                        child: ListView(
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: size.height * 0.04),
                            //   child: Image(
                            //     image: NetworkImage(
                            //         '${logado.arquivoAssets}logo-login-f.png'),
                            //   ),
                            // ),
                            Html(
                              data: texto,
                              style: {
                                'p': Style(
                                    fontSize: FontSize(16),
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color),
                                'i': Style(
                                    fontSize: FontSize(16),
                                    fontStyle: FontStyle.italic),
                                'ul': Style(fontSize: FontSize(14)),
                                'strong': Style(
                                    fontSize: FontSize(16),
                                    fontWeight: FontWeight.bold)
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                }),
            StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical: size.height * 0.04),
                  //   child: Image(
                  //     image: NetworkImage(
                  //         '${logado.arquivoAssets}logo-login-f.png'),
                  //   ),
                  // ),
                  ConstsWidget.buildCheckBox(context, isChecked: isChecked,
                      onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  }, title: 'Li e aceito os termos'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ConstsWidget.buildOutlinedButton(
                      //   context,
                      //   title: '  Cancelar  ',
                      //   onPressed: () {
                      //     widget.idUnidade == null
                      //         ? Navigator.pop(context)
                      //         : ConstsFuture
                      //             .navigatorPopAndReplacement(
                      //                 context, LoginScreen());
                      //   },
                      // ),
                      ConstsWidget.buildCustomButton(
                        context,
                        'Aceitar',
                        rowSpacing: 0.13,
                        color: isChecked ? Consts.kColorRed : Colors.grey,
                        onPressed: isChecked
                            ? () {
                                ConstsFuture.changeApi(
                                        'termo_uso/?fn=aceitaTermo&idmorador=${InfosMorador.idmorador}')
                                    .then((value) {
                                  if (!value['erro']) {
                                    widget.idUnidade == null
                                        ? ConstsFuture.navigatorPopAndPush(
                                            context, HomePage())
                                        : Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ),
                                            (route) => false);
                                  } else {
                                    buildCustomSnackBar(context,
                                        titulo: 'Algo saiu mal!',
                                        hasError: true,
                                        texto: value['mensagem']);
                                  }
                                });
                              }
                            : () {},
                      )
                    ],
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
