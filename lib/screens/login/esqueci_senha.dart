import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/screens/login/login_screen.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
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
          title: ConstsWidget.buildTextTitle(context, 'Recuperar Senha',
              size: SplashScreen.isSmall ? 20 : 24),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: SplashScreen.isSmall
                        ? size.height * 0.02
                        : size.height * 0.03,
                  ),
                  ConstsWidget.buildCachedImage(context,
                      height: 0.2,
                      width: SplashScreen.isSmall
                          ? 0.3
                          : SplashScreen.isSmall
                              ? 0.3
                              : 0.4,
                      iconApi: 'https://a.portariaapp.com/img/logo_azul.png'),
                  // FutureBuilder(
                  //   future: ConstsFuture.apiImageIcon(
                  //       'https://a.portariaapp.com/img/logo_azul.png'),
                  //   builder: (context, snapshot) {
                  //     return SizedBox(
                  //       height: size.height * 0.2,
                  //       width: size.width * 0.5,
                  //       child: snapshot.data,
                  //     );
                  //   },
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    child: ConstsWidget.buildTextTitle(
                        context, 'Portaria App | Condômino',
                        size: 19),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: size.height * 0.1,
                      width: size.width * 0.80,
                      child: ConstsWidget.buildTextTitle(context,
                          'Para recuperar o acesso, informe o email e login do Portaria App',
                          textAlign: TextAlign.center, size: 18)

                      //  Text(
                      //   'Para recuperar o acesso, informe o email cadastrado no Portaria App',
                      //   textAlign: TextAlign.left,
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      // ),
                      ),
                  ConstsWidget.buildCamposObrigatorios(context),
                  buildMyTextFormObrigatorio(context,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validatorless.multiple([
                        Validatorless.email('Preencha com email válido'),
                        Validatorless.required('Preencha com seu e-mail')
                      ]),
                      title: 'Email',
                      autofillHints: [AutofillHints.email],
                      hintText: 'Digite seu email'),
                  buildMyTextFormObrigatorio(context,
                      controller: _loginController,
                      title: 'Login',
                      textCapitalization: TextCapitalization.characters,
                      autofillHints: [AutofillHints.email],
                      validator: Validatorless.multiple(
                          [Validatorless.required('Preencha com seu login')]),
                      hintText: 'Exemplo: joaosilva0102'),
                  ConstsWidget.buildTextSubTitle(
                      context, 'Nome + Sobrenome + 4 digitos do documento',
                      size: 16,
                      color: Consts.kColorRed,
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  ConstsWidget.buildCustomButton(
                    context,
                    'Recuperar Senha',
                    color: Consts.kColorRed,
                    onPressed: () {
                      var validForm = formKey.currentState?.validate() ?? false;
                      if (validForm) {
                        print('Recuperar');
                        ConstsFuture.changeApi(
                                'recupera_senha/?fn=recuperaSenha&email=${_emailController.text}&login=${_loginController.text}')
                            .then((value) {
                          if (!value['erro']) {
                            ConstsFuture.navigatorPopAndPush(
                                context, LoginScreen());
                            buildCustomSnackBar(context,
                                titulo: 'Sucesso!', texto: value['mensagem']);
                          } else {
                            buildCustomSnackBar(context,
                                titulo: 'Algo saiu mal!',
                                hasError: true,
                                texto: value['mensagem']);
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
