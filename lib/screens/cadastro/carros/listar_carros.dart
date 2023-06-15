// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/screens/cadastro/carros/cadastro_carros.dart';
import 'package:app_portaria/widgets/row_infos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_widget.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/page_vazia.dart';

class ListarCarros extends StatefulWidget {
  const ListarCarros({super.key});

  @override
  State<ListarCarros> createState() => _ListarCarrosState();
}

Future apiCarros() async {
  var url = Uri.parse(
      '${Consts.apiUnidade}veiculos/index.php?fn=listarVeiculosUnidade&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}');
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
    return Column(
      children: [
        ConstsWidget.buildCustomButton(
          context,
          'Adicionar Carros',
          icon: Icons.add,
          onPressed: () {
            ConstsFuture.navigatorPageRoute(context, CadastroCarros());
          },
        ),
        FutureBuilder<dynamic>(
          future: apiCarros(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Algo deu errado');
            } else {
              if (snapshot.hasData && snapshot.data['erro']) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: PageVazia(title: snapshot.data['mensagem']),
                );
              } else {
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
                        buildRowInfos(context,
                            title1: 'Tipo:',
                            subTitle1: tipo,
                            title2: 'Marca',
                            subTitle2: marca),
                        buildRowInfos(context,
                            title1: 'Modelo:',
                            subTitle1: modelo,
                            title2: 'Cor',
                            subTitle2: cor),
                        buildRowInfos(context,
                            title1: 'Placa',
                            subTitle1: placa,
                            title2: 'Vaga',
                            subTitle2: vaga),
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
                    ));
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}
