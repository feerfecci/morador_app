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
  static int? tipoAbrir;
  const ListaTotalUnidade(
      {super.key, this.idunidade, this.numero, this.idvisisao, tipoAbrir});

  @override
  State<ListaTotalUnidade> createState() => _ListaTotalUnidadeState();
}

bool isChecked = false;
int filtrar = ListaTotalUnidade.tipoAbrir ?? 0;

class _ListaTotalUnidadeState extends State<ListaTotalUnidade> {
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
        title: 'Cadastros',
        body: Column(
          children: [
            ConstsWidget.buildPadding001(
              context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  filtrar == 0
                      ? ConstsWidget.buildCustomButton(
                          context,
                          'Condôminos',
                          rowSpacing: 0.03,
                          onPressed: () {
                            setState(() {
                              filtrar = 1;
                              isChecked = false;
                            });
                          },
                        )
                      : ConstsWidget.buildOutlinedButton(
                          context,
                          title: 'Condôminos',
                          rowSpacing: 0.075,
                          fontSize: 18,
                          onPressed: () {
                            setState(() {
                              filtrar = 0;
                              isChecked = false;
                            });
                          },
                        ),
                  filtrar == 1
                      ? ConstsWidget.buildCustomButton(
                          context,
                          'Veículos',
                          rowSpacing: 0.05,
                          onPressed: () {
                            setState(() {
                              filtrar = 1;
                              isChecked = false;
                            });
                          },
                        )
                      : ConstsWidget.buildOutlinedButton(
                          context,
                          title: 'Veículos',
                          fontSize: 18,
                          rowSpacing: 0.12,
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
