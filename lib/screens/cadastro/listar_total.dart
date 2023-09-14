// ignore_for_file: non_constant_identifier_names, unused_local_variable
import 'package:app_portaria/screens/cadastro/morador/listar_morador.dart';
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

bool isChecked = false;

class _ListaTotalUnidadeState extends State<ListaTotalUnidade> {
  int filtrar = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Widget buildFiltroCadastro(String title, int tipoLista) {
    //   return ConstsWidget.buildCustomButton(
    //     context,
    //     title,
    //     onPressed: () {
    //       // isCheckedMorador = true;
    //       // isCheckedCarros = false;
    //       // isCheckedFuncionarios = false;
    //       setState(() {});
    //     },
    //   );
    // }

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          // apiMoradores();
        });
      },
      child: buildScaffoldAll(
        context,
        title: 'Cadastro',
        body: Column(
          children: [
            ConstsWidget.buildPadding001(
              context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConstsWidget.buildOutlinedButton(
                    context,
                    title: '    Moradores    ',
                    fontSize: 18,
                    backgroundColor: filtrar == 0 ? Colors.grey[300] : null,
                    onPressed: () {
                      setState(() {
                        filtrar = 0;
                        isChecked = false;
                      });
                    },
                  ),
                  ConstsWidget.buildOutlinedButton(
                    context,
                    title: '        Veículos        ',
                    fontSize: 18,
                    backgroundColor: filtrar == 1 ? Colors.grey[300] : null,
                    onPressed: () {
                      setState(() {
                        filtrar = 1;
                        isChecked = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            //listar morador
            if (filtrar == 0) ListarMorador(),
            //listar carros
            if (filtrar == 1) ListarCarros(),
            //listar funcionarios
            // if (isCheckedFuncionarios)
            //   Column(
            //     children: const [MyBoxShadow(child: Text('Funcionarios'))],
            //   ),
          ],
        ),
      ),
    );
  }
}
