class Fechas {
  String idEvento;
  String fecha;
  String nombreEvento;
  String descripcionEvento;
  String fechaEvento;

  Fechas({this.idEvento,this.fecha,this.nombreEvento,this.descripcionEvento,this.fechaEvento});

  factory Fechas.fromJson(Map<String, dynamic> json) {
    return Fechas(idEvento: json['idEvento'],fecha: json['fecha'],nombreEvento: json['nombreEvento'],descripcionEvento: json['descripcionEvento'],fechaEvento: json['fechaEvento']);
  }
}
