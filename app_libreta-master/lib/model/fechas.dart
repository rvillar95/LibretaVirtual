class Fechas {
  String idEvento;
  String fecha;
  String nombreEvento;
  String descripcionEvento;
  String fechaEvento;
  String nombreProfesor;
  Fechas({this.idEvento,this.fecha,this.nombreEvento,this.descripcionEvento,this.fechaEvento,this.nombreProfesor});

  factory Fechas.fromJson(Map<String, dynamic> json) {
    return Fechas(idEvento: json['idEvento'],fecha: json['fecha'],nombreEvento: json['nombreEvento'],descripcionEvento: json['descripcionEvento'],fechaEvento: json['fechaEvento'],nombreProfesor: json['nombreProfesor']);
  }
}
