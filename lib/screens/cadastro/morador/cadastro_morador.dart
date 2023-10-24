// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:morador_app/screens/home/home_page.dart';
import 'package:morador_app/widgets/alert_dialog/alert_all.dart';
import 'package:morador_app/widgets/date_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:morador_app/widgets/snack_bar.dart';
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

bool isObscureLogin = true;
bool isObscureRetirada = true;

class _CadastroMoradorState extends State<CadastroMorador> {
  bool isLoading = false;
  bool isLoadingLogin = false;
  List listAtivo = [1, 0];
  bool isGerarSenha = false;
  Object? dropdownValueAtivo;
  int isSenhaLoginAll = 0;
  int isSenhaRetiradaAll = 0;

  final formKeyTrocaSenha = GlobalKey<FormState>();
  String loginGerado2 = '';
  TextEditingController senhaNovaCtrl = TextEditingController();
  TextEditingController senhaConfirmCtrl = TextEditingController();
  TextEditingController retiradaNovaCtrl = TextEditingController();
  TextEditingController retiradaConfirmCtrl = TextEditingController();

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
    loginGerado2 =
        widget.isDrawer && widget.idunidade != null ? InfosMorador.login : '';
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

    Widget buildCampoSenha({
      required TextEditingController senhaCtrl,
      required bool obscureText,
      required String title,
    }) {
      return StatefulBuilder(
        builder: (context, setState) => TextFormField(
          textInputAction: TextInputAction.done,
          controller: senhaCtrl,
          style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: Validatorless.multiple([
            // Validatorless.required(
            //     'Preencha com sua senha de acesso'),
            Validatorless.min(6, 'Mínimo de 6 caracteres')
          ]),
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.032, vertical: size.height * 0.023),
            filled: true,
            fillColor: Theme.of(context).primaryColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary)),
            hintText: 'Nova Senha $title',
            label: RichText(
                text: TextSpan(
                    text: 'Nova Senha $title',
                    style: TextStyle(
                      fontSize: SplashScreen.isSmall ? 14 : 16,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    children: [
                  TextSpan(
                      text: ' **',
                      style: TextStyle(
                          color: Consts.kColorRed,
                          fontSize: SplashScreen.isSmall ? 14 : 16))
                ])),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: obscureText
                  ? Icon(Icons.visibility_off_outlined,
                      color: Theme.of(context).textTheme.bodyLarge!.color)
                  : Icon(Icons.visibility_outlined,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ),
        ),
      );
    }

    alertTodosUnidades({
      required String title,
    }) {
      return showDialogAll(context,
          title:
              ConstsWidget.buildTextTitle(context, 'Alterar em todas unidades'),
          children: [
            ConstsWidget.buildTextSubTitle(
              context,
              'A Senha de $title será alterada em todos as suas unidades no Portaria App',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            ConstsWidget.buildCustomButton(
              context,
              'Entendi',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]);
    }

    return buildScaffoldAll(
      context,
      title: !widget.isDrawer
          ? '${widget.idmorador == null ? 'Incluir' : 'Editar'} Morador'
          : 'Meu Perfil',
      resizeToAvoidBottomInset: true,
      body: MyBoxShadow(
        child: Column(
          children: [
            ConstsWidget.buildCamposObrigatorios(
              context,
            ),

            Form(
              key: _formKeyMorador,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isDrawer && widget.login != InfosMorador.login)
                    buildDropAtivoInativo(
                      context,
                    ),
                  if (widget.isDrawer)
                    ConstsWidget.buildPadding001(context,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          child: ConstsWidget.buildExpandedTile(
                            context,
                            children: [
                              ConstsWidget.buildTextExplicaSenha(context,
                                  textAlign: TextAlign.left),
                              SizedBox(
                                height: size.height * 0.02,
                              )
                            ],
                            title: Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                ConstsWidget.buildTextTitle(
                                    context, 'Como Adicionar Outro Local'),
                                ConstsWidget.buildTextSubTitle(context, ' **',
                                    color: Colors.red),
                              ],
                            ),
                          ),
                        )),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: size.width * 0.35,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.01,
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
                        width: size.width * 0.55,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // SizedBox(
                      //   width: size.width * 0.040,
                      // ),
                      SizedBox(
                        width: size.width * 0.74,
                        child: buildMyTextFormField(
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

                  if (loginGerado2 == '' && !widget.isDrawer)
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildLoadingButton(
                        context,
                        title: 'Continuar',
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
                  if (loginGerado2 == '' && !widget.isDrawer)
                    SizedBox(
                      height: size.height * 0.008,
                    )
                ],
              ),
            ),
            //Login Gerado

            if (loginGerado2 != '')
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstsWidget.buildPadding001(
                          context,
                          vertical: 0.02,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ConstsWidget.buildTextSubTitle(context, 'Login:'),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              SizedBox(
                                width: size.width * 0.8,
                                child: ConstsWidget.buildTextTitle(
                                    context, _formInfosMorador.login.toString(),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //LOGIN
                  if (widget.isDrawer && InfosMorador.login == widget.login)
                    Form(
                      key: formKeyTrocaSenha,
                      child: Column(
                        children: [
                          ConstsWidget.buildSeparated(context),
                          buildCampoSenha(
                              senhaCtrl: senhaNovaCtrl,
                              obscureText: isObscureLogin,
                              title: 'Login'),
                          ConstsWidget.buildPadding001(
                            context,
                            child: ConstsWidget.buildCheckBox(context,
                                isChecked: isSenhaLoginAll == 1 ? true : false,
                                width: size.width * 0.6, onChanged: (value) {
                              setState(
                                () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  isSenhaLoginAll = value! ? 1 : 0;
                                },
                              );
                              if (value == true) {
                                alertTodosUnidades(title: 'Login');
                              }
                            }, title: 'Alterar em Todas as Unidade'),
                          ),
                          //RETIRADA
                          buildCampoSenha(
                              senhaCtrl: retiradaNovaCtrl,
                              obscureText: isObscureRetirada,
                              title: 'Retirada'),
                          // if (InfosMorador.listIdUnidade.length != 1)
                          ConstsWidget.buildPadding001(
                            context,
                            child: ConstsWidget.buildCheckBox(context,
                                isChecked:
                                    isSenhaRetiradaAll == 1 ? true : false,
                                width: size.width * 0.6, onChanged: (value) {
                              if (value == true) {
                                alertTodosUnidades(title: 'Retirada');
                              }
                              setState(
                                () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  isSenhaRetiradaAll = value! ? 1 : 0;
                                },
                              );
                            }, title: 'Alterar em Todas as Unidade'),
                          ),
                          // ConstsWidget.buildSeparated(
                          //   context,
                          // ),
                          // buildMyTextFormField(
                          //   context,
                          //   title: 'Confirmar Senha',
                          //   validator: Validatorless.multiple([
                          //     Validatorless.required('Confirme a senha'),
                          //     Validatorless.min(
                          //         6, 'Senha precisa ter 6 caracteres'),
                          //     Validatorless.compare(
                          //         retiradaNovaCtrl, 'Senhas não são iguais'),
                          //   ]),
                          //   controller: retiradaConfirmCtrl,
                          // ),
                        ],
                      ),
                    ),
                  if (InfosMorador.responsavel || !widget.isDrawer)
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildCheckBox(
                        context,
                        isChecked: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            int salvaAcesso = isChecked == true ? 1 : 0;
                            _formInfosMorador =
                                _formInfosMorador.copyWith(acesso: salvaAcesso);
                          });
                        },
                        title: 'Permitir acesso ao sistema',
                      ),
                    ),
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
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildLoadingButton(
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

                    bool formValidSenha = false;
                    FocusManager.instance.primaryFocus!.unfocus();

                    if ((senhaNovaCtrl.text.isNotEmpty &&
                            senhaNovaCtrl.text.length >= 6) ||
                        (retiradaNovaCtrl.text.isNotEmpty &&
                            retiradaNovaCtrl.text.length >= 6)) {
                      setState(() {
                        formValidSenha = true;
                      });
                    } else if ((senhaNovaCtrl.text.isNotEmpty &&
                            senhaNovaCtrl.text.length < 6) ||
                        (retiradaNovaCtrl.text.isNotEmpty &&
                            retiradaNovaCtrl.text.length < 6)) {
                    } else if (senhaNovaCtrl.text.isEmpty ||
                        retiradaNovaCtrl.text.isEmpty) {
                      setState(() {
                        formValidSenha = false;
                      });
                    } else {
                      setState(() {
                        formValidSenha = false;
                      });
                    }

                    if (formValid &&
                        senhaNovaCtrl.text.isEmpty &&
                        retiradaNovaCtrl.text.isEmpty) {
                      _formKeyMorador.currentState?.save();

                      salvarDadosMorador();
                    } else {
                      if (formValidSenha == true) {
                        _formKeyMorador.currentState?.save();
                        salvarSenha();
                        salvarDadosMorador();
                      }
                    }
                  },
                ),
              )
          ],
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
    String datanasc = MyDatePicker.dataSelected != '' &&
            MyDatePicker.dataSelected != '0000-00-00'
        ? '&datanasc=${DateFormat('yyyy-MM-dd').format(DateTime.parse(MyDatePicker.dataSelected))}'
        : '';
    String dddtelefone = _formInfosMorador.ddd != ''
        ? '&dddtelefone=${_formInfosMorador.ddd}'
        : '';
    String telefone = _formInfosMorador.telefone != ''
        ? '&telefone=${_formInfosMorador.telefone}'
        : '';
    if (widget.isDrawer) {
      InfosMorador.nome_completo = _formInfosMorador.nome_morador!;
      InfosMorador.data_nascimento = _formInfosMorador.nascimento!;
      InfosMorador.documento = _formInfosMorador.documento!;
      InfosMorador.dddtelefone = _formInfosMorador.ddd!;
      InfosMorador.telefone = _formInfosMorador.telefone!;
      InfosMorador.email = _formInfosMorador.email!;
    }
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
                )).then((value) {
              buildCustomSnackBar(context,
                  titulo: 'Sucesso', texto: value['mensagem']);
              setState(() {
                apiMoradores();
              });
            });
          } else {
            ConstsFuture.navigatorPageRoute(context, HomePage());
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

  salvarSenha() {
    ConstsFuture.changeApi(
            'moradores/?fn=mudarSenhas&mudasenhalogin=$isSenhaLoginAll&mudasenharetirada=$isSenhaRetiradaAll&login=$loginGerado2&idmorador=${InfosMorador.idmorador}${senhaNovaCtrl.text != '' ? '&senha=${senhaNovaCtrl.text}' : ''}${retiradaNovaCtrl.text.isNotEmpty ? '&senha_retirada=${retiradaNovaCtrl.text}' : ''}')
        .then((value) {
      if (!value['erro']) {
        senhaNovaCtrl.clear();
        senhaConfirmCtrl.clear();
        retiradaConfirmCtrl.clear();
        retiradaNovaCtrl.clear();
        isSenhaLoginAll = 0;
        isSenhaRetiradaAll = 0;
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
