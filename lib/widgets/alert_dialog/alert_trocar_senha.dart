import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../my_text_form_field.dart';
import 'alert_all.dart';

trocarSenhaAlert(
  BuildContext context, {
  required GlobalKey<FormState> formkeySenha,
  required TextEditingController atualSenhaCtrl,
  required TextEditingController novaSenhaCtrl,
  required TextEditingController confirmSenhaCtrl,
  String? title,
}) {
  showDialogAll(context,
      children: [
        Form(
          key: formkeySenha,
          child: Column(
            children: [
              buildMyTextFormObrigatorio(
                context, title: 'Nova Senha',
                validator: Validatorless.multiple([
                  Validatorless.required('Confirme a senha'),
                  Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                ]),
                controller: novaSenhaCtrl,
                // onSaved: (text) => formInfosFunc =
                //     formInfosFunc.copyWith(senha: text),
              ),
              buildMyTextFormObrigatorio(
                context, title: 'Confirmar Senha',
                validator: Validatorless.multiple([
                  Validatorless.required('Confirme a senha'),
                  Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                  Validatorless.compare(novaSenhaCtrl, 'Senhas não são iguais'),
                ]),
                controller: confirmSenhaCtrl,
                // onSaved: (text) => formInfosFunc =
                //     formInfosFunc.copyWith(senha: text),
              ),
              ConstsWidget.buildPadding001(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Cancelar',
                      onPressed: () {
                        Navigator.pop(context);
                        atualSenhaCtrl.clear();
                        novaSenhaCtrl.clear();
                        confirmSenhaCtrl.clear();
                      },
                    ),
                    Spacer(),
                    ConstsWidget.buildCustomButton(
                      context,
                      'Salvar',
                      color: Consts.kColorRed,
                      onPressed: () {
                        var validSenha =
                            formkeySenha.currentState?.validate() ?? false;
                        if (validSenha &&
                            novaSenhaCtrl.text == confirmSenhaCtrl.text) {
                          Navigator.pop(context);
                          buildCustomSnackBar(context,
                              titulo: 'Senha Alterada!',
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
      ],
      title: title == null ? 'Trocar Senha' : 'Trocar Senha$title');
}
