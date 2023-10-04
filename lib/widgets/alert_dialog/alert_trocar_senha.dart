import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../screens/cadastro/morador/cadastro_morador.dart';
import '../my_text_form_field.dart';
import 'alert_all.dart';

trocarSenhaAlert(BuildContext context, {bool isChecked = false}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogTrocaSenha(isChecked: isChecked));
}

class AlertDialogTrocaSenha extends StatefulWidget {
  bool isChecked;
  AlertDialogTrocaSenha({this.isChecked = false, super.key});

  @override
  State<AlertDialogTrocaSenha> createState() => _AlertDialogTrocaSenhaState();
}

class _AlertDialogTrocaSenhaState extends State<AlertDialogTrocaSenha> {
  final formKeySenha = GlobalKey<FormState>();
  TextEditingController senhaNovaCtrl = TextEditingController();
  TextEditingController senhaConfirmCtrl = TextEditingController();
  int isSenhaLoginAll = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      title: Center(
          child: Text(
        'Senha Padrão',
        style: TextStyle(fontSize: 20),
      )),
      content: SizedBox(
        width: size.width * 0.8,
        height: SplashScreen.isSmall ? size.height * 0.35 : size.height * 0.28,
        child: Form(
          key: formKeySenha,
          child: ListView(
            // shrinkWrap: true,
            // physics: ClampingScrollPhysics(),
            children: [
              buildMyTextFormObrigatorio(
                context,
                title: 'Nova Senha',
                validator: Validatorless.multiple([
                  Validatorless.required('Confirme a senha'),
                  Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                ]),
                controller: senhaNovaCtrl,
              ),
              buildMyTextFormObrigatorio(
                context,
                title: 'Confirmar Senha',
                validator: Validatorless.multiple([
                  Validatorless.required('Confirme a senha'),
                  Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                  Validatorless.compare(senhaNovaCtrl, 'Senhas não são iguais'),
                ]),
                controller: senhaConfirmCtrl,
              ),
              ConstsWidget.buildPadding001(
                context,
                horizontal: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Cancelar',
                      rowSpacing: 0.06,
                      onPressed: () {
                        Navigator.pop(context);
                        senhaNovaCtrl.clear();

                        senhaConfirmCtrl.clear();
                        isSenhaLoginAll = 0;
                      },
                    ),
                    Spacer(),
                    ConstsWidget.buildCustomButton(
                      context,
                      'Salvar',
                      color: Consts.kColorRed,
                      rowSpacing: 0.04,
                      onPressed: () {
                        var validSenha =
                            formKeySenha.currentState?.validate() ?? false;
                        FocusManager.instance.primaryFocus!.unfocus();

                        if (validSenha &&
                            (senhaNovaCtrl.text == senhaConfirmCtrl.text &&
                                senhaNovaCtrl.text.length >= 6 &&
                                senhaConfirmCtrl.text.length >= 6)) {
                          widget.isChecked = false;
                          Navigator.pop(context);

                          ConstsFuture.changeApi(
                                  'moradores/?fn=mudarSenhas&mudasenhalogin=1&mudasenharetirada=0&login=${InfosMorador.login}&idmorador=${InfosMorador.idmorador}&senha=${senhaNovaCtrl.text}')
                              .then((value) {
                            if (!value['erro']) {
                              // buildCustomSnackBar(context,
                              //     titulo: 'Acesso Unificado',
                              //     texto:
                              //         'Refaça o login para ter todos os acessos');
                            } else {
                              // buildCustomSnackBar(context,
                              //     titulo: 'Algo Saiu Mau',
                              //     hasError: true,
                              //     texto: value['mensagem']);
                            }
                          });
                        } else {
                          // buildCustomSnackBar(context,
                          //     hasError: true,
                          //     titulo: 'Algo Saiu Mau',
                          //     texto: 'Tente Novamente!');
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
