import 'package:morador_app/consts/consts.dart';
import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/consts/consts_widget.dart';
import 'package:morador_app/screens/reserva_espaco/listar_espacos.dart';
import 'package:morador_app/widgets/date_picker.dart';
import 'package:morador_app/widgets/my_box_shadow.dart';
import 'package:morador_app/widgets/snack_bar.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/scaffold_all.dart';
import '../splash_screen/splash_screen.dart';

class FazerReserva extends StatefulWidget {
  final String nomeEspaco;
  final String descricaoEspaco;
  final List dataReservadaIni;
  final List dataReservadaFim;
  final int idespaco;
  const FazerReserva(
      {required this.nomeEspaco,
      required this.dataReservadaIni,
      required this.dataReservadaFim,
      required this.descricaoEspaco,
      required this.idespaco,
      super.key});

  @override
  State<FazerReserva> createState() => _FazerReservaState();
}

class _FazerReservaState extends State<FazerReserva> {
  //inicio
  Object? dropHorasInicio;
  String dataInicioSelected = '';
  String horaInicioSelected = '';
  List listHorasInicio = [];

  //termino
  Object? dropHorasTermino;
  String dataTermminoSelected = '';
  String horaTermminoSelected = '';
  List listHorasTermino = [];

  //variáveis para condicoes
  var x = 0;
  var y = 0;
  int intHoraIni = 0;
  int intHoraFim = 0;
  List listParaRemover = [];

  //loading
  bool isLoading = false;

  startReserva() {
    ConstsFuture.changeApi(
            'reserva_espacos/?fn=solicitarReserva&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&idespaco=${widget.idespaco}&datareservaini=$dataInicioSelected $horaInicioSelected&datareservafim=$dataTermminoSelected $horaTermminoSelected')
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
    dataInicioSelected = '';
    dataTermminoSelected = '';
    setDatasToList();
    // criarListaHorasInicio();
  }

  updateDatasToList() {
    if (dataInicioSelected != '') {
      for (var i = 0; i <= widget.dataReservadaIni.length - 1; i++) {
        if (dataInicioSelected ==
            DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(widget.dataReservadaIni[i]))) {
          formatDatasIniTerm(i);
          listHorasInicio.map((e) {
            if ((int.parse(e['valueHora']) >= intHoraIni &&
                int.parse(e['valueHora']) <= intHoraFim)) {
              setState(() {
                if (!listParaRemover.contains(e['valueHora'])) {
                  listParaRemover.add(e['valueHora']);
                }
              });
            }
          }).toSet();
          if (listParaRemover.isNotEmpty) {
            setState(() {
              y = 0;
            });
            removeDatasReservadas();
          }
        }
      }
    }
  }

  formatDatasIniTerm(int i) {
    intHoraIni = int.parse(
      DateFormat('H').format(
        DateTime.parse(widget.dataReservadaIni[i]),
      ),
    );
    intHoraFim = int.parse(
      DateFormat('H').format(
        DateTime.parse(widget.dataReservadaFim[i]),
      ),
    );
  }

  removeDatasReservadas() {
    do {
      if (x <= listParaRemover.length - 1) {
        if (listHorasInicio[y]['valueHora'] == listParaRemover[x]) {
          setState(() {
            listHorasInicio.removeWhere(
                (element) => element['valueHora'] == listParaRemover[x]);
            listHorasTermino.removeWhere(
                (element) => element['valueHora'] == listParaRemover[x]);
            x++;
            y--;
            print('x = $x');
          });
        }
      }
      setState(() {
        y++;
      });
    } while (y <= listHorasInicio.length - listParaRemover.length);
  }

  Future setDatasToList() async {
    for (var i = 0; i <= 23; i++) {
      NumberFormat formartter = NumberFormat('00');
      String formatHora = formartter.format(i);
      listHorasInicio.add({'valueHora': formatHora, 'hora': '$formatHora:00'});
      listHorasTermino.add({'valueHora': formatHora, 'hora': '$formatHora:00'});
    }
    return listHorasInicio;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildDropHoras(
        List listHora, Object? dropValue, int tipoHoraSelected) {
      return StatefulBuilder(builder: (context, setState) {
        return ConstsWidget.buildPadding001(
          context,
          child: Container(
            width: size.width * 0.375,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                // border: Border.all(color: Colors.black26),

                borderRadius: BorderRadius.all(Radius.circular(16)),
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                elevation: 24, focusColor: Colors.red,
                itemHeight: SplashScreen.isSmall
                    ? size.height * 0.09
                    : size.height * 0.07,
                icon: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).iconTheme.color,
                ),
                borderRadius: BorderRadius.circular(16),
                hint: Center(
                  child: ConstsWidget.buildTextSubTitle(
                    context,
                    'Hora',
                  ),
                ),
                // itemHeight: 70,

                selectedItemBuilder: (context) {
                  return listHora.map((e) {
                    return Center(
                      child: ConstsWidget.buildTextTitle(
                          context, '${e['hora']}',
                          size: 18),
                    );
                  }).toList();
                },
                value: dropValue,
                items: listHora.map((e) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: e['valueHora'],
                    child: Center(
                      child: ConstsWidget.buildTextTitle(
                        context,
                        e['hora'],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  // if (MyDatePicker.dataSelected != '') {
                  setState(() {
                    dropValue = value;
                    listHora.map((e) {
                      if (e['valueHora'] == value.toString()) {
                        if (tipoHoraSelected == 0) {
                          horaInicioSelected = e['hora'];
                        } else {
                          horaTermminoSelected = e['hora'];
                        }
                      }
                    }).toSet();
                    print(dropValue);
                  });
                  // } else {
                  //   buildCustomSnackBar(context,
                  //       hasError: true,
                  //       titulo: 'Cuidado',
                  //       texto: 'Selecione Uma data');
                  // }
                },
              ),
            ),
          ),
        );
      });
    }

    Widget buildDatePickerReserva({required int tipoDataSelected}) {
      return StatefulBuilder(builder: (context, setState) {
        return Theme(
          data: Theme.of(context).copyWith(
            dataTableTheme: DataTableThemeData(
              decoration: BoxDecoration(color: Colors.red),
            ),
            colorScheme: ColorScheme.light(
              onBackground: Theme.of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor!,
              primary: Theme.of(context).colorScheme.primary,
              surface: Theme.of(context).canvasColor,
              onPrimary: Theme.of(context).textTheme.bodyLarge!.color!,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ),
          child: DateTimePicker(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: size.height * 0.045,
              ),
              filled: true,
              fillColor: Theme.of(context).canvasColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              hintText:
                  tipoDataSelected == 0 ? 'Data de Início' : 'Data de Término',
              hintStyle: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            type: DateTimePickerType.date,

            // selectableDayPredicate: (DateTime dateTime) {
            //   // if (data_reservada.isNotEmpty) {
            //   //   for (var i = 0; i <= data_reservada.length - 1; i++) {
            //   //     String dataRes = data_reservada[i];
            //   //     if ('${dateTime.year}-${dateTime.month}-${dateTime.day}' ==
            //   //         '${DateTime.parse(dataRes).year}-${DateTime.parse(dataRes).month}-${DateTime.parse(dataRes).day} 00:00:00.000') {
            //   //       return false;
            //   //     }
            //   //   }
            //   // } else {
            //   //   return true;
            //   // }

            //   // return true;
            // },
            initialDate: tipoDataSelected == 0
                ? DateTime.now()
                : dataInicioSelected != ''
                    ? DateTime.parse('$dataInicioSelected 00:00')
                    : DateTime.now(),
            dateMask: 'dd/MM/yyyy',

            firstDate: tipoDataSelected == 0
                ? DateTime.now()
                : dataInicioSelected != ''
                    ? DateTime.parse('$dataInicioSelected 00:00')
                    : DateTime.now(),
            lastDate: DateTime(2100),
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            textAlign: TextAlign.center,
            cancelText: 'Cancelar',
            confirmText: 'Selecionar',
            dateLabelText: 'Date Time',
            locale: Locale('pt', 'BR'),
            use24HourFormat: true,
            calendarTitle: 'Selecione uma Data e Hora',

            onChanged: (val) {
              // setDatasToList();
              setState(() {
                // isDataSelected == true;
                listParaRemover.clear();
                if (tipoDataSelected == 0) {
                  dataInicioSelected = val;
                  updateDatasToList();
                } else {
                  dataTermminoSelected = val;
                  updateDatasToList();
                }
              });
            },
            // enabled: enabled,
            // validator: (val) {
            //   setState(() => _valueToValidate2 = val ?? '');
            //   return null;
            // },
            // onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
          ),
        );
      });
    }

    return buildScaffoldAll(
      context,
      title: widget.nomeEspaco,
      body: MyBoxShadow(
        child: ConstsWidget.buildPadding001(
          context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildTextSubTitle(
                    context,
                    widget.descricaoEspaco,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ConstsWidget.buildSeparated(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstsWidget.buildTextSubTitle(
                        context,
                        'Data de Início',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: ConstsWidget.buildPadding001(
                          context,
                          child: buildDatePickerReserva(tipoDataSelected: 0),
                        ),
                      ),
                    ],
                  ),
                  // if (isDataSelected)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstsWidget.buildTextSubTitle(
                        context,
                        'Horário de Início',
                        textAlign: TextAlign.center,
                      ),
                      buildDropHoras(listHorasInicio, dropHorasInicio, 0),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              // if (dropHorasInicio != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstsWidget.buildTextSubTitle(
                        context,
                        'Data de Término',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: ConstsWidget.buildPadding001(context,
                            child: buildDatePickerReserva(tipoDataSelected: 1)
                            // MyDatePicker(
                            //   dataSelected: dataSelected,
                            //   hintText: 'Data de Término',
                            //   type: DateTimePickerType.date,
                            //   dataReservada: widget.dataReservada,
                            // ),
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstsWidget.buildTextSubTitle(
                        context,
                        'Horário de Término',
                        textAlign: TextAlign.center,
                      ),
                      // FutureBuilder(
                      //     future: setDatasToList(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return CircularProgressIndicator();
                      //       } else if (snapshot.hasData) {
                      //         List listHoraSnap = snapshot.data;
                      //         Object? dropValueSnap;
                      //         return StatefulBuilder(
                      //             builder: (context, setState) {
                      //           return ConstsWidget.buildPadding001(
                      //             context,
                      //             child: Container(
                      //               width: size.width * 0.375,
                      //               decoration: BoxDecoration(
                      //                   color: Theme.of(context).canvasColor,
                      //                   // border: Border.all(color: Colors.black26),

                      //                   borderRadius: BorderRadius.all(
                      //                       Radius.circular(16)),
                      //                   border: Border.all(
                      //                       color: Theme.of(context)
                      //                           .colorScheme
                      //                           .primary)),
                      //               child: DropdownButtonHideUnderline(
                      //                 child: DropdownButton(
                      //                   isExpanded: true,
                      //                   elevation: 24,
                      //                   focusColor: Colors.red,
                      //                   itemHeight: SplashScreen.isSmall
                      //                       ? size.height * 0.09
                      //                       : size.height * 0.07,
                      //                   icon: Icon(
                      //                     Icons.arrow_downward,
                      //                     color:
                      //                         Theme.of(context).iconTheme.color,
                      //                   ),
                      //                   borderRadius: BorderRadius.circular(16),
                      //                   hint: Center(
                      //                     child: ConstsWidget.buildTextSubTitle(
                      //                       context,
                      //                       'Hora',
                      //                     ),
                      //                   ),
                      //                   // itemHeight: 70,

                      //                   selectedItemBuilder: (context) {
                      //                     return listHoraSnap.map((e) {
                      //                       return Center(
                      //                         child:
                      //                             ConstsWidget.buildTextTitle(
                      //                                 context, '${e['hora']}',
                      //                                 size: 18),
                      //                       );
                      //                     }).toList();
                      //                   },
                      //                   value: dropValueSnap,
                      //                   items: listHoraSnap.map((e) {
                      //                     return DropdownMenuItem(
                      //                       alignment: Alignment.center,
                      //                       value: e['valueHora'],
                      //                       child: Center(
                      //                         child:
                      //                             ConstsWidget.buildTextTitle(
                      //                           context,
                      //                           e['hora'],
                      //                         ),
                      //                       ),
                      //                     );
                      //                   }).toList(),
                      //                   onChanged: (value) {
                      //                     // if (MyDatePicker.dataSelected != '') {
                      //                     setState(() {
                      //                       dropValueSnap = value;
                      //                       /*  listHoraSnap.map((e) {
                      //       if (e['valueHora'] == value) {
                      //         if (tipoHoraSelected == 0) {
                      //           horaInicioSelected = e['hora'];
                      //         } else {
                      //           horaTermminoSelected = e['hora'];
                      //         }
                      //       }
                      //     }).toSet();*/
                      //                       print(horaInicioSelected);
                      //                     });
                      //                     // } else {
                      //                     //   buildCustomSnackBar(context,
                      //                     //       hasError: true,
                      //                     //       titulo: 'Cuidado',
                      //                     //       texto: 'Selecione Uma data');
                      //                     // }
                      //                   },
                      //                 ),
                      //               ),
                      //             ),
                      //           );
                      //         });
                      //       } else {
                      //         return Text('Selecione uma data');
                      //       }
                      //     }),
                      buildDropHoras(listHorasTermino, dropHorasTermino, 1),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              ConstsWidget.buildLoadingButton(
                context,
                color: Consts.kColorRed,
                onPressed: () {
                  int horaNow =
                      DateTime.parse('$dataInicioSelected $horaInicioSelected')
                          .difference(DateTime.now())
                          .inHours;
                  print([
                    'Data inicio: $dataInicioSelected - Hora inicio $horaInicioSelected',
                    'Data termino $dataTermminoSelected - Hora termino $horaTermminoSelected'
                  ]);
                  // var formValid =
                  //     keyReserva.currentState?.validate() ?? false;
                  if (dataInicioSelected != '' &&
                      dataTermminoSelected != '' &&
                      horaInicioSelected != '' &&
                      horaTermminoSelected != '') {
                    if (horaNow <= 1) {
                      buildCustomSnackBar(context,
                          hasError: true,
                          titulo: 'Horário incorreto',
                          texto:
                              'Selecione um horário à frente da data e horário atuais');
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      startReserva();
                    }
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
              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
