import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';
import '../../widgets/my_text_form_field.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  @override
  Widget build(BuildContext context) {
    return buildScaffoldAll(
      context,
      body: buildHeaderPage(
        context,
        titulo: 'Cadastro',
        subTitulo: 'Quem pode acessar o app',
        widget: MyBoxShadow(
          child: Column(
            children: [
              buildMyTextFormField(context, 'Nome'),
              buildMyTextFormField(context, 'Sobrenome'),
              buildMyTextFormField(context, 'Username'),
              ConstsWidget.buildCustomButton(
                context,
                'Salvar',
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
