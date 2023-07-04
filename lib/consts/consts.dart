// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class InfosMorador {
  static int qntApto = 0;
  static String user = '';
  static String senhaCripto = '';
  static int idmorador = 0;
  static int idresponsavel = 0;
  static int idcondominio = 0;
  static int iddivisao = 0;
  static int idunidade = 0;
  static String nome_condominio = '';
  static String nome_completo = '';
  static String numero = '';
  static String divisao = '';
  static String login = '';
  static String documento = '';
  static String telefone = '';
  static String dddtelefone = '';
  static String email = '';
  static String data_nascimento = '';
  static String datahora_cadastro = '';
  static String datahora_ultima_atualizacao = '';
  static String telefone_portaria = '';
  static bool responsavel = false;
  static bool ativo = false;
  static bool acessa_sistema = false;
}

class Consts {
  static double fontTitulo = 16;
  static double fontSubTitulo = 14;
  static double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  static const kButtonColor = Color.fromARGB(255, 0, 134, 252);
  static const kColorRed = Color.fromARGB(255, 251, 80, 93);
  static const kColorAzul = Color.fromARGB(255, 75, 132, 255);
  static const kColorVerde = Color.fromARGB(255, 44, 201, 104);
  static const kColorAmarelo = Color.fromARGB(255, 255, 193, 7);

  static const String iconApi = 'https://escritorioapp.com/img/ico-';
  static const String iconApiPort = 'https://a.portariaapp.com/img/ico-';
  static const String apiUnidade = 'https://a.portariaapp.com/unidade/api/';
}
