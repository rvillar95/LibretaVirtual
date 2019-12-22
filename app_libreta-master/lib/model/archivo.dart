class Archivo {
  String idArchivo;
  String nombreArchivo;
  String descripcionArchivo;
  String formatoArchivo;
  String rutaArchivo;
  String cursoProfesorArchivo;
  String materiaArchivo;
  String idcarpetaCurso;
  String nombreMateria;
  String nombreProfesor;


  Archivo(
      {this.idArchivo,
      this.nombreArchivo,
      this.descripcionArchivo,
      this.formatoArchivo,
      this.rutaArchivo,
      this.cursoProfesorArchivo,
      this.materiaArchivo,
      this.idcarpetaCurso,
      this.nombreMateria,
      this.nombreProfesor});

  factory Archivo.fromJson(Map<String, dynamic> json) {
    return Archivo(
        idArchivo: json['idArchivo'],
        nombreArchivo: json['nombreArchivo'],
        descripcionArchivo: json['descripcionArchivo'],
        formatoArchivo: json['formatoArchivo'],
        rutaArchivo: json['rutaArchivo'],
        cursoProfesorArchivo: json['cursoProfesorArchivo'],
        materiaArchivo: json['materiaArchivo'],
        idcarpetaCurso: json['idcarpetaCurso'],
        nombreMateria: json['nombreMateria'],
        nombreProfesor: json['nombreProfesor']);
  }
}
