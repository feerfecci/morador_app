class FormInfosCarro {
  final int? idveiculo;
  final String? tipo;
  final String? marca;
  final String? modelo;
  final String? cor;
  final String? placa;
  final String? vaga;
  final String? datahora;

  FormInfosCarro({
    this.idveiculo,
    this.tipo,
    this.marca,
    this.modelo,
    this.cor,
    this.placa,
    this.vaga,
    this.datahora,
  });
  FormInfosCarro copyWith({
    int? idveiculo,
    String? tipo,
    String? marca,
    String? modelo,
    String? cor,
    String? placa,
    String? vaga,
    String? datahora,
  }) {
    return FormInfosCarro(
      idveiculo: idveiculo ?? this.idveiculo,
      tipo: tipo ?? this.tipo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      cor: cor ?? this.cor,
      placa: placa ?? this.placa,
      vaga: vaga ?? this.vaga,
      datahora: datahora ?? this.datahora,
    );
  }
}
