// ignore_for_file: non_constant_identifier_names, unused_local_variable
import 'package:app_portaria/consts/consts.dart';
import 'package:app_portaria/screens/cadastro/morador/listar_morador.dart';
import 'package:app_portaria/widgets/header.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import '../../consts/consts_widget.dart';
import 'carros/listar_carros.dart';

class ListaTotalUnidade extends StatefulWidget {
  final int? idunidade;
  final String? numero;
  final int? idvisisao;
  final int? tipoAbrir;
  const ListaTotalUnidade(
      {super.key,
      this.idunidade,
      this.numero,
      this.idvisisao,
      required this.tipoAbrir});

  @override
  State<ListaTotalUnidade> createState() => _ListaTotalUnidadeState();
}

class _ListaTotalUnidadeState extends State<ListaTotalUnidade> {
  bool isCheckedMorador = true;
  bool isCheckedCarros = false;
  bool isCheckedFuncionarios = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildFiltroCadastro(String title, int tipoLista) {
      return ConstsWidget.buildCustomButton(
        context,
        title,
        onPressed: () {
          setState(() {
            if (tipoLista == 1) {
              isCheckedMorador = true;
              isCheckedCarros = false;
              isCheckedFuncionarios = false;
            } else if (tipoLista == 2) {
              isCheckedCarros = true;
              isCheckedMorador = false;
              isCheckedFuncionarios = false;
            } else if (tipoLista == 3) {
              isCheckedFuncionarios = true;
              isCheckedCarros = false;
              isCheckedMorador = false;
            }
          });
        },
      );
    }

    return buildScaffoldAll(
      context,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            apiMoradores();
          });
        },
        child: buildHeaderPage(
          context,
          titulo: 'Cadastro',
          subTitulo: '${InfosMorador.divisao} - ${InfosMorador.numero}',
          widget: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFiltroCadastro('Morador', 1),
                    buildFiltroCadastro('Carros', 2),
                    buildFiltroCadastro('Funcionarios', 3),
                  ],
                ),
              ),
              //listar morador
              if (isCheckedMorador) ListarMorador(),
              //listar carros
              if (isCheckedCarros) ListarCarros(),
              //listar funcionarios
              if (isCheckedFuncionarios)
                Column(
                  children: const [MyBoxShadow(child: Text('Funcionarios'))],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
