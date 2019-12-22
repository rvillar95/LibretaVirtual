class Taller {
  String idTaller;
  String nombreTaller;

  Taller({this.idTaller, this.nombreTaller});

  factory Taller.fromJson(Map<String, dynamic> json) {
    return Taller(
        idTaller: json['idTaller'], nombreTaller: json['nombreTaller']);
  }
}
