import 'package:morador_app/consts/consts.dart';
import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/widgets/my_box_shadow.dart';
import 'package:morador_app/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
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
          hasError: true, titulo: 'Cuidado', texto: 'Adicione o email à lista');
    } else if (MyDatePicker.dataSelected == '') {
      buildCustomSnackBar(context,
          hasError: true,
          titulo: 'Cuidado',
          texto: 'Adicione uma Data de Visita');
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
            MyDatePicker.dataSelected = '';
          });
        } else {
          buildCustomSnackBar(context,
              hasError: true,
              titulo: 'Que pena!',
              texto: 'Algum email não foi enviado');
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
              if (index != listEmailVisita.length - 1)
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
        title: 'Convidar Visita',
        body: Column(
          children: [
            MyBoxShadow(
                child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: SplashScreen.isSmall
                          ? size.width * 0.7
                          : size.width * 0.75,
                      child: buildMyTextFormField(context,
                          controller: emailCtrl,
                          title: 'Email',
                          keyboardType: TextInputType.emailAddress),
                    ),
                    Spacer(),
                    SizedBox(
                      // width: size.width * 0.12,
                      // height: size.height * 0.06,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: size.height * 0.0005),
                          side: BorderSide(
                              width: size.width * 0.005, color: Colors.blue),
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          // var formValid =
                          //     keyEmail.currentState?.validate() != null
                          //         ? listEmailVisita.isEmpty
                          //             ? true
                          //             : false
                          //         : false;
                          if (emailCtrl.text != '') {
                            setState(() {
                              listEmailVisita.add(emailCtrl.text);
                              emailCtrl.clear();
                            });
                          } else {
                            buildCustomSnackBar(context,
                                titulo: 'Cuidado',
                                hasError: true,
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
                SizedBox(
                  height: size.height * 0.01,
                ),
                MyDatePicker(
                    dataSelected: dataSelected,
                    lista: listEmailVisita,
                    hintText: 'Escolha o Dia e Horário da Visita'),
                // Column(
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1),
                            borderRadius: BorderRadius.circular(16)),
                        child: ConstsWidget.buildPadding001(context,
                            horizontal: 0.02, child: buildListaEmailConvid()),
                      ),
                      ConstsWidget.buildPadding001(
                        context,
                        vertical: 0.02,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ConstsWidget.buildOutlinedButton(
                              context,
                              title: 'Cancelar',
                              rowSpacing: SplashScreen.isSmall ? 0.06 : 0.08,
                              onPressed: () {
                                listEmailVisita.clear();
                                MyDatePicker.dataSelected = '';
                                Navigator.pop(context);
                              },
                            ),
                            Spacer(),
                            ConstsWidget.buildLoadingButton(
                              context,
                              color: Consts.kColorRed,
                              isLoading: isLoading,
                              title: 'Convidar',
                              rowSpacing: SplashScreen.isSmall ? 0.06 : 0.08,
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
                                      hasError: true,
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
