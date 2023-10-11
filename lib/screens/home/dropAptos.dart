// ignore_for_file: file_names

import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_trocar_senha.dart';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';

class DropAptos extends StatefulWidget {
  const DropAptos({super.key});
  static List listAptos = [];

  @override
  State<DropAptos> createState() => _DropAptosState();
}

class _DropAptosState extends State<DropAptos> {
  Object? dropAptos =
      InfosMorador.idunidade == 0 ? null : InfosMorador.idunidade;
  var i = 0;
  List<DropdownMenuItem> listDrop = [];
  @override
  Widget build(BuildContext context) {
    setState(() {
      i = 0;
    });

    var size = MediaQuery.of(context).size;
    listDrop.clear();
    DropAptos.listAptos.map((e) {
      setState(() {
        i++;
      });

      listDrop.add(
        DropdownMenuItem(
          alignment: Alignment.center,
          value: e['idunidade'],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (i != 1)
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary),
                ),
              if (i != 1)
                SizedBox(
                  height: size.height * 0.01,
                ),
              ConstsWidget.buildTextTitle(context, '${e['nome_condominio']}',
                  size: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstsWidget.buildTextSubTitle(context, '${e['unidade']} - ',
                      textAlign: TextAlign.center, size: 16),
                  ConstsWidget.buildTextSubTitle(context, e['divisao'],
                      size: 16),
                ],
              ),
              // if (i != 1)
            ],
          ),
        ),
      );
      if (i == DropAptos.listAptos.length) {
        listDrop.add(
          DropdownMenuItem(
              alignment: Alignment.center,
              value: 65684613513,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  ConstsWidget.buildTextTitle(
                      context, 'Adicionar Outras Unidades'),
                ],
              )),
        );
      }
    }).toSet();

    return ConstsWidget.buildPadding001(
      context,
      child: Container(
        width: double.maxFinite,
        height: size.height * 0.09,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            // border: Border.all(color: Colors.black26),

            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            elevation: 24, focusColor: Colors.red,
            itemHeight:
                SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.07,
            icon: Icon(
              Icons.arrow_downward,
              color: Theme.of(context).iconTheme.color,
            ),

            borderRadius: BorderRadius.circular(16),

            // itemHeight: 70,
            selectedItemBuilder: (context) {
              return DropAptos.listAptos.map((e) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstsWidget.buildTextTitle(
                        context, '${e['nome_condominio']}',
                        size: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstsWidget.buildTextSubTitle(
                            context, '${e['unidade']} - ',
                            textAlign: TextAlign.center, size: 16),
                        ConstsWidget.buildTextSubTitle(context, e['divisao'],
                            size: 16),
                      ],
                    ),
                  ],
                );
              }).toList();
            },
            // hint: Center(child: Text('Selecione Um Apto')),
            value: dropAptos,
            items: listDrop,
            //  DropAptos.listAptos.map((e) {
            //   setState(() {
            //     i++;
            //   });
            //   print(i);
            //   return DropdownMenuItem(
            //       alignment: Alignment.center,
            //       value: e['idunidade'],
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           if (i != 1)
            //             Container(
            //               height: 1,
            //               decoration: BoxDecoration(color: Colors.black12),
            //             ),
            //           if (i != 1)
            //             SizedBox(
            //               height: size.height * 0.01,
            //             ),
            //           ConstsWidget.buildTextTitle(
            //               context, '${e['nome_condominio']}',
            //               size: 18),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               ConstsWidget.buildTextSubTitle(
            //                   context, '${e['unidade']} - ',
            //                   textAlign: TextAlign.center, size: 16),
            //               ConstsWidget.buildTextSubTitle(
            //                   context, e['divisao'],
            //                   size: 16),
            //             ],
            //           ),
            //           // if (i != 1)
            //         ],
            //       ));
            // }).toList(),
            onChanged: (value) {
              if (value != 65684613513) {
                setState(
                  () {
                    dropAptos = value;
                    ConstsFuture.efetuaLogin(
                        context, InfosMorador.login, InfosMorador.senhaCripto,
                        idUnidade: '$dropAptos');
                  },
                );
              } else {
                trocarSenhaAlert(context, isChecked: true);
              }
            },
          ),
        ),
      ),
    );
  }
}
