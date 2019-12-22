class Institucion {
  String idInstitucion;
  String nombreInstitucion;
  String descripcionInstitucion;
  String ciudadInstitucion;
  String logoInstitucion;

  Institucion(
      {this.idInstitucion,
      this.nombreInstitucion,
      this.descripcionInstitucion,
      this.ciudadInstitucion,
      this.logoInstitucion});

  factory Institucion.fromJson(Map<String, dynamic> json) {
    return Institucion(
        idInstitucion: json['idInstitucion'],
        nombreInstitucion: json['nombreInstitucion'],
        descripcionInstitucion: json['descripcionInstitucion'],
        ciudadInstitucion: json['ciudadInstitucion'],
        logoInstitucion: json['logoInstitucion']);
  }
}
