class Apoderado {
  String idApoderado;
  String rutApoderado;
  String nombresApoderado;
  String apellidosApoderado;
  String fechaNacimientoApoderado;
  String numeroApoderado;
  String correoApoderado;
  String fotoApoderado;
  String claveApoderado;
  String parentescoApoderado;
  String responsableApoderado;
  String institucionApoderado;
  String estadoApoderado;
  String nombreInstitucion;
  String nombreParentesco;
  String mensajes;

  Apoderado(
      {this.idApoderado,
      this.rutApoderado,
      this.nombresApoderado,
      this.apellidosApoderado,
      this.fechaNacimientoApoderado,
      this.numeroApoderado,
      this.correoApoderado,
      this.fotoApoderado,
      this.claveApoderado,
      this.parentescoApoderado,
      this.responsableApoderado,
      this.institucionApoderado,
      this.estadoApoderado,
      this.nombreInstitucion,
      this.nombreParentesco,
      this.mensajes});

  factory Apoderado.fromJson(Map<String, dynamic> json) {
    return Apoderado(
      idApoderado: json['idApoderado'],
      rutApoderado: json['rutApoderado'],
      nombresApoderado: json['nombresApoderado'],
      apellidosApoderado: json['apellidosApoderado'],
      fechaNacimientoApoderado: json['fechaNacimientoApoderado'],
      numeroApoderado: json['numeroApoderado'],
      correoApoderado: json['correoApoderado'],
      fotoApoderado: json['fotoApoderado'],
      claveApoderado: json['claveApoderado'],
      parentescoApoderado: json['parentescoApoderado'],
      responsableApoderado: json['responsableApoderado'],
      institucionApoderado: json['institucionApoderado'],
      estadoApoderado: json['estadoApoderado'],
      nombreInstitucion: json['nombreInstitucion'],
      nombreParentesco: json['nombreParentesco'],
      mensajes: json['mensajes']
    );
  }
}
