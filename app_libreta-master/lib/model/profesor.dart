
class Profesor{
  String id;
  String rut;
  String nombres;
  String apellidos;
  String fechaNacimiento;
  String numero;
  String correo;
  String foto;
  String clave;
  String institucion;
  String responsable;
  String estado;
  String nombreInstitucion;
  String mensajes;

  Profesor({this.id, this.rut, this.nombres,this.apellidos,this.fechaNacimiento,
            this.numero,this.correo,this.foto, this.clave,this.institucion,this.responsable,this.estado,this.nombreInstitucion,this.mensajes});

  factory Profesor.fromJson(Map<String, dynamic> json){
    return Profesor(
      id: json['idProfesor'],
      rut: json['rutProfesor'],
      nombres: json['nombresProfesor'],
      apellidos: json['apellidosProfesor'],
      fechaNacimiento: json['fechaNacimientoProfesor'],
      numero: json['numeroProfesor'],
      correo: json['correoProfesor'],
      foto: json['fotoProfesor'],
      clave: json['claveProfesor'],
      institucion: json['institucionProfesor'],
      responsable: json['responsableProfesor'],
      estado: json['estadoProfesor'],
      nombreInstitucion: json['nombreInstitucion'],
      mensajes: json['mensajes']
    );
  }


}