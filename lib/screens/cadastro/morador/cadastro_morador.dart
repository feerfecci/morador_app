// ignore_for_file: non_constant_identifier_names

import 'package:app_portaria/screens/home/home_page.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_trocar_senha.dart';
import 'package:flutter/material.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_future.dart';
import '../../../consts/consts_widget.dart';
import '../../../forms/form_morador.dart';
import '../../../widgets/header.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/my_text_form_field.dart';
import '../../../widgets/scaffold_all.dart';
import '../listar_total.dart';

// ignore: must_be_immutable
class CadastroMorador extends StatefulWidget {
  int? idmorador;
  bool ativo;
  String? nome_completo;
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
  bool isDrawer;
  CadastroMorador(
      {this.idmorador,
      this.nome_completo,
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
      this.isDrawer = false,
      super.key});

  @override
  State<CadastroMorador> createState() => _CadastroMoradorState();
}

class _CadastroMoradorState extends State<CadastroMorador> {
  List listAtivo = [1, 0];
  Object? dropdownValueAtivo;
  final formKeySenha = GlobalKey<FormState>();
  final senhaAtualCtrl = TextEditingController();
  final senhaNovaCtrl = TextEditingController();
  final senhaConfirmCtrl = TextEditingController();

  final formKeyRetirada = GlobalKey<FormState>();
  final retiradaAtualCtrl = TextEditingController();
  final retiradaNovaCtrl = TextEditingController();
  final retiradaConfirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formInfosMorador = _formInfosMorador.copyWith(ativo: widget.ativo ? 1 : 0);
    _formInfosMorador =
        _formInfosMorador.copyWith(nome_morador: widget.nome_completo);
    _formInfosMorador = _formInfosMorador.copyWith(login: widget.login);
    _formInfosMorador = _formInfosMorador.copyWith(telefone: widget.telefone);
    _formInfosMorador = _formInfosMorador.copyWith(ddd: widget.ddd);
    _formInfosMorador = _formInfosMorador.copyWith(email: widget.email);
    _formInfosMorador =
        _formInfosMorador.copyWith(nascimento: widget.nascimento);
    _formInfosMorador = _formInfosMorador.copyWith(documento: widget.documento);
    _formInfosMorador = _formInfosMorador.copyWith(acesso: widget.acesso);
    _formInfosMorador = _formInfosMorador.copyWith(idunidade: widget.idunidade);
    _formInfosMorador = _formInfosMorador.copyWith(iddivisao: widget.iddivisao);
  }

  final _formKeyMorador = GlobalKey<FormState>();
  FormInfosMorador _formInfosMorador = FormInfosMorador();
  String loginGerado = '';
  String dataLogin = '';
  bool nomeDocAlterado = false;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    @override
    var dataParsed = widget.nascimento != ''
        ? DateFormat('dd/MM/yyy').format(DateTime.parse(widget.nascimento))
        : '';
    var acessoApi = _formInfosMorador.acesso == 0 ? false : true;
    isChecked = acessoApi;
    var size = MediaQuery.of(context).size;

    return buildScaffoldAll(
      context,
      title: !widget.isDrawer
          ? '${widget.idmorador == null ? 'Incluir' : 'Editar'} Morador'
          : 'Meu Perfil',
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKeyMorador,
        child: MyBoxShadow(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (InfosMorador.responsavel)
                    buildAtivoInativo2(
                      context,
                    ),
                  // if (widget.idmorador == null)
                  buildMyTextFormObrigatorio(
                    context,
                    // readOnly: !InfosMorador.responsavel,
                    title: 'Nome Completo',
                    initialValue: widget.nome_completo,
                    onSaved: (text) {
                      _formInfosMorador =
                          _formInfosMorador.copyWith(nome_morador: text);
                      if (widget.idmorador != null) {
                        if (text != widget.nome_completo) {
                          setState(() {
                            nomeDocAlterado = true;
                          });
                        }
                      }
                    },
                  ),
                  // if (widget.idmorador == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.37,
                        child: buildMyTextFormObrigatorio(context,
                            initialValue: dataParsed,
                            // readOnly: !InfosMorador.responsavel,
                            title: 'Data de Nascimento',
                            keyboardType: TextInputType.number,
                            mask: '##/##/####',
                            hintText: '##/##/####', onSaved: (text) {
                          if (text!.length >= 6) {
                            var ano = text.substring(6);
                            var mes = text.substring(3, 5);
                            var dia = text.substring(0, 2);
                            _formInfosMorador = _formInfosMorador.copyWith(
                                nascimento: '$ano-$mes-$dia');
                          } else {
                            buildCustomSnackBar(context,
                                titulo: 'Cuidado', texto: 'Complete a data');
                          }
                        }),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: buildMyTextFormObrigatorio(
                          context,
                          // readOnly: !InfosMorador.responsavel,
                          title: 'Documento',
                          initialValue: widget.documento,
                          keyboardType: TextInputType.number,
                          hintText: 'RG, CPF',
                          onSaved: (text) {
                            if (text!.length >= 4) {
                              _formInfosMorador =
                                  _formInfosMorador.copyWith(documento: text);
                              if (widget.idmorador != null) {
                                if (text != widget.documento) {
                                  setState(() {
                                    nomeDocAlterado = true;
                                  });
                                }
                              }
                            } else {
                              buildCustomSnackBar(context,
                                  titulo: 'Cuidado',
                                  texto: 'Complete o documento');
                            }
                            if (widget.idmorador != null) {
                              if (text != widget.documento) {
                                setState(() {
                                  nomeDocAlterado = true;
                                });
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  //Contatos
                  ConstsWidget.buildPadding001(
                    context,
                    child: ConstsWidget.buildTextTitle(context, 'Contatos'),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.16,
                        child: buildMyTextFormObrigatorio(context,
                            initialValue: widget.ddd, onSaved: (text) {
                          _formInfosMorador =
                              _formInfosMorador.copyWith(ddd: text);
                        },
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
                          onSaved: (text) {
                            _formInfosMorador =
                                _formInfosMorador.copyWith(telefone: text);
                          },
                        ),
                      ),
                    ],
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    title: 'Email',
                    initialValue: widget.email,
                    hintText: 'exemplo@exc.com',
                    onSaved: (text) {
                      _formInfosMorador =
                          _formInfosMorador.copyWith(email: text);
                    },
                  ),

                  if (loginGerado == '')
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildCustomButton(
                        context,
                        'Continuar',
                        onPressed: () {
                          var formValid =
                              _formKeyMorador.currentState?.validate() ?? false;
                          if (formValid) {
                            _formKeyMorador.currentState?.save();
                            final List<String> listaNome = [];
                            List nomeEmLista =
                                _formInfosMorador.nome_morador!.split(' ');

                            if (nomeDocAlterado) {
                              buildCustomSnackBar(context,
                                  titulo: 'Dados alterados',
                                  texto: 'Alteramos o login');
                            }

                            for (var i = 0; i <= nomeEmLista.length - 1; i++) {
                              if (nomeEmLista[i] != '') {
                                listaNome.add(nomeEmLista[i]);
                              }
                            }
                            setState(() {
                              loginGerado =
                                  '${listaNome.first.toString().toLowerCase()}${listaNome.last.toString().toLowerCase()}${_formInfosMorador.documento!.substring(0, 4)}${widget.isDrawer ? 'r' : ''}';
                              _formInfosMorador = _formInfosMorador.copyWith(
                                  login: loginGerado);
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
                    MyBoxShadow(
                      child: Row(
                        children: [
                          ConstsWidget.buildPadding001(
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstsWidget.buildTextSubTitle(
                                    context, 'Login:'),
                                ConstsWidget.buildTextTitle(context,
                                    _formInfosMorador.login.toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    loginGerado != '' && widget.idunidade == null
                        ? Column(
                            children: [
                              buildMyTextFormField(context,
                                  title: 'Senha Login',
                                  // readOnly:InfosMorador.!responsavel,
                                  onSaved: (text) {
                                _formInfosMorador =
                                    _formInfosMorador.copyWith(senha: text);
                              }),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              ConstsWidget.buildTextTitle(context,
                                  'Essa senha será usada para retiradas na Portaria',
                                  color: Colors.red),
                              buildMyTextFormField(context,
                                  title: 'Senha Retirada',
                                  // readOnly:InfosMorador.!responsavel,
                                  onSaved: (text) {
                                _formInfosMorador = _formInfosMorador.copyWith(
                                    senhaRetirada: text);
                              }),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ConstsWidget.buildPadding001(
                                context,
                                child: ConstsWidget.buildOutlinedButton(
                                  context,
                                  title: 'Senha Login',
                                  onPressed: () {
                                    trocarSenhaAlert(context,
                                        formkeySenha: formKeySenha,
                                        atualSenhaCtrl: senhaAtualCtrl,
                                        title: ' Login',
                                        novaSenhaCtrl: senhaNovaCtrl,
                                        confirmSenhaCtrl: senhaConfirmCtrl);
                                  },
                                ),
                              ),
                              ConstsWidget.buildPadding001(
                                context,
                                child: ConstsWidget.buildCustomButton(
                                  context,
                                  'Senha Retirada',
                                  onPressed: () {
                                    trocarSenhaAlert(context,
                                        formkeySenha: formKeyRetirada,
                                        atualSenhaCtrl: retiradaAtualCtrl,
                                        novaSenhaCtrl: retiradaNovaCtrl,
                                        title: ' Retirada',
                                        confirmSenhaCtrl: retiradaConfirmCtrl);
                                  },
                                ),
                              ),
                            ],
                          ),
                    // ListTile(
                    //   title: ConstsWidget.buildTextTitle(
                    //       context, 'Permitir acesso ao sistema'),
                    //   trailing: StatefulBuilder(builder: (context, setState) {
                    //     return SizedBox(
                    //         width: size.width * 0.125,
                    //         child: Row(
                    //           mainAxisAlignment:
                    //               MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Checkbox(
                    //               value: isChecked,
                    //               activeColor: Consts.kColorApp,
                    //               onChanged: (bool? value) {
                    //                 setState(() {
                    //                   isChecked = value!;
                    //                   int salvaAcesso =
                    //                       isChecked == true ? 1 : 0;
                    //                   _formInfosMorador = _formInfosMorador
                    //                       .copyWith(acesso: salvaAcesso);
                    //                 });
                    //               },
                    //             ),
                    //           ],
                    //         ));
                    //   }),
                    // ),
                    if (InfosMorador.responsavel || !widget.isDrawer)
                      ConstsWidget.buildCheckBox(context, isChecked: isChecked,
                          onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          int salvaAcesso = isChecked == true ? 1 : 0;
                          _formInfosMorador =
                              _formInfosMorador.copyWith(acesso: salvaAcesso);
                        });
                      }, title: 'Permitir acesso ao sistema'),
                  ],
                ),
              if (loginGerado != '')
                ConstsWidget.buildCustomButton(
                  context,
                  'Salvar',
                  color: Consts.kColorRed,
                  icon: Icons.save_alt,
                  onPressed: () {
                    var formValid =
                        _formKeyMorador.currentState?.validate() ?? false;
                    if (formValid) {
                      _formKeyMorador.currentState?.save();
                      if (widget.isDrawer) {
                        InfosMorador.nome_completo =
                            _formInfosMorador.nome_morador!;
                        InfosMorador.data_nascimento =
                            _formInfosMorador.nascimento!;
                        InfosMorador.documento = _formInfosMorador.documento!;
                        InfosMorador.dddtelefone = _formInfosMorador.ddd!;
                        InfosMorador.telefone = _formInfosMorador.telefone!;
                        InfosMorador.email = _formInfosMorador.email!;
                      }
                      String restoApi;
                      widget.idmorador == null
                          ? restoApi =
                              'incluirMorador&senha=${_formInfosMorador.senha}&senha_retirada=${_formInfosMorador.senhaRetirada}'
                          : restoApi =
                              'editarMorador&id=${widget.idmorador}&senha=${senhaNovaCtrl.text}&senha_retirada=${retiradaNovaCtrl.text}';
                      int isResponsavel;
                      InfosMorador.responsavel && widget.isDrawer
                          ? isResponsavel = 1
                          : isResponsavel = 0;
                      ConstsFuture.changeApi(
                              'moradores/?fn=$restoApi&idunidade=${InfosMorador.idunidade}&idcond=${InfosMorador.idcondominio}&iddivisao=${InfosMorador.iddivisao}&ativo=${_formInfosMorador.ativo}&numero=${InfosMorador.numero}&nomeMorador=${_formInfosMorador.nome_morador}&login=${_formInfosMorador.login}&datanasc=${_formInfosMorador.nascimento}&documento=${_formInfosMorador.documento}&dddtelefone=${_formInfosMorador.ddd}&telefone=${_formInfosMorador.telefone}&email=${_formInfosMorador.email}&acessa_sistema=${_formInfosMorador.acesso}&responsavel=$isResponsavel')
                          .then((value) {
                        if (!value['erro']) {
                          if (!widget.isDrawer) {
                            Navigator.pop(context);
                            if (InfosMorador.responsavel) {
                              ConstsFuture.navigatorPageRoute(
                                  context,
                                  ListaTotalUnidade(
                                    idunidade: widget.idunidade,
                                    tipoAbrir: 1,
                                  ));
                              setState(() {});
                            } else {
                              ConstsFuture.navigatorPageRoute(
                                  context, HomePage());
                            }
                          }
                          Navigator.pop(context);

                          buildCustomSnackBar(context,
                              titulo: 'Parabens', texto: value['mensagem']);
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
    return ConstsWidget.buildPadding001(
      context,
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
