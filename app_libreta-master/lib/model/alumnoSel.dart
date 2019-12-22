class AlumnoSel{
  String idAlumno;
  String nombreAlumno;

  AlumnoSel({this.idAlumno, this.nombreAlumno});

  factory AlumnoSel.fromJson(Map<String, dynamic> json){
    return AlumnoSel(
        idAlumno: json['idAlumno'],
        nombreAlumno:json['nombreAlumno']
    );
  }

}