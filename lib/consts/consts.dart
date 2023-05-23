import 'package:app_portaria/repositories/shared_preferences.dart';
import 'package:app_portaria/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import '../itens_bottom.dart';

class InfosMorador {
  static int id = 0;
  static bool ativo = false;
  static int idcondominio = 0;
  static String nome_condominio = '';
  static String nome_morador = '';
  static String unidade = '';
  static String divisao = '';
  static String login = '';
  static String documento = '';
  static String telefone = '';
  static String data_nascimento = '';
  static bool acessa_sistema = false;
  static String datahora_cadastro = '';
  static String datahora_ultima_atualizacao = '';
}

class Consts {
  static double fontTitulo = 16;
  static double fontSubTitulo = 14;
  static double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  static const kButtonColor = Color.fromARGB(255, 0, 134, 252);

  static const String iconApi = 'https://escritorioapp.com/img/ico-';
  static const String iconApiPort = 'https://a.portariaapp.com/img/ico-';
}
