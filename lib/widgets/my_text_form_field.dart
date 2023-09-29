import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

import '../consts/consts_widget.dart';

Widget buildMyTextFormField(BuildContext context,
    {required String title,
    String? mask,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    String? initialValue,
    readOnly = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    final void Function(String? text)? onSaved}) {
  // var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [MaskTextInputFormatter(mask: mask)],
        initialValue: initialValue,
        onSaved: onSaved,
        readOnly: readOnly,
        controller: controller,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        maxLines: 5,
        validator: validator,
        style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
        minLines: 1,
        decoration: buildTextFieldDecoration(
          context,
          title: title,
          hintText: hintText,
        )),
  );
}

InputDecoration buildTextFieldDecoration(BuildContext context,
    {required String title, String? hintText, bool isobrigatorio = false}) {
  var size = MediaQuery.of(context).size;
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.035, vertical: size.height * 0.023),
    filled: true,
    fillColor: Theme.of(context).canvasColor,
    label: isobrigatorio
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstsWidget.buildTextSubTitle(context, title,
                  size: SplashScreen.isSmall ? 14 : 16),
              Text(
                ' *',
                style: TextStyle(
                    fontSize: SplashScreen.isSmall ? 14 : 16,
                    color: Consts.kColorRed),
              ),
            ],
          )
        : ConstsWidget.buildTextSubTitle(context, title,
            size: SplashScreen.isSmall ? 14 : 16),
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
  );
}

Widget buildMyTextFormObrigatorio(BuildContext context,
    {String title = '',
    String mensagem = 'Obrigatório',
    TextInputType? keyboardType,
    String? hintText,
    String? initialValue,
    bool readOnly = false,
    String? mask,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Iterable<String>? autofillHints,
    TextEditingController? controller,
    String? Function(String?)? validator,
    final void Function(String? text)? onSaved}) {
  // var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
      controller: controller, maxLength: maxLength,
      initialValue: initialValue, textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      inputFormatters: [
        MaskTextInputFormatter(mask: mask),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      maxLines: 5,
      minLines: 1,
      readOnly: readOnly,
      autofillHints: autofillHints,
      // onFieldSubmitted: (value) {
      //   value.toString());
      // },
      // onEditingComplete: () {
      //   'onEditingComplete');
      // },
      // onTapOutside: (event) {
      //   'onTapOutside');
      // },
      style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
      validator: validator ??
          Validatorless.multiple([Validatorless.required(mensagem)]),
      decoration: buildTextFieldDecoration(context,
          title: title, hintText: hintText, isobrigatorio: true),
    ),
  );
}

Widget buildFormPassword(BuildContext context,
    {TextEditingController? controller,
    Iterable<String>? autofillHints,
    bool isObscure = false,
    void Function()? onTap}) {
  var size = MediaQuery.of(context).size;
  return Column(
    children: [
      TextFormField(
        textInputAction: TextInputAction.done,
        controller: controller,
        style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
        autofillHints: autofillHints,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: Validatorless.multiple([
          Validatorless.required('Preencha com sua senha de acesso'),
          Validatorless.min(6, 'Mínimo de 6 caracteres')
        ]),
        obscureText: isObscure,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.032, vertical: size.height * 0.023),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary)),
          hintText: 'Digite sua Senha',
          label: RichText(
              text: TextSpan(
                  text: 'Digite sua Senha',
                  style: TextStyle(
                    fontSize: SplashScreen.isSmall ? 14 : 16,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Consts.kColorRed,
                        fontSize: SplashScreen.isSmall ? 14 : 16))
              ])),
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: isObscure
                ? Icon(Icons.visibility_off_outlined,
                    color: Theme.of(context).textTheme.bodyLarge!.color)
                : Icon(Icons.visibility_outlined,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
      ),
      SizedBox(
        height: size.height * 0.01,
      ),
    ],
  );
}
