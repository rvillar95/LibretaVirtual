class Evento {
  String idEvento;
  String nombreEvento;
  String descripcionEvento;
  String fechaEvento;
  String nombreCurso;
  Evento(
      {this.idEvento,
      this.nombreEvento,
      this.descripcionEvento,
      this.fechaEvento,
      this.nombreCurso});

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
        idEvento: json['idEvento'],
        nombreEvento: json['nombreEvento'],
        descripcionEvento: json['descripcionEvento'],
        fechaEvento: json['fechaEvento'],
        nombreCurso: json['nombreCurso']);
  }
}
