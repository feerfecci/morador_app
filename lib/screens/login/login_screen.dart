import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/screens/termodeuso/termo_de_uso.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
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
            body: Center(
              child: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                        bottom: size.height * 0.15),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: FutureBuilder(
                            future: ConstsFuture.apiImageIcon(
                                'https://a.portariaapp.com/img/logo_azul.png'),
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: size.height * 0.2,
                                width: size.width * 0.5,
                                child: snapshot.data,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: size.height * 0.035,
                              top: size.height * 0.025),
                          child: ConstsWidget.buildTextTitle(
                              context, 'Portaria App | Condômino',
                              size: 19),
                        ),
                        buildMyTextFormObrigatorio(context,
                            controller: loginCtrl,
                            keyboardType: TextInputType.emailAddress,
                            title: 'Login',
                            autofillHints: [AutofillHints.email],
                            hintText: 'Digite seu Login'),
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
                            top: size.height * 0.01,
                          ),
                          child: ConstsWidget.buildCheckBox(context,
                              isChecked: isChecked, onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          }, title: 'Mantenha-me conectado'),
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
                                        loginCtrl.text, passWordCtrl.text)
                                    .then((value) => null);
                                _startLoading();
                              } else {
                                _startLoading();
                              }
                            } else {
                              buildCustomSnackBar(context,
                                  titulo: 'Login Errado',
                                  hasError: true,
                                  texto:
                                      'Tente Verificar os dados preenchidos');
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
                                'Termos de Uso',
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
                                'Esqueci minha senha',
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
            ),
          )),
    );
  }
}
