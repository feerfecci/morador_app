import 'dart:convert';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../forms/form_morador.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/scaffold_all.dart';
import 'listar_moradores.dart';

class CadastroMorador extends StatefulWidget {
  int? idmorador;
  bool ativo;
  String? nome_morador;
  String? login;
  String nascimento;
  String? telefone;
  String? ddd;
  String? email;
  String? documento;
  int? acesso;
  int? idunidade;
  int? iddivisao = InfosMorador.iddivisao;
  String? numero;
  CadastroMorador(
      {this.idmorador,
      this.nome_morador,
      this.login,
      this.telefone,
      this.ddd,
      this.email,
      this.nascimento = '',
      this.documento,
      this.acesso,
      this.idunidade,
      this.ativo = true,
      this.iddivisao,
      this.numero,
      super.key});

  @override
  State<CadastroMorador> createState() => _CadastroMoradorState();
}

class _CadastroMoradorState extends State<CadastroMorador> {
  List listAtivo = [1, 0];

  Object? dropdownValueAtivo;
  @override
  void initState() {
    super.initState();
    _formInfosMorador = _formInfosMorador.copyWith(ativo: widget.ativo ? 1 : 0);
    _formInfosMorador = _formInfosMorador.copyWith(acesso: widget.acesso);
  }

  final _formKeyMorador = GlobalKey<FormState>();
  FormInfosMorador _formInfosMorador = FormInfosMorador();
  String loginGerado = '';

  @override
  Widget build(BuildContext context) {
    @override
    var dataParsed = widget.nascimento != ''
        ? DateFormat('dd/MM/yyy').format(DateTime.parse(widget.nascimento))
        : '';
    var acessoApi = _formInfosMorador.acesso == 0 ? false : true;
    bool isChecked = acessoApi;
    String dataLogin = '';
    var size = MediaQuery.of(context).size;

    return buildScaffoldAll(
      context,
      resizeToAvoidBottomInset: true,
      body: buildHeaderPage(
        context,
        titulo: widget.idmorador == null ? 'Incluir Morador' : 'Editar Morador',
        subTitulo: widget.idmorador == null
            ? 'Adicionar Morador'
            : 'Adicione um morador',
        widget: Form(
          key: _formKeyMorador,
          child: MyBoxShadow(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // buildAtivoInativo2(
                    //   context,
                    // ),
                    buildMyTextFormObrigatorio(
                      context,
                      title: 'Nome Completo',
                      initialValue: widget.nome_morador,
                      onSaved: (text) => _formInfosMorador =
                          _formInfosMorador.copyWith(nome_morador: text),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.37,
                          child: buildMyTextFormObrigatorio(context,
                              initialValue: dataParsed,
                              title: 'Data de Nascimento',
                              keyboardType: TextInputType.number,
                              mask: '##/##/####',
                              hintText: '##/##/####', onSaved: (text) {
                            // var replace = text!.replaceAll('/', '-');

                            var ano = text!.substring(6);
                            var mes = text.substring(3, 5);
                            var dia = text.substring(0, 2);
                            dataLogin = '$dia$mes';
                            // print(replace);

                            _formInfosMorador = _formInfosMorador.copyWith(
                                nascimento: '$ano-$mes-$dia');
                          }),
                        ),
                        SizedBox(
                          width: size.width * 0.5,
                          child: buildMyTextFormObrigatorio(
                            context,
                            title: 'Documento',
                            initialValue: widget.documento,
                            keyboardType: TextInputType.number,
                            hintText: 'RG, CPF',
                            onSaved: (text) => _formInfosMorador =
                                _formInfosMorador.copyWith(documento: text),
                          ),
                        )
                      ],
                    ),
                    //Contatos
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: ConstsWidget.buildTextTitle(context, 'Contatos'),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.145,
                          child: buildMyTextFormObrigatorio(context,
                              initialValue: widget.ddd,
                              onSaved: (text) => _formInfosMorador =
                                  _formInfosMorador.copyWith(ddd: text),
                              title: 'DDD',
                              keyboardType: TextInputType.number,
                              mask: '##',
                              hintText: '11'),
                        ),
                        SizedBox(
                          width: size.width * 0.1,
                        ),
                        SizedBox(
                          width: size.width * 0.5,
                          child: buildMyTextFormObrigatorio(
                            context,
                            initialValue: widget.telefone,
                            title: 'Telefone',
                            keyboardType: TextInputType.number,
                            mask: '# ########',
                            hintText: '9 11223344',
                            onSaved: (text) => _formInfosMorador =
                                _formInfosMorador.copyWith(telefone: text),
                          ),
                        ),
                      ],
                    ),
                    buildMyTextFormObrigatorio(
                      context,
                      title: 'Email',
                      initialValue: widget.email,
                      hintText: 'exemplo@exc.com',
                      onSaved: (text) => _formInfosMorador =
                          _formInfosMorador.copyWith(email: text),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: ConstsWidget.buildCustomButton(
                        context,
                        'Gerar Login',
                        onPressed: () {
                          var formValid =
                              _formKeyMorador.currentState?.validate() ?? false;
                          if (formValid) {
                            _formKeyMorador.currentState?.save();
                            List nomeEmLista =
                                _formInfosMorador.nome_morador!.split(' ');
                            List listaNome = nomeEmLista;

                            setState(() {
                              loginGerado =
                                  '${listaNome.first.toString().toLowerCase()}${listaNome.last.toString().toLowerCase()}$dataLogin';
                              print(loginGerado);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                //Login Gerado
                if (loginGerado != '')
                  Column(
                    children: [
                      buildMyTextFormField(
                        context,
                        title: 'Usário de login',
                        initialValue: loginGerado,
                        readOnly: true,
                        onSaved: (text) => _formInfosMorador =
                            _formInfosMorador.copyWith(login: text),
                      ),
                      if (widget.idmorador == null)
                        buildMyTextFormField(
                          context,
                          title: 'Senha Login',
                          onSaved: (text) => _formInfosMorador =
                              _formInfosMorador.copyWith(senha: text),
                        ),
                      ListTile(
                        title: ConstsWidget.buildTextTitle(
                            context, 'Permitir acesso ao sistema'),
                        trailing: StatefulBuilder(builder: (context, setState) {
                          return SizedBox(
                              width: size.width * 0.125,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    activeColor: Consts.kColorApp,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                        int salvaAcesso =
                                            isChecked == true ? 1 : 0;
                                        _formInfosMorador = _formInfosMorador
                                            .copyWith(acesso: salvaAcesso);
                                      });
                                    },
                                  ),
                                ],
                              ));
                        }),
                      ),
                      ConstsWidget.buildCustomButton(
                        context,
                        'Salvar',
                        onPressed: () {
                          var formValid =
                              _formKeyMorador.currentState?.validate() ?? false;
                          if (formValid) {
                            _formKeyMorador.currentState?.save();
                            String restoApi;
                            widget.idmorador == null
                                ? restoApi =
                                    'incluirMorador&senha=${_formInfosMorador.senha}'
                                : restoApi =
                                    'editarMorador&id=${widget.idmorador}';
                            ConstsFuture.changeApi(
                              // print(
                              '${Consts.apiUnidade}moradores/?fn=$restoApi&idunidade=${InfosMorador.idunidade}&idcond=${InfosMorador.idcondominio}&iddivisao=${InfosMorador.iddivisao}&ativo=${_formInfosMorador.ativo}&numero=${InfosMorador.numero}&nomeMorador=${_formInfosMorador.nome_morador}&login=${_formInfosMorador.login}&datanasc=${_formInfosMorador.nascimento}&documento=${_formInfosMorador.documento}&dddtelefone=${_formInfosMorador.ddd}&telefone=${_formInfosMorador.telefone}&acessa_sistema=${_formInfosMorador.acesso}',
                            ).then((value) {
                              if (!value['erro']) {
                                ConstsFuture.navigatorPopAndReplacement(
                                    context,
                                    ListaMoradores(
                                      idunidade: widget.idunidade,
                                    ));
                                buildCustomSnackBar(context,
                                    titulo: 'Parabens',
                                    texto: value['mensagem']);
                              } else {
                                buildCustomSnackBar(context,
                                    titulo: 'Erro!', texto: value['mensagem']);
                              }
                            });
                          } else {
                            print(formValid.toString());
                          }
                        },
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAtivoInativo2(
    BuildContext context, {
    int seEditando = 0,
  }) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownValueAtivo = _formInfosMorador.ativo,
                icon: Padding(
                  padding: EdgeInsets.only(right: size.height * 0.03),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                elevation: 24,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                borderRadius: BorderRadius.circular(16),
                onChanged: (value) {
                  setState(() {
                    dropdownValueAtivo = value!;
                    _formInfosMorador =
                        _formInfosMorador.copyWith(ativo: value);
                    print(_formInfosMorador.ativo);
                  });
                },
                items: listAtivo.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: value == 0 ? Text('Inativo') : Text('Ativo'),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}
