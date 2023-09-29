// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:app_portaria/screens/home/home_page.dart';
import 'package:app_portaria/widgets/alert_dialog/alert_trocar_senha.dart';
import 'package:app_portaria/widgets/date_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_future.dart';
import '../../../consts/consts_widget.dart';
import '../../../forms/form_morador.dart';
import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/my_text_form_field.dart';
import '../../../widgets/scaffold_all.dart';
import '../../splash_screen/splash_screen.dart';
import '../listar_total.dart';
import 'package:diacritic/diacritic.dart';

import 'listar_morador.dart';

// ignore: must_be_immutable
class CadastroMorador extends StatefulWidget {
  static TextEditingController senhaNovaCtrl = TextEditingController();
  static TextEditingController senhaConfirmCtrl = TextEditingController();
  static TextEditingController retiradaNovaCtrl = TextEditingController();
  static TextEditingController retiradaConfirmCtrl = TextEditingController();
  static int isSenhaLoginAll = 0;
  static int isSenhaRetiradaAll = 0;
  int? idmorador;
  bool ativo;
  String? nome_completo;
  String? login;
  String? nascimento;
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
  bool isLoading = false;
  bool isLoadingLogin = false;
  List listAtivo = [1, 0];
  bool isGerarSenha = false;
  Object? dropdownValueAtivo;

  final formKeyRetirada = GlobalKey<FormState>();
  String loginGerado2 = '';

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
    // _formInfosMorador =
    //     _formInfosMorador.copyWith(nascimento: widget.nascimento);
    _formInfosMorador = _formInfosMorador.copyWith(documento: widget.documento);
    _formInfosMorador = _formInfosMorador.copyWith(acesso: widget.acesso);
    _formInfosMorador = _formInfosMorador.copyWith(idunidade: widget.idunidade);
    _formInfosMorador = _formInfosMorador.copyWith(iddivisao: widget.iddivisao);
    loginGerado2 = !InfosMorador.senha_alterada && widget.idunidade != null
        ? InfosMorador.login
        : '';
    MyDatePicker.dataSelected = widget.nascimento ?? '';
  }

  final _formKeyMorador = GlobalKey<FormState>();
  FormInfosMorador _formInfosMorador = FormInfosMorador();

  String dataLogin = '';
  bool nomeDocAlterado = false;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    @override
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
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildTextSubTitle(
                    context, '(*) Campo Obrigatório',
                    color: Consts.kColorRed),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isDrawer)
                    buildDropAtivoInativo(
                      context,
                    ),
                  // if (widget.idmorador == null)
                  buildMyTextFormObrigatorio(
                    context,
                    // readOnly: !InfosMorador.responsavel,
                    title: 'Nome Completo',
                    initialValue: widget.nome_completo,
                    textCapitalization: TextCapitalization.words,
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
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: size.width * 0.37,
                          child: Column(
                            children: [
                              SizedBox(
                                height: SplashScreen.isSmall
                                    ? size.height * 0.01
                                    : size.height * 0.007,
                              ),
                              MyDatePicker(
                                dataSelected:
                                    widget.nascimento != '0000-00-00' &&
                                            widget.nascimento != ''
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(widget.nascimento!))
                                        : null,
                                hintText:
                                    MyDatePicker.dataSelected != '0000-00-00' &&
                                            MyDatePicker.dataSelected != ''
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(DateTime.parse(
                                                MyDatePicker.dataSelected))
                                            .toString()
                                        : MyDatePicker.dataSelected,
                                type: DateTimePickerType.date,
                                aniversario: true,
                              ),
                            ],
                          )),
                      SizedBox(
                        width: size.width * 0.5,
                        child: buildMyTextFormObrigatorio(
                          context,
                          // readOnly: !InfosMorador.responsavel,
                          title: 'Documento',
                          initialValue: widget.documento,
                          hintText: 'CPF', maxLength: 20,

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
                        child: buildMyTextFormField(context,
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
                        width: size.width * 0.65,
                        child: buildMyTextFormField(
                          context,
                          initialValue: widget.telefone,
                          title: 'Telefone',
                          keyboardType: TextInputType.number,
                          hintText: '9 11223344',
                          onSaved: (text) {
                            _formInfosMorador =
                                _formInfosMorador.copyWith(telefone: text);
                          },
                        ),
                      ),
                    ],
                  ),

                  ConstsWidget.buildPadding001(
                    context,
                    child: buildMyTextFormObrigatorio(
                      context,
                      initialValue: widget.email,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (text) {
                        _formInfosMorador =
                            _formInfosMorador.copyWith(email: text);
                      },
                      title: 'Email',
                      hintText: 'exemplo@exe.com',
                      validator: Validatorless.multiple([
                        Validatorless.email('Não é um email válido'),
                        Validatorless.required('Obrigatório'),
                      ]),
                    ),
                  ),

                  if (loginGerado2 == '')
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildLoadingButton(
                        context,
                        title: 'Gerar Login',
                        isLoading: isLoadingLogin,
                        color: Consts.kColorVerde,
                        onPressed: () {
                          var formValid =
                              _formKeyMorador.currentState?.validate() ?? false;
                          FocusManager.instance.primaryFocus!.unfocus();
                          if (formValid) {
                            setState(() {
                              isLoadingLogin = true;
                            });
                            _formKeyMorador.currentState?.save();
                            gerarLogin(context,
                                    nomeUsado: _formInfosMorador.nome_morador!,
                                    nomeDocAlterado: nomeDocAlterado,
                                    documento: _formInfosMorador.documento!)
                                .then((value) {
                              setState(() {
                                isLoadingLogin = false;
                              });
                              if (value != '') {
                                setState(() {
                                  loginGerado2 = value;
                                  _formInfosMorador = _formInfosMorador
                                      .copyWith(login: loginGerado2);
                                });
                              } else {
                                setState(() {
                                  isLoadingLogin = false;
                                });
                                buildCustomSnackBar(context,
                                    titulo: 'Algo saiu mal',
                                    hasError: true,
                                    texto: 'O login não foi gerado');
                              }
                            });
                          }
                        },
                      ),
                    ),
                ],
              ),
              //Login Gerado

              if (loginGerado2 != '')
                Column(
                  children: [
                    MyBoxShadow(
                      child: Row(
                        children: [
                          ConstsWidget.buildPadding001(
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConstsWidget.buildTextSubTitle(
                                    context, 'Login'),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: ConstsWidget.buildTextTitle(context,
                                      _formInfosMorador.login.toString(),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (widget.isDrawer && InfosMorador.login == widget.login)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstsWidget.buildPadding001(
                            context,
                            vertical: 0.02,
                            child: ConstsWidget.buildCustomButton(
                              context,
                              'Senha Login',
                              rowSpacing: 0.025,
                              onPressed: () {
                                trocarSenhaAlert(
                                  context,
                                  title: 'Login',
                                );
                              },
                            ),
                          ),
                          ConstsWidget.buildPadding001(
                            context,
                            child: ConstsWidget.buildOutlinedButton(
                              context,
                              title: 'Senha Retirada',
                              rowSpacing: 0.025,
                              onPressed: () {
                                trocarSenhaAlert(
                                  context,
                                  title: 'Retirada',
                                );
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
                    if (widget.idmorador != null && !widget.isDrawer)
                      StatefulBuilder(builder: (context, setState) {
                        return ConstsWidget.buildCheckBox(context,
                            isChecked: isGerarSenha, onChanged: (bool? value) {
                          setState(() {
                            isGerarSenha = value!;
                          });
                        }, title: 'Gerar Senha e Enviar Acesso');
                      }),
                  ],
                ),
              if (loginGerado2 != '')
                ConstsWidget.buildLoadingButton(
                  context,
                  title: 'Salvar',
                  isLoading: isLoading,
                  color: Consts.kColorRed,
                  // icon: Icons.save_alt,
                  onPressed: () {
                    // setState(() {
                    //   isLoading = true;
                    // });
                    var formValid =
                        _formKeyMorador.currentState?.validate() ?? false;
                    FocusManager.instance.primaryFocus!.unfocus();
                    print('login: ${CadastroMorador.isSenhaLoginAll}');
                    print('retirada: ${CadastroMorador.isSenhaRetiradaAll}');
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
                      salvarDadosMorador();
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      //print(formValid.toString());
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  salvarDadosMorador() {
    String fnApi;
    widget.idmorador == null
        ? fnApi = 'incluirMorador&gerarsenha=1'
        : fnApi =
            'editarMorador&id=${widget.idmorador}&gerarsenha=${isGerarSenha ? 1 : 0}';
    int isResponsavel;
    InfosMorador.responsavel && widget.isDrawer
        ? isResponsavel = 1
        : isResponsavel = 0;
    String datanasc = _formInfosMorador.nascimento != ''
        ? '&datanasc=${_formInfosMorador.nascimento}'
        : '';
    String dddtelefone = _formInfosMorador.ddd != ''
        ? '&dddtelefone=${_formInfosMorador.ddd}'
        : '';
    String telefone = _formInfosMorador.telefone != ''
        ? '&telefone=${_formInfosMorador.telefone}'
        : '';

    ConstsFuture.changeApi(
            'moradores/?fn=$fnApi&idunidade=${InfosMorador.idunidade}&idmorador=${InfosMorador.idmorador}&idcond=${InfosMorador.idcondominio}&iddivisao=${InfosMorador.iddivisao}&ativo=${_formInfosMorador.ativo}&numero=${InfosMorador.numero}&nomeMorador=${_formInfosMorador.nome_morador}&login=${_formInfosMorador.login}$datanasc&documento=${_formInfosMorador.documento}$dddtelefone$telefone&email=${_formInfosMorador.email}&acessa_sistema=${_formInfosMorador.acesso}&responsavel=$isResponsavel')
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
          } else {
            ConstsFuture.navigatorPageRoute(context, HomePage());
          }
        } else {
          if (CadastroMorador.senhaNovaCtrl.text != '' ||
              CadastroMorador.retiradaNovaCtrl.text != '') {
            ConstsFuture.changeApi(
                    'moradores/?fn=mudarSenhas&mudasenhalogin=${CadastroMorador.isSenhaLoginAll}&mudasenharetirada=${CadastroMorador.isSenhaRetiradaAll}&login=$loginGerado2&idmorador=${InfosMorador.idmorador}${CadastroMorador.senhaNovaCtrl.text != '' ? '&senha=${CadastroMorador.senhaNovaCtrl.text}' : ''}${CadastroMorador.retiradaNovaCtrl.text.isNotEmpty ? '&senha_retirada=${CadastroMorador.retiradaNovaCtrl.text}' : ''}')
                .then((value) {
              CadastroMorador.senhaNovaCtrl.clear();
              CadastroMorador.senhaConfirmCtrl.clear();
              CadastroMorador.retiradaConfirmCtrl.clear();
              CadastroMorador.retiradaNovaCtrl.clear();
              CadastroMorador.isSenhaLoginAll = 0;
              CadastroMorador.isSenhaRetiradaAll = 0;
            });
          }
        }
        Navigator.pop(context);
        widget.isDrawer
            ? ConstsFuture.navigatorPageRoute(context, HomePage())
            : ConstsFuture.navigatorPopAndPush(
                context,
                ListaTotalUnidade(
                  tipoAbrir: 0,
                )).then((value) {
                buildCustomSnackBar(context,
                    titulo: 'Sucesso', texto: value['mensagem']);
                setState(() {
                  apiMoradores();
                });
              });
      } else {
        buildCustomSnackBar(
          context,
          titulo: 'Erro!',
          texto: value['mensagem'],
          hasError: true,
        );
      }
    });
  }

  Widget buildDropAtivoInativo(
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
                isExpanded: true,
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
                    color: Theme.of(context).textTheme.bodyLarge!.color,
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
                    child: value == 0
                        ? Center(child: Text('Inativo'))
                        : Center(child: Text('Ativo')),
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

Future gerarLogin(BuildContext context,
    {required String nomeUsado,
    required bool nomeDocAlterado,
    required String documento}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  final List<String> listaNome = [];
  List nomeEmLista = nomeUsado.split(' ');

  // if (nomeDocAlterado) {
  //   buildCustomSnackBar(context,
  //       titulo: 'Dados alterados', texto: 'Alteramos o login');
  // }
  nomeEmLista.map((e) {
    if (e != '') {
      listaNome.add(removeDiacritics(e).toLowerCase());
    }
  }).toSet();

  String loginGerado =
      '${listaNome.first}${listaNome.last}${documento.substring(0, 4)}';

  return loginGerado;
}
