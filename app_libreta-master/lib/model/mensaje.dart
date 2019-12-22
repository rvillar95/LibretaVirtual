class Mensaje{
  final String idMensaje;
  final String nombreMensaje;
  final String descripcionMensaje;
  final String fechaCreacionMensaje;
  final String nombreProfesor;
  final String fotoProfesor;
  final String curso;
  final String visto;

  Mensaje({
      this.idMensaje,
      this.nombreMensaje,
      this.descripcionMensaje,
      this.fechaCreacionMensaje,
      this.nombreProfesor,
      this.fotoProfesor,
      this.curso,
      this.visto});

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idMensaje: json['idMensaje'],
      nombreMensaje: json['nombreMensaje'],
      descripcionMensaje: json['descripcionMensaje'],
      fechaCreacionMensaje: json['fechaCreacionMensaje'],
      nombreProfesor: json['nombreProfesor'],
      fotoProfesor: json['fotoProfesor'],
      curso: json['curso'],
      visto: json['visto']
    );
  }
}
