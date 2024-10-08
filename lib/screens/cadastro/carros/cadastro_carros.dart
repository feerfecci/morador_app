import 'package:morador_app/consts/consts_future.dart';
import 'package:morador_app/consts/consts_widget.dart';
import 'package:morador_app/forms/form_carro.dart';
import 'package:morador_app/widgets/my_box_shadow.dart';
import 'package:morador_app/widgets/my_text_form_field.dart';
import 'package:morador_app/widgets/scaffold_all.dart';
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

// Object? getDropTipoCarro;

class _CadastroCarrosState extends State<CadastroCarros> {
  final keyFormCarros = GlobalKey<FormState>();
  FormInfosCarro formInfosCarro = FormInfosCarro();
  List listTipoCarro = [0, 1, 2];
  @override
  Widget build(BuildContext context) {
    int tipoApi = 0;
    if (widget.tipo == 'Carro ou Utilitário') {
      tipoApi = 0;
      formInfosCarro = formInfosCarro.copyWith(tipo: 'Carro ou Utilitário');
    } else if (widget.tipo == "Moto") {
      tipoApi = 1;
      formInfosCarro = formInfosCarro.copyWith(tipo: 'Moto');
    } else if (widget.tipo == 'Caminhão ou Micro-ônibus') {
      tipoApi = 2;
      formInfosCarro =
          formInfosCarro.copyWith(tipo: 'Caminhão ou Micro-ônibus');
    }
    Object? dropTipoCarro = widget.idveiculo == null ? null : tipoApi;
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
              border: Border.all(color: Theme.of(context).colorScheme.primary),
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
                      String tipoTexto = '';
                      if (e == 0) {
                        tipoTexto = 'Carro ou Utilitário';
                      } else if (e == 1) {
                        tipoTexto = 'Moto';
                      } else if (e == 2) {
                        tipoTexto = 'Caminhão ou Micro-ônibus';
                      }
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: e,
                        child: Text(
                          tipoTexto,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value == 0) {
                          dropTipoCarro = 0;
                          formInfosCarro = formInfosCarro.copyWith(
                              tipo: 'Carro ou Utilitário');
                        } else if (value == 1) {
                          dropTipoCarro = 1;
                          formInfosCarro =
                              formInfosCarro.copyWith(tipo: 'Moto');
                        } else if (value == 2) {
                          dropTipoCarro = 2;
                          formInfosCarro = formInfosCarro.copyWith(
                              tipo: 'Caminhão ou Micro-ônibus');
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
                      'Selecione um Tipo',
                      textAlign: TextAlign.center,
                    ),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
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
      title: widget.idveiculo == null ? 'Adicionar Veículo' : 'Editar Veículo',
      resizeToAvoidBottomInset: true,
      body: MyBoxShadow(
        child: Form(
          key: keyFormCarros,
          child: Column(
            children: [
              ConstsWidget.buildCamposObrigatorios(context),
              buildDropTipo(),
              Column(
                children: [
                  buildMyTextFormObrigatorio(
                    context,
                    title: 'Marca',
                    initialValue: widget.marca,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (text) =>
                        formInfosCarro = formInfosCarro.copyWith(marca: text),
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    title: 'Modelo',
                    initialValue: widget.modelo,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (text) =>
                        formInfosCarro = formInfosCarro.copyWith(modelo: text),
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    initialValue: widget.cor,
                    textCapitalization: TextCapitalization.words,
                    title: 'Cor',
                    onSaved: (text) =>
                        formInfosCarro = formInfosCarro.copyWith(cor: text),
                  ),
                  buildMyTextFormObrigatorio(
                    initialValue: widget.placa,
                    context,
                    title: 'Placa',
                    textCapitalization: TextCapitalization.characters,
                    // maxLength: 7,
                    keyboardType: TextInputType.text,
                    // mask: '#######',
                    onSaved: (text) =>
                        formInfosCarro = formInfosCarro.copyWith(placa: text),
                  ),
                  buildMyTextFormField(
                    context,
                    initialValue: widget.vaga,
                    title: 'Vaga',
                    // mask: '#######',
                    onSaved: (text) =>
                        formInfosCarro = formInfosCarro.copyWith(vaga: text),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.height * 0.015, top: size.height * 0.01),
                child: ConstsWidget.buildCustomButton(
                  context,
                  // icon: Icons.save_alt,
                  'Salvar',
                  color: Consts.kColorRed,
                  onPressed: () {
                    var formValid =
                        keyFormCarros.currentState?.validate() ?? false;
                    FocusManager.instance.primaryFocus!.unfocus();
                    if (formValid && formInfosCarro.tipo != null) {
                      keyFormCarros.currentState?.save();
                      String editOrAdd = widget.idveiculo == null
                          ? 'incluirVeiculosUnidade&'
                          : 'editarVeiculosUnidade&idveiculo=${widget.idveiculo}&';
                      ConstsFuture.changeApi(
                              'veiculos/index.php?fn=$editOrAdd&idcond=${InfosMorador.idcondominio}&idmorador=${InfosMorador.idmorador}&idunidade=${InfosMorador.idunidade}&tipo=${formInfosCarro.tipo}&marca=${formInfosCarro.marca}&modelo=${formInfosCarro.modelo}&cor=${formInfosCarro.cor}&placa=${formInfosCarro.placa}&vaga=${formInfosCarro.vaga}')
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
                              titulo: 'Sucesso', texto: value['mensagem']);
                        } else {
                          buildCustomSnackBar(context,
                              hasError: true,
                              titulo: 'Algo saiu mal!',
                              texto: value['mensagem']);
                        }
                      });
                    } else {
                      buildCustomSnackBar(context,
                          hasError: true,
                          titulo: 'Algo saiu mal!',
                          texto: 'Selecione um tipo de Veículo');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
