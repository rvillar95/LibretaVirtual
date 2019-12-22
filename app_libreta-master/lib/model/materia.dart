class Materia {
  String idMateria;
  String nombreMateria;
  String imagenMateria;
  Materia({this.idMateria, this.nombreMateria, this.imagenMateria});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
        idMateria: json['idMateria'],
        nombreMateria: json['nombreMateria'],
        imagenMateria: json['imagenMateria']);
  }
}
