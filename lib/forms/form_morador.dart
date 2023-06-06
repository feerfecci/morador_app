// ignore_for_file: non_constant_identifier_names

class FormInfosMorador {
  final int ativo;
  final String? nome_morador;
  final String? login;
  final String? senha;
  final String? nascimento;
  final String? documento;
  final String? telefone;
  final String? ddd;
  final String? email;
  final int? acesso;
  int? iddivisao;
  int? idunidade;
  FormInfosMorador({
    this.ativo = 0,
    this.nome_morador = '',
    this.login = '',
    this.senha = '',
    this.documento = '',
    this.nascimento = '',
    this.telefone = '',
    this.ddd = '',
    this.email = '',
    this.acesso = 0,
    this.iddivisao = 0,
    this.idunidade = 0,
  });
  FormInfosMorador copyWith(
      {int? ativo,
      String? nome_morador,
      String? login,
      String? senha,
      String? documento,
      String? nascimento,
      String? telefone,
      String? ddd,
      String? email,
      int? acesso,
      int? iddivisao,
      int? idunidade}) {
    return FormInfosMorador(
        ativo: ativo ?? this.ativo,
        nome_morador: nome_morador ?? this.nome_morador,
        login: login ?? this.login,
        senha: senha ?? this.senha,
        documento: documento ?? this.documento,
        nascimento: nascimento ?? this.nascimento,
        telefone: telefone ?? this.telefone,
        ddd: ddd ?? this.ddd,
        email: email ?? this.email,
        acesso: acesso ?? this.acesso,
        iddivisao: iddivisao ?? this.iddivisao,
        idunidade: idunidade ?? this.idunidade);
  }
}
