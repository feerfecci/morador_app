import 'dart:async';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController(text: 'cesarreballo0606r');
  final passWordCtrl = TextEditingController(text: '123456');
  bool isLoading = false;
  _startLoading() async {
    setState(() {
      isLoading = !isLoading;
    });

    Timer(Duration(seconds: 3), () async {
      setState(() {
        ConstsFuture.efetuaLogin(context, emailCtrl.text, passWordCtrl.text);
        isLoading = !isLoading;
      });
    });
  }

  bool isObscure = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTextFormEmail(double sizes) {
      return TextFormField(
        // initialValue: emailSalvo,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: emailCtrl,

        validator: Validatorless.multiple([
          Validatorless.required('Email é obrigatório'),
        ]),
        // autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * sizes),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.black26)),
          hintText: 'Digite seu Email',
        ),
      );
    }

    Widget buildFormPassword(double sizes) {
      return Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: passWordCtrl,
            // autofillHints: [AutofillHints.password],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validatorless.multiple([
              Validatorless.required('Senha é obrigatório'),
              Validatorless.min(6, 'Mínimo de 6 caracteres')
            ]),
            // onEditingComplete: () => TextInput.finishAutofillContext(),
            obscureText: isObscure,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: size.width * sizes),
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black26)),
              hintText: 'Digite sua Senha',
              suffixIcon: GestureDetector(
                onTap: (() {
                  setState(() {
                    isObscure = !isObscure;
                  });
                }),
                child: isObscure
                    ? Icon(Icons.visibility_off_outlined)
                    : Icon(Icons.visibility_outlined),
              ),
            ),
          ),
          CheckboxListTile(
            title: Text('Mantenha-me conectado'),
            value: isChecked,
            activeColor: Consts.kColorApp,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          )
        ],
      );
    }

    return Form(
        key: formKey,
        child: Scaffold(
          body: Center(
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.05),
                        child:
                            ConstsWidget.buildTextTitle(context, 'App Morador'),
                      ),
                      buildTextFormEmail(0.04),
                      SizedBox(
                        height: 20,
                      ),
                      buildFormPassword(0.04),
                      SizedBox(
                        height: 20,
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
                                      emailCtrl.text, passWordCtrl.text)
                                  .then((value) => null);
                              _startLoading();
                            } else {
                              _startLoading();
                            }
                          } else {
                            buildCustomSnackBar(context,
                                titulo: 'Login Errado',
                                texto: 'Tente Verificar os dados preenchidos');
                          }
                        },
                        title: 'Entrar',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
