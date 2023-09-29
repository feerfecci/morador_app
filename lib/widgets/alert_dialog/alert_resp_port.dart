import 'dart:convert';

import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../consts/consts.dart';

class RespondeDelivery extends StatefulWidget {
  final int? tipoAviso;
  const RespondeDelivery({required this.tipoAviso, super.key});

  @override
  State<RespondeDelivery> createState() => _RespondeDeliveryState();
}

class _RespondeDeliveryState extends State<RespondeDelivery> {
  List listRespostas = [];
  Object? dropRespostas;
  @override
  void initState() {
    super.initState();
    mensagensResponsta();
  }

  Future<dynamic> mensagensResponsta() async {
    var url = Uri.parse(
        '${Consts.apiUnidade}msgsprontas/index.php?fn=listarMensagens&tipo=${widget.tipoAviso}&idmorador=${InfosMorador.idmorador}&idcond=${InfosMorador.idcondominio}');
    var resposta = await get(url);
    if (resposta.statusCode == 200) {
      var jsonReponse = json.decode(resposta.body);
      setState(() {
        listRespostas = jsonReponse['msgsprontas'];
      });
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildDropRespDelivery() {
      return ConstsWidget.buildPadding001(
        context,
        child: Container(
          width: double.infinity,
          height: size.height * 0.075,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                elevation: 24,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).iconTheme.color,
                ),
                borderRadius: BorderRadius.circular(16),
                hint: Text('Selecione Uma Resposta'),
                alignment: Alignment.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                value: dropRespostas,
                items: listRespostas.map((e) {
                  return DropdownMenuItem(
                      value: e['idmsg'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: size.height * 0.025,
                              width: size.width * 0.9,
                              child: ConstsWidget.buildTextTitle(
                                  context, e['titulo'],
                                  overflow: TextOverflow.ellipsis)),
                          SizedBox(
                              height: size.height * 0.025,
                              width: size.width * 0.9,
                              child: ConstsWidget.buildTextSubTitle(
                                  context, e['texto'])),
                        ],
                      ));
                }).toList(),
                onChanged: (value) {
                  setState(
                    () {
                      dropRespostas = value;
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      title: Text(
        'Responda a Portaria',
        textAlign: TextAlign.center,
      ),
      // alignment: Alignment.center,
      content: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDropRespDelivery(),
            ConstsWidget.buildCustomButton(
              context,
              'Responder',
              color: Consts.kColorRed,
              onPressed: () {
                ConstsFuture.changeApi(
                        'respostas/index.php?fn=enviarRespostas&idcond=${InfosMorador.idcondominio}&idmsg=$dropRespostas&idmorador=${InfosMorador.idmorador}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}')
                    .then((value) {
                  if (!value['erro']) {
                    Navigator.pop(context);
                    buildCustomSnackBar(context,
                        titulo: 'Obrigado!', texto: value['mensagem']);
                  } else {
                    buildCustomSnackBar(context,
                        hasError: true,
                        titulo: 'Algo de Errado!',
                        texto: 'Tente Novamente!');
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

alertRespondeDelivery(BuildContext context, {required int tipoAviso}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return RespondeDelivery(
        tipoAviso: tipoAviso,
      );
    },
  );
}
