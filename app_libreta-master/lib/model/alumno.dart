class Alumno {
  String idAlumno;
  String rutAlumno;
  String nombresAlumno;
  String apellidosAlumno;
  String fechaNacimientoAlumno;
  String numeroAlumno;
  String correoAlumno;
  String fotoAlumno;
  String claveAlumno;
  String apoderado_idApoderado;
  String institucion_idInstitucion;
  String nacionalidadAlumno;
  String responsableAlumno;
  String estadoAlumno;
  String nombreInstitucion;
  String nombreApoderado;
  String nombreNacionalidad;
  String mensajes;

  Alumno(
      {this.idAlumno,
      this.rutAlumno,
      this.nombresAlumno,
      this.apellidosAlumno,
      this.fechaNacimientoAlumno,
      this.numeroAlumno,
      this.correoAlumno,
      this.fotoAlumno,
      this.claveAlumno,
      this.apoderado_idApoderado,
      this.institucion_idInstitucion,
      this.nacionalidadAlumno,
      this.responsableAlumno,
      this.estadoAlumno,
      this.nombreInstitucion,
      this.nombreApoderado,
      this.nombreNacionalidad,
      this.mensajes});
  factory Alumno.fromJson(Map<String, dynamic> json) {
    return Alumno(
        idAlumno: json['idAlumno'],
        rutAlumno: json['rutAlumno'],
        nombresAlumno: json['nombresAlumno'],
        apellidosAlumno: json['apellidosAlumno'],
        fechaNacimientoAlumno: json['fechaNacimientoAlumno'],
        numeroAlumno: json['numeroAlumno'],
        correoAlumno: json['correoAlumno'],
        fotoAlumno: json['fotoAlumno'],
        claveAlumno: json['claveAlumno'],
        apoderado_idApoderado: json['apoderado_idApoderado'],
        institucion_idInstitucion: json['institucion_idInstitucion'],
        nacionalidadAlumno: json['nacionalidadAlumno'],
        responsableAlumno: json['responsableAlumno'],
        estadoAlumno: json['estadoAlumno'],
        nombreInstitucion: json['nombreInstitucion'],
        nombreApoderado: json['nombreApoderado'],
        nombreNacionalidad: json['nombreNacionalidad'],
        mensajes: json['mensajes']);
  }
}
