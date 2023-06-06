import 'package:app_portaria/consts/consts_widget.dart';
import 'package:flutter/material.dart';

class RespondeDelivery extends StatefulWidget {
  const RespondeDelivery({super.key});

  @override
  State<RespondeDelivery> createState() => _RespondeDeliveryState();
}

class _RespondeDeliveryState extends State<RespondeDelivery> {
  List listRespostas = [0, 1];
  Object? dropRespostas;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildDropRespDelivery() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Container(
          width: double.infinity,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: dropRespostas,
                items: listRespostas.map((e) {
                  String resposta = e == 0 ? 'To ino' : 'Num vo';
                  return DropdownMenuItem(value: e, child: Text(resposta));
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
      title: Text('Responda a Portaria'),
      content: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDropRespDelivery(),
            ConstsWidget.buildCustomButton(
              context,
              'Avisar',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
    ;
  }
}

alertRespondeDelivery(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return RespondeDelivery();
      });
}
