import 'package:app_portaria/consts/consts_future.dart';
import 'package:app_portaria/consts/consts_widget.dart';
import 'package:app_portaria/forms/form_carro.dart';
import 'package:app_portaria/widgets/my_box_shadow.dart';
import 'package:app_portaria/widgets/my_text_form_field.dart';
import 'package:app_portaria/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

import '../../../consts/consts.dart';
import '../../../widgets/snack_bar.dart';
import '../listar_total.dart';

class CadastroCarros extends StatefulWidget {
  final int? idveiculo;
  final int idcond;
  final int idunidade;
  final String tipo;
  final String marca;
  final String modelo;
  final String cor;
  final String placa;
  final String vaga;
  final String datahora;
  const CadastroCarros(
      {this.idveiculo,
      this.idcond = 0,
      this.idunidade = 0,
      this.tipo = '',
      this.marca = '',
      this.modelo = '',
      this.cor = '',
      this.placa = '',
      this.vaga = '',
      this.datahora = '',
      super.key});

  @override
  State<CadastroCarros> createState() => _CadastroCarrosState();
}

class _CadastroCarrosState extends State<CadastroCarros> {
  var keyFormCarros = GlobalKey<FormState>();
  FormInfosCarro formInfosCarro = FormInfosCarro();
  List listTipoCarro = [0, 1, 2];
  Object? getDropTipoCarro;
  @override
  Widget build(BuildContext context) {
    int tipo = 0;
    if (widget.tipo == 'Carro e utilitário') {
      tipo = 0;
    } else if (widget.tipo == 'Moto') {
      tipo = 1;
    } else if (widget.tipo == 'Caminhão e Micro-ônibus') {
      tipo = 2;
    }
    Object? dropTipoCarro = widget.idveiculo == null ? null : tipo;
    var size = MediaQuery.of(context).size;
    Widget buildDropTipo() {
      return StatefulBuilder(builder: (context, setState) {
        return ConstsWidget.buildPadding001(
          context,
          child: Container(
            width: double.infinity,
            height: size.height * 0.07,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: ConstsWidget.buildPadding001(
              context,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    alignment: Alignment.center,
                    value: dropTipoCarro,
                    items: listTipoCarro.map((e) {
                      String tipo = '';
                      if (e == 0) {
                        tipo = 'Carro e utilitário';
                      } else if (e == 1) {
                        tipo = 'Moto';
                      } else if (e == 2) {
                        tipo = 'Caminhão e Micro-ônibus';
                      }
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: e,
                        child: Text(
                          tipo,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value == 0) {
                          dropTipoCarro = 0;
                          formInfosCarro = formInfosCarro.copyWith(
                              tipo: 'Carro e utilitário');
                        } else if (value == 1) {
                          dropTipoCarro = 1;
                          formInfosCarro =
                              formInfosCarro.copyWith(tipo: 'Moto');
                        } else if (value == 2) {
                          dropTipoCarro = 2;
                          formInfosCarro = formInfosCarro.copyWith(
                              tipo: 'Caminhão e Micro-ônibus');
                        }
                      });
                    },
                    elevation: 24,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    hint: Text(
                      'Selecione um tipo',
                      textAlign: TextAlign.center,
                    ),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }

    return buildScaffoldAll(
      context,
      title: widget.idveiculo == null ? 'Adicionar Carro' : 'Editar Carro',
      resizeToAvoidBottomInset: true,
      body: Form(
        key: keyFormCarros,
        child: MyBoxShadow(
          child: Column(
            children: [
              buildDropTipo(),
              buildMyTextFormObrigatorio(
                context,
                title: 'Marcar',
                initialValue: widget.marca,
                onSaved: (text) =>
                    formInfosCarro = formInfosCarro.copyWith(marca: text),
              ),
              buildMyTextFormObrigatorio(
                context,
                title: 'Modelo',
                initialValue: widget.modelo,
                onSaved: (text) =>
                    formInfosCarro = formInfosCarro.copyWith(modelo: text),
              ),
              buildMyTextFormObrigatorio(
                context,
                initialValue: widget.cor,
                title: 'Cor',
                onSaved: (text) =>
                    formInfosCarro = formInfosCarro.copyWith(cor: text),
              ),
              buildMyTextFormObrigatorio(
                initialValue: widget.placa,
                context,
                title: 'Placa',
                onSaved: (text) =>
                    formInfosCarro = formInfosCarro.copyWith(placa: text),
              ),
              buildMyTextFormField(
                context,
                initialValue: widget.vaga,
                title: 'Vaga',
                onSaved: (text) =>
                    formInfosCarro = formInfosCarro.copyWith(vaga: text),
              ),
              ConstsWidget.buildCustomButton(
                context,
                icon: Icons.save_alt,
                'Salvar',
                onPressed: () {
                  var formValid =
                      keyFormCarros.currentState?.validate() ?? false;
                  if (formValid) {
                    keyFormCarros.currentState?.save();
                    String editOrAdd = widget.idveiculo == null
                        ? 'incluirVeiculosUnidade&'
                        : 'editarVeiculosUnidade&idveiculo=${widget.idveiculo}&';
                    ConstsFuture.changeApi(
                            'veiculos/index.php?fn=$editOrAdd&idcond=${InfosMorador.idcondominio}&idunidade=${InfosMorador.idunidade}&tipo=${formInfosCarro.tipo}&marca=${formInfosCarro.marca}&modelo=${formInfosCarro.modelo}&cor=${formInfosCarro.cor}&placa=${formInfosCarro.placa}&vaga=${formInfosCarro.vaga}')
                        .then((value) {
                      if (!value['erro']) {
                        ConstsFuture.navigatorPopAndReplacement(
                            context,
                            ListaTotalUnidade(
                              idunidade: widget.idunidade,
                              tipoAbrir: 2,
                            ));
                        setState(() {});
                        buildCustomSnackBar(context,
                            titulo: 'Parabens', texto: value['mensagem']);
                      } else {
                        buildCustomSnackBar(context,
                            titulo: 'Erro!', texto: value['mensagem']);
                      }
                    });
                  } else {
                    print('object');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
