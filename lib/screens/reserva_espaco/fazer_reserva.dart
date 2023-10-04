import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/screens/reserva_espaco/listar_espacos.dart';
import 'package:app_portaria/widgets/date_picker.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import '../../widgets/scaffold_all.dart';

class FazerReserva extends StatefulWidget {
  final String nomeEspaco;
  final String descricaoEspaco;
  final List dataReservada;
  final int idespaco;
  const FazerReserva(
      {required this.nomeEspaco,
      required this.dataReservada,
      required this.descricaoEspaco,
      required this.idespaco,
      super.key});

  @override
  State<FazerReserva> createState() => _FazerReservaState();
}

String? dataSelected;

class _FazerReservaState extends State<FazerReserva> {
  final TextEditingController dataCtrl = TextEditingController();
  final keyReserva = GlobalKey<FormState>();

  bool isLoading = false;

  startReserva() {
    // var ano = dataCtrl.text.substring(6);
    //   var mes = dataCtrl.text.substring(3, 5);
    //   var dia = dataCtrl.text.substring(0, 2);

    ConstsFuture.changeApi(
            'reserva_espacos/?fn=solicitarReserva&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&idespaco=${widget.idespaco}&datareserva=${MyDatePicker.dataSelected}:00')
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (!value['erro']) {
        Navigator.pop(context);
        ConstsFuture.navigatorPopAndPush(
          context,
          ListarEspacos(),
        );
        buildCustomSnackBar(context,
            titulo: 'Muito Obrigado', texto: value['mensagem']);
        setState(() {
          MyDatePicker.dataSelected = '';
        });
      } else {
        buildCustomSnackBar(context,
            hasError: true, titulo: 'Algo saiu mal', texto: value['mensagem']);
      }
    });
  }

  @override
  void initState() {
    MyDatePicker.dataSelected = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      title: widget.nomeEspaco,
      body: MyBoxShadow(
        child: Form(
          key: keyReserva,
          child: ConstsWidget.buildPadding001(
            context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildTextSubTitle(
                      context, widget.descricaoEspaco,
                      textAlign: TextAlign.center, size: 16),
                ),
                ConstsWidget.buildPadding001(context,
                    child: MyDatePicker(
                      dataSelected: dataSelected,
                      // type: DateTimePickerType.date,
                      dataReservada: widget.dataReservada,
                    )),
                // ConstsWidget.buildPadding001(
                //   context,
                //   child: SizedBox(
                //     width: size.width * 0.35,
                //     child: buildMyTextFormObrigatorio(context,
                //         controller: dataCtrl,
                //         title: 'Data',
                //         mask: '##/##/####',
                //         hintText: '25/09/1997'),
                //   ),
                // ),
                ConstsWidget.buildLoadingButton(
                  context,
                  color: Consts.kColorRed,
                  onPressed: () {
                    var formValid =
                        keyReserva.currentState?.validate() ?? false;
                    if (formValid && MyDatePicker.dataSelected != '') {
                      setState(() {
                        isLoading = true;
                      });
                      startReserva();
                    } else {
                      buildCustomSnackBar(context,
                          hasError: true,
                          titulo: 'Cuidado!',
                          texto: 'Selecione uma data');
                    }
                  },
                  isLoading: isLoading,
                  title: 'Solicitar Reserva',
                ),
                // ConstsWidget.buildCustomButton(
                //   context,
                //   'Solicitar Reserva',
                //   onPressed: () {
                //     var formValid =
                //         keyReserva.currentState?.validate() ?? false;
                //     if (formValid) {
                //       //print(dataCtrl.text);
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
