import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:email_validator/email_validator.dart';
import 'package:validatorless/validatorless.dart';

import '../../widgets/my_text_form_field.dart';
import '../splash_screen/splash_screen.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _loginController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ConstsWidget.buildTextTitle(context, 'Esqueci Minha Senha',
              size: SplashScreen.isSmall ? 20 : 24),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: size.height * 0.1,
                        width: size.width * 0.80,
                        child: ConstsWidget.buildTextTitle(context,
                            'Para recuperar o acesso, informe o email e login do Portaria App',
                            size: 18)

                        //  Text(
                        //   'Para recuperar o acesso, informe o email cadastrado no Portaria App',
                        //   textAlign: TextAlign.left,
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w300,
                        //   ),
                        // ),
                        ),
                    buildMyTextFormObrigatorio(context,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validatorless.multiple([
                          Validatorless.email('Preencha com email válido'),
                          Validatorless.required('Obrigatório')
                        ]),
                        title: 'Email',
                        autofillHints: [AutofillHints.email],
                        hintText: 'Digite seu email'),
                    buildMyTextFormObrigatorio(context,
                        controller: _loginController,
                        title: 'Login',
                        autofillHints: [AutofillHints.email],
                        hintText: 'Exemplo: joaosilva0102'),
                    ConstsWidget.buildTextSubTitle(context,
                        'Seu login é composto pelo Primeiro e Último nome, e os 4 primeiros números do seu documento',
                        size: 16,
                        color: Consts.kColorRed,
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    ConstsWidget.buildCustomButton(
                      context,
                      'Recurar Senha',
                      onPressed: () {
                        var validForm =
                            formKey.currentState?.validate() ?? false;
                        if (validForm) {
                          print('Recuperar');
                          ConstsFuture.changeApi(
                                  'recupera_senha/?fn=recuperaSenha&email=${_emailController.text}&login=${_loginController.text}')
                              .then((value) {
                            if (!value['erro']) {
                              ConstsFuture.navigatorPopAndPush(
                                  context, LoginScreen());
                            } else {
                              buildCustomSnackBar(context,
                                  titulo: 'Algo Saiu Mau!',
                                  texto: value['mensagem']);
                            }
                          });
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
