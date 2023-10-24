// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/screens/cadastro/carros/cadastro_carros.dart';
import 'package:morador_app/screens/cadastro/loading_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_widget.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/page_erro.dart';
import '../../../widgets/page_vazia.dart';

class ListarCarros extends StatefulWidget {
  const ListarCarros({super.key});

  @override
  State<ListarCarros> createState() => _ListarCarrosState();
}

Future apiCarros() async {
  //print('listarVeiculosUnidade');
  var url = Uri.parse(
      '${Consts.apiUnidade}veiculos/index.php?fn=listarVeiculosUnidade&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}&idunidade=${InfosMorador.idunidade}');
  var resposta = await get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}

class _ListarCarrosState extends State<ListarCarros> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildRowInfos(BuildContext context,
        {required String title1,
        required String subTitle1,
        required String title2,
        required String subTitle2,
        MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
      return ConstsWidget.buildPadding001(
        context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstsWidget.buildTextSubTitle(context, title1),
                  ConstsWidget.buildTextTitle(context, subTitle1),
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstsWidget.buildTextSubTitle(context, title2),
                  ConstsWidget.buildTextTitle(context, subTitle2),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ConstsWidget.buildPadding001(
          context,
          child: ConstsWidget.buildCustomButton(
            context,
            'Adicionar Veículos',
            color: Consts.kColorRed,
            // icon: Icons.add,
            onPressed: () {
              // ConstsFuture.navigatorPageRoute(context, CadastroCarros());
              ConstsFuture.show(context, page: CadastroCarros());
            },
          ),
        ),
        FutureBuilder<dynamic>(
          future: apiCarros(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingCadastro();
            } else if (snapshot.hasData) {
              if (!snapshot.data['erro']) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data['ListaVeiculosUnidade'].length,
                  itemBuilder: (context, index) {
                    var apiVeiculos =
                        snapshot.data['ListaVeiculosUnidade'][index];
                    int idveiculo = apiVeiculos['idveiculo'];
                    int idcond = apiVeiculos['idcond'];
                    int idunidade = apiVeiculos['idunidade'];
                    String tipo = apiVeiculos['tipo'];
                    String marca = apiVeiculos['marca'];
                    String modelo = apiVeiculos['modelo'];
                    String cor = apiVeiculos['cor'];
                    String placa = apiVeiculos['placa'];
                    String vaga = apiVeiculos['vaga'];
                    String datahora = apiVeiculos['datahora'];
                    return MyBoxShadow(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstsWidget.buildPadding001(
                            context,
                            horizontal: 0.02,
                            vertical: 0,
                            child: Column(
                              children: [
                                buildRowInfos(context,
                                    title1: 'Tipo',
                                    subTitle1: tipo,
                                    title2: 'Marca',
                                    subTitle2: marca),
                                buildRowInfos(context,
                                    title1: 'Modelo',
                                    subTitle1: modelo,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    title2: 'Cor',
                                    subTitle2: cor),
                                buildRowInfos(context,
                                    title1: 'Placa',
                                    subTitle1: placa,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    title2: 'Vaga',
                                    subTitle2: vaga)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          ConstsWidget.buildCustomButton(
                              context, 'Editar Veículo',
                              onPressed: () => ConstsFuture.navigatorPageRoute(
                                    context,
                                    CadastroCarros(
                                      cor: cor,
                                      idunidade: idunidade,
                                      idveiculo: idveiculo,
                                      marca: marca,
                                      modelo: modelo,
                                      placa: placa,
                                      tipo: tipo,
                                      vaga: vaga,
                                    ),
                                  ))
                        ],
                      ),
                    );
                  },
                );
              } else {
                return ConstsWidget.buildPadding001(
                  context,
                  child: PageVazia(title: snapshot.data['mensagem']),
                );
              }
            } else {
              return PageErro();
            }
          },
        ),
      ],
    );
  }
}
