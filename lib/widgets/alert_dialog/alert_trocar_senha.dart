import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../../screens/cadastro/morador/cadastro_morador.dart';
import '../my_text_form_field.dart';
import 'alert_all.dart';

trocarSenhaAlert(
  BuildContext context, {
  String? title,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogTrocaSenha(title: title!));
}

class AlertDialogTrocaSenha extends StatefulWidget {
  final String title;
  AlertDialogTrocaSenha({required this.title, super.key});

  @override
  State<AlertDialogTrocaSenha> createState() => _AlertDialogTrocaSenhaState();
}

bool isChecked = false;

class _AlertDialogTrocaSenhaState extends State<AlertDialogTrocaSenha> {
  final formKeySenha = GlobalKey<FormState>();
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
        height: SplashScreen.isSmall ? size.height * 0.45 : size.height * 0.35,
        child: Form(
          key: formKeySenha,
          child: ListView(
            // shrinkWrap: true,
            // physics: ClampingScrollPhysics(),
            children: [
              buildMyTextFormObrigatorio(
                context, title: 'Nova Senha',
                validator: Validatorless.multiple([
                  Validatorless.required('Confirme a senha'),
                  Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                ]),
                controller: widget.title == 'Login'
                    ? CadastroMorador.senhaNovaCtrl
                    : CadastroMorador.retiradaNovaCtrl,
                // onSaved: (text) => formInfosFunc =
                //     formInfosFunc.copyWith(senha: text),
              ),
              buildMyTextFormObrigatorio(
                context, title: 'Confirmar Senha',
                validator: Validatorless.multiple([
                  Validatorless.required('Confirme a senha'),
                  Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                  Validatorless.compare(
                      widget.title == 'Login'
                          ? CadastroMorador.senhaNovaCtrl
                          : CadastroMorador.retiradaNovaCtrl,
                      'Senhas não são iguais'),
                ]),
                controller: widget.title == 'Login'
                    ? CadastroMorador.senhaConfirmCtrl
                    : CadastroMorador.retiradaConfirmCtrl,
                // onSaved: (text) => formInfosFunc =
                //     formInfosFunc.copyWith(senha: text),
              ),
              ConstsWidget.buildPadding001(context,
                  child: ConstsWidget.buildCheckBox(context,
                      isChecked: isChecked,
                      width: size.width * 0.6, onChanged: (value) {
                    setState(
                      () {
                        isChecked = value!;
                        FocusManager.instance.primaryFocus!.unfocus();
                        print(value);
                        widget.title == 'Login'
                            ? CadastroMorador.isSenhaLoginAll = value ? 1 : 0
                            : CadastroMorador.isSenhaRetiradaAll =
                                value ? 1 : 0;
                        print('login: ${CadastroMorador.isSenhaLoginAll}');
                        print(
                            'retirada: ${CadastroMorador.isSenhaRetiradaAll}');
                      },
                    );
                  }, title: 'Trocar em todas as unidade')),
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
                        widget.title == 'Login'
                            ? CadastroMorador.senhaNovaCtrl.clear()
                            : CadastroMorador.retiradaNovaCtrl.clear();

                        widget.title == 'Login'
                            ? CadastroMorador.senhaConfirmCtrl.clear()
                            : CadastroMorador.senhaConfirmCtrl.clear();

                        isChecked = false;
                        widget.title == 'Login'
                            ? CadastroMorador.isSenhaLoginAll = 0
                            : CadastroMorador.isSenhaRetiradaAll = 0;
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

                        if (validSenha && widget.title == 'Login'
                            ? (CadastroMorador.senhaNovaCtrl.text ==
                                    CadastroMorador.senhaConfirmCtrl.text &&
                                CadastroMorador.senhaNovaCtrl.text.length > 6 &&
                                CadastroMorador.senhaConfirmCtrl.text.length >
                                    6)
                            : (CadastroMorador.retiradaNovaCtrl.text ==
                                    CadastroMorador.retiradaConfirmCtrl.text &&
                                CadastroMorador.retiradaNovaCtrl.text.length >
                                    6 &&
                                CadastroMorador
                                        .retiradaConfirmCtrl.text.length >
                                    6)) {
                          isChecked = false;
                          Navigator.pop(context);
                          buildCustomSnackBar(context,
                              titulo: 'Sucesso!',
                              texto: 'Prossiga para salvar os dados');
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
