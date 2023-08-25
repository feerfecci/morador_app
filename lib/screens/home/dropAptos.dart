// ignore_for_file: file_names

import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: MyBoxShadow(
        child: Container(
          width: double.maxFinite,
          height:
              SplashScreen.isSmall ? size.height * 0.08 : size.height * 0.06,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            // border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isExpanded: true,
                elevation: 24,
                icon: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).iconTheme.color,
                ),
                borderRadius: BorderRadius.circular(16),
                hint: Text('Selecione Um Apto'),
                // style: TextStyle(
                //     color: Theme.of(context).colorScheme.primary,
                //     fontWeight: FontWeight.w400,
                //     fontSize: 18),
                value: dropAptos,
                items: DropAptos.listAptos.map((e) {
                  return DropdownMenuItem(
                      alignment: Alignment.center,
                      value: e['idunidade'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ConstsWidget.buildTextTitle(
                              context, e['nome_condominio'],
                              size: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstsWidget.buildTextSubTitle(
                                  context, '${e['unidade']} - ',
                                  textAlign: TextAlign.center, size: 16),
                              ConstsWidget.buildTextSubTitle(
                                  context, e['divisao'],
                                  size: 16),
                            ],
                          )
                        ],
                      ));
                }).toList(),
                onChanged: (value) {
                  setState(
                    () {
                      dropAptos = value;
                      ConstsFuture.efetuaLogin(
                          context, InfosMorador.login, InfosMorador.senhaCripto,
                          idUnidade: int.parse('$dropAptos'));
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
