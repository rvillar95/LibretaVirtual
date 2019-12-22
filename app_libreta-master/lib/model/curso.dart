class Curso {
  String idCurso;
  String nombreCurso;

  Curso(
      {this.idCurso,
      this.nombreCurso});

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      idCurso: json['idCurso'],
      nombreCurso: json['nombreCurso']
    );
  }
}
