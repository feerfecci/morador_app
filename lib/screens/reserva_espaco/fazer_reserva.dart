import 'dart:async';
import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/screens/reserva_espaco/listar_espacos.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import '../../widgets/scaffold_all.dart';

class FazerReserva extends StatefulWidget {
  final String nomeEspaco;
  final String descricaoEspaco;
  final int idespaco;
  const FazerReserva(
      {required this.nomeEspaco,
      required this.descricaoEspaco,
      required this.idespaco,
      super.key});

  @override
  State<FazerReserva> createState() => _FazerReservaState();
}

class _FazerReservaState extends State<FazerReserva> {
  final TextEditingController dataCtrl = TextEditingController();
  final keyReserva = GlobalKey<FormState>();
  bool isLoading = false;
  startReserva() {
    Timer(Duration(seconds: 2), () {
      var ano = dataCtrl.text.substring(6);
      var mes = dataCtrl.text.substring(3, 5);
      var dia = dataCtrl.text.substring(0, 2);

      ConstsFuture.changeApi(
              '${Consts.apiUnidade}reserva_espacos/?fn=solicitarReserva&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&idespaco=${widget.idespaco}&datareserva=${'$ano-$mes-$dia'}')
          .then((value) {
        setState(() {
          isLoading = !isLoading;
        });
        if (!value['erro']) {
          Navigator.pop(context);
          ConstsFuture.navigatorPopAndPush(
            context,
            ListarEspacos(),
          );
          buildCustomSnackBar(context,
              titulo: 'Muito Obrigado', texto: value['mensagem']);
        } else {
          buildCustomSnackBar(context,
              titulo: 'Algo Saiu Mal', texto: value['mensagem']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      title: widget.nomeEspaco,
      body: MyBoxShadow(
        child: Form(
          key: keyReserva,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstsWidget.buildTextTitle(context, 'Descrição', size: 18),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: ConstsWidget.buildTextSubTitle(
                      context, widget.descricaoEspaco,
                      textAlign: TextAlign.center, size: 16),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: SizedBox(
                    width: size.width * 0.35,
                    child: buildMyTextFormObrigatorio(context,
                        controller: dataCtrl,
                        title: 'Data',
                        mask: '##/##/####',
                        hintText: '25/09/1997'),
                  ),
                ),
                ConstsWidget.buildLoadingButton(context,
                    color: Consts.kColorRed, onPressed: () {
                  var formValid = keyReserva.currentState?.validate() ?? false;
                  if (formValid) {
                    setState(() {
                      isLoading = !isLoading;
                    });
                    startReserva();
                  }
                }, isLoading: isLoading, title: 'Solicitar Reserva'),
                // ConstsWidget.buildCustomButton(
                //   context,
                //   'Solicitar Reserva',
                //   onPressed: () {
                //     var formValid =
                //         keyReserva.currentState?.validate() ?? false;
                //     if (formValid) {
                //       print(dataCtrl.text);
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
