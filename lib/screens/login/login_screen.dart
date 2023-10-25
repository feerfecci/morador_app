import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/repositories/shared_preferences.dart';
import 'package:morador_app/screens/splash_screen/splash_screen.dart';
import 'package:morador_app/screens/termodeuso/termo_de_uso.dart';
import 'package:morador_app/widgets/my_text_form_field.dart';
import 'package:morador_app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import '../../consts/consts_widget.dart';
import '../politica/politica_screen.dart';
import 'esqueci_senha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final loginCtrl = TextEditingController();
  final passWordCtrl = TextEditingController();
  bool isLoading = false;

  _startLoading() async {
    setState(() {
      isLoading = true;
    });

    ConstsFuture.efetuaLogin(context, loginCtrl.text, passWordCtrl.text)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isObscure = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AutofillGroup(
      child: Form(
          key: formKey,
          child: Scaffold(
            body: ListView(
              children: [
                ConstsWidget.buildPadding001(
                  context,
                  horizontal: 0.02,
                  vertical: 0.03,
                  child: Column(
                    children: [
                      ConstsWidget.buildCachedImage(context,
                          height: 0.2,
                          width: SplashScreen.isSmall ? 0.3 : 0.4,
                          iconApi:
                              'https://a.portariaapp.com/img/logo_azul.png'),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: size.height * 0.035,
                            top: size.height * 0.025),
                        child: ConstsWidget.buildTextTitle(
                            context, 'Portaria App | Condômino',
                            size: 19),
                      ),
                      ConstsWidget.buildCamposObrigatorios(context),
                      buildMyTextFormObrigatorio(context,
                          controller: loginCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validatorless.multiple([
                            Validatorless.required('Preencha com seu login')
                          ]),
                          title: 'Login',
                          autofillHints: [AutofillHints.email],
                          hintText: 'Digite seu Login'),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      buildFormPassword(context,
                          controller: passWordCtrl,
                          autofillHints: [AutofillHints.password],
                          isObscure: isObscure, onTap: (() {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      })),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: size.height * 0.025,
                          top: size.height * 0.02,
                        ),
                        child: ConstsWidget.buildCheckBox(context,
                            isChecked: isChecked, onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                          FocusManager.instance.primaryFocus!.unfocus();
                        }, title: 'Mantenha-me Conectado'),
                      ),
                      ConstsWidget.buildLoadingButton(
                        context,
                        isLoading: isLoading,
                        onPressed: () async {
                          var formValid =
                              formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            if (isChecked) {
                              await LocalPreferences.setUserLogin(
                                loginCtrl.text,
                                passWordCtrl.text,
                              ).then((value) => null);
                              _startLoading();
                            } else {
                              _startLoading();
                            }
                          } else {
                            buildCustomSnackBar(context,
                                titulo: 'Login Errado',
                                hasError: true,
                                texto: 'Tente Verificar os dados preenchidos');
                          }
                        },
                        title: 'Entrar',
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PoliticaScreen(hasDrawer: false),
                                ),
                              );
                            },
                            child: Text(
                              'Política de Privacidade',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TermoDeUsoScreen(
                                    hasDrawer: false,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Recuperar Senha',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EsqueciSenhaScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Termos de Uso',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
