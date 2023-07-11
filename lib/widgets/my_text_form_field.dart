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
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [MaskTextInputFormatter(mask: mask)],
      initialValue: initialValue,
      onSaved: onSaved,
      readOnly: readOnly,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      maxLines: 5,
      style: TextStyle(),
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: size.width * 0.02),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text(title),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    ),
  );
}

Widget buildMyTextFormObrigatorio(BuildContext context,
    {String title = '',
    String mensagem = 'Preencha',
    TextInputType? keyboardType,
    String? hintText,
    String? initialValue,
    bool readOnly = false,
    String? mask,
    TextEditingController? controller,
    String? Function(String?)? validator,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
      controller: controller,
      initialValue: initialValue,
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
      // onFieldSubmitted: (value) {
      //   value.toString());
      // },
      // onEditingComplete: () {
      //   'onEditingComplete');
      // },
      // onTapOutside: (event) {
      //   'onTapOutside');
      // },

      validator: Validatorless.multiple([Validatorless.required(mensagem)]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035, vertical: size.height * 0.023),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text(title),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    ),
  );
}

Widget buildFormPassword(BuildContext context,
    {TextEditingController? controller,
    bool isObscure = false,
    void Function()? onTap}) {
  var size = MediaQuery.of(context).size;
  return Column(
    children: [
      TextFormField(
        textInputAction: TextInputAction.done,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: Validatorless.multiple([
          Validatorless.required('Senha é obrigatório'),
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
              borderSide: BorderSide(color: Colors.black26)),
          hintText: 'Digite sua Senha',
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: isObscure
                ? Icon(Icons.visibility_off_outlined)
                : Icon(Icons.visibility_outlined),
          ),
        ),
      ),
      SizedBox(
        height: size.height * 0.01,
      ),
    ],
  );
}
