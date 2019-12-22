class AlumnoSelect {
  String idAlumno;
  String nombreAlumno;

  AlumnoSelect(
      {this.idAlumno,
      this.nombreAlumno});

  factory AlumnoSelect.fromJson(Map<String, dynamic> json) {
    return AlumnoSelect(
      idAlumno: json['idAlumno'],
      nombreAlumno: json['nombreAlumno']
    );
  }
}
