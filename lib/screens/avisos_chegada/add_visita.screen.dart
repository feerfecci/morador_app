import 'dart:math';

import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/consts_widget.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/snack_bar.dart';
import '../splash_screen/splash_screen.dart';

class AddVisitaScreen extends StatefulWidget {
  const AddVisitaScreen({super.key});

  @override
  State<AddVisitaScreen> createState() => _AddVisitaScreenState();
}

bool isLoading = false;
String? newDate;
String? dataSelected;

class _AddVisitaScreenState extends State<AddVisitaScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController dataCtrl = TextEditingController();
  final keyEmail = GlobalKey<FormState>();
  List<String> listEmailVisita = [];
  List<bool> retornoListErro = <bool>[];
  bool contemErro = false;
  String horaAPIVisita = '';
  // String anoVisita = '';
  // String mesVisita = '';
  // String diaVisita = '';
  String horaVisita = '';
  String minutoVisita = '';
  void starLogin() {
    setState(() {
      isLoading == false;
    });
    if (emailCtrl.text != '') {
      buildCustomSnackBar(context,
          titulo: 'Cuidado', texto: 'Adicione o email à lista');
    } else if (MyDatePicker.dataSelected == '') {
      buildCustomSnackBar(context,
          titulo: 'Cuidado', texto: 'Adicione uma Data de Visita');
    } else {
      forEnviaConvite().then((value) {
        contemErro = retornoListErro.contains(true);
        setState(() {
          isLoading = false;
        });
        if (!contemErro) {
          Navigator.pop(context);
          buildCustomSnackBar(context,
              titulo: 'Muito Bem', texto: 'Aviso(s) enviado(s) com sucesso');
          setState(() {
            MyDatePicker.dataSelected == '';
          });
        } else {
          buildCustomSnackBar(context,
              titulo: 'Que pena!', texto: 'Algum email não foi enviado');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildListaEmailConvid() {
      return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: listEmailVisita.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstsWidget.buildPadding001(
                        context,
                        child: ConstsWidget.buildTextSubTitle(
                          context,
                          'Email do Convidado',
                        ),
                      ),
                      ConstsWidget.buildTextTitle(
                          context, listEmailVisita[index]),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: size.width * 0.085,
                    height: size.height * 0.045,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: size.height * 0.0005),
                        side: BorderSide(
                            width: size.width * 0.005, color: Colors.blue),
                        shape: CircleBorder(),
                      ),
                      onPressed: () {
                        setState(() {
                          listEmailVisita.remove(listEmailVisita[index]);
                        });
                        // var validForm =
                        //     keyEmail.currentState?.validate() ?? false;
                        // if (validForm) {
                        //   setState(() {
                        //     listEmailVisita.add(emailCtrl.text);
                        //     //print(listEmailVisita);
                        //   });
                        // }
                      },
                      child: Center(
                        child: Icon(Icons.close, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                color: Colors.grey[300],
                height: 1,
              ),
            ],
          );
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          emailCtrl.clear();
          dataCtrl.clear();
          listEmailVisita.clear();
          horaVisita = '';
          minutoVisita = '';
          isLoading = false;
          newDate = null;
          dataSelected = null;
        });
      },
      child: buildScaffoldAll(
        context,
        title: 'Agendar Visita',
        body: Column(
          children: [
            MyBoxShadow(
                child: Column(
              children: [
                Form(
                  key: keyEmail,
                  child: Row(
                    children: [
                      SizedBox(
                        width: SplashScreen.isSmall
                            ? size.width * 0.7
                            : size.width * 0.75,
                        child: buildMyTextFormField(context,
                            controller: emailCtrl,
                            title: 'Email',
                            validator: Validatorless.multiple([
                              Validatorless.required('Preencha'),
                              Validatorless.email(
                                  'Preencha com um email válido')
                            ]),
                            keyboardType: TextInputType.emailAddress),
                      ),
                      Spacer(),
                      SizedBox(
                        // width: size.width * 0.12,
                        // height: size.height * 0.06,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.center,
                            padding:
                                EdgeInsets.only(right: size.height * 0.0005),
                            side: BorderSide(
                                width: size.width * 0.005, color: Colors.blue),
                            shape: CircleBorder(),
                          ),
                          onPressed: () {
                            var formValid =
                                keyEmail.currentState?.validate() ?? false;
                            if (formValid && emailCtrl.text != '') {
                              setState(() {
                                listEmailVisita.add(emailCtrl.text);
                                emailCtrl.clear();
                              });
                            } else {
                              buildCustomSnackBar(context,
                                  titulo: 'Cuidado',
                                  texto: 'Selecione pelo menos uma email');
                            }
                          },
                          child: Center(
                            child: Icon(Icons.add, color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildTextTitle(
                      context, 'Informações do horário da visita'),
                ),
                MyDatePicker(
                    dataSelected: dataSelected,
                    lista: listEmailVisita), // Column(
                //   children: [
                //     // Row(
                //     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     //   children: [
                //     //     // ConstsWidget.buildCustomButton(
                //     //     //   context,
                //     //     //   newDate != null ? newDate! : 'Selecione uma Data',
                //     //     //   onPressed: () {
                //     //     //     DatePickerDialog(
                //     //     //         initialDate: DateTime.now(),
                //     //     //         firstDate: DateTime.now(),
                //     //     //         lastDate: DateTime(2033));
                //     //     // dataSelected = await showDatePicker(
                //     //     //     context: context,
                //     //     //     locale: const Locale('pt', 'BR'),
                //     //     //     confirmText: 'Selecionar',
                //     //     //     cancelText: 'Cancelar',
                //     //     //     helpText: 'Selecione uma data',
                //     //     //     initialDate: DateTime.now(),
                //     //     //     firstDate: DateTime.now(),
                //     //     //     lastDate: DateTime(2033));
                //     //     // if (dataSelected != null) {
                //     //     //   setState(() {
                //     //     //     newDate = DateFormat('dd/MM/yyyy')
                //     //     //         .format(dataSelected!);
                //     //     //     // var transformDate = ;
                //     //     //     //print(
                //     //     //         'data do picker ${dataSelected?.year}-0${dataSelected?.month}-0${dataSelected?.day}');
                //     //     //   });
                //     //     // }
                //     //     //   },
                //     //     // ),
                //     //     SizedBox(
                //     //       width: size.width * 0.2,
                //     //       child: buildMyTextFormField(context,
                //     //           title: 'Horário',
                //     //           mask: '##:##',
                //     //           controller: dataCtrl,
                //     //           hintText: '14:30',
                //     //           keyboardType: TextInputType.number),
                //     //     ),
                //     //   ],
                //     // ),
                //   ],
                // ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                if (listEmailVisita.isNotEmpty)
                  Column(
                    children: [
                      MyBoxShadow(
                        child: ConstsWidget.buildPadding001(context,
                            horizontal: 0.02, child: buildListaEmailConvid()),
                      ),
                      ConstsWidget.buildPadding001(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ConstsWidget.buildOutlinedButton(
                              context,
                              title: 'Cancelar',
                              onPressed: () {
                                listEmailVisita.clear();
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            ConstsWidget.buildLoadingButton(
                              context,
                              color: Consts.kColorRed,
                              isLoading: isLoading,
                              horizontal: 0.05,
                              title: 'Confirmar',
                              onPressed: () {
                                if (listEmailVisita.isNotEmpty &&
                                    emailCtrl.text.isEmpty &&
                                    MyDatePicker.dataSelected != '') {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // anoVisita = dataCtrl.text.substring(6, 10);
                                  // mesVisita = dataCtrl.text.substring(3, 5);
                                  // diaVisita = dataCtrl.text.substring(0, 2);
                                  // horaVisita = dataCtrl.text.substring(11, 13);
                                  // minutoVisita = dataCtrl.text.substring(14, 16);
                                  //  horaAPIVisita = dataCtrl.text;
                                  starLogin();
                                } else {
                                  buildCustomSnackBar(context,
                                      titulo: 'Cuidado',
                                      texto: 'Preencha os dados');
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ],
            )),
          ],
        ),
      ),
    );
  }

  Future forEnviaConvite() async {
    for (var i = 0; i <= (listEmailVisita.length - 1); i++) {
      await ConstsFuture.changeApi(
              'convida_visita/?fn=enviaconvite&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&email=${listEmailVisita[i]}&datahora=${MyDatePicker.dataSelected}')
          .then((value) {
        retornoListErro.add(value['erro']);
      });
    }
  }
}
