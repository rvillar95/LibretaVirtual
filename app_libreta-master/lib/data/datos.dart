import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/taller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:demo_sesion/model/profesor.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/selectalumno.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/alumnoSel.dart';
import 'package:demo_sesion/model/materia.dart';

class Servicio {
  String urlLoginProfesor = 'https://libretavirtual.cl/inicioProfe';
  String urlLoginAlumno = 'https://libretavirtual.cl/inicioAlumno';
  String urlLoginApoderado = 'https://libretavirtual.cl/inicioApoderado';
  String urlCursosProfesor = 'https://libretavirtual.cl/getCursos';
  String urlAlumnosCurso = 'https://libretavirtual.cl/getAlumnos';
  String urlAddEvento = 'https://libretavirtual.cl/addEvento';
  String urlGetMensajesProfesor =
      "https://libretavirtual.cl/getMensajesProfesor";
  String urlGetMensajesApoderado =
      "https://libretavirtual.cl/getMensajesApoderado";
  String urlGetMensajesAlumno = "https://libretavirtual.cl/getMensajesAlumno";
  String urlAddMensajeCurso = 'https://libretavirtual.cl/addMensajeCurso';
  String urlAddMensajeTaller = 'https://libretavirtual.cl/addMensajeTaller';
  String urlGetInstitucion = "https://libretavirtual.cl/getInstitucion2";
  String urlGetAlumnos = "https://libretavirtual.cl/getAlumnos"; //id 1
  String urlGetTalleres = "https://libretavirtual.cl/getTalleres";
  String urlGetFechas = "https://libretavirtual.cl/getFechas";
  String urlAddVistoAlumno = "https://libretavirtual.cl/addVistoAlumno";
  String urlAddVistoApoderado = "https://libretavirtual.cl/addVistoApoderado";
  String urlGetPerfilApoderado = "https://libretavirtual.cl/getPerfilApoderado";
  String urlGetPerfilAlumno = "https://libretavirtual.cl/getPerfilAlumno";
  String urlGetPerfilProfesor = "https://libretavirtual.cl/getPerfilProfesor";
  String urlGetMensajesSinLeerApoderado =
      "https://libretavirtual.cl/getMensajeSinLeerApoderado";
  String urlGetMensajesSinLeerAlumno =
      "https://libretavirtual.cl/getMensajeSinLeerAlumno";
  String urlGetCursosAlumno = "https://libretavirtual.cl/getCursosAlumno";
  String urlGetMateriasAlumno = "https://libretavirtual.cl/getMateriasAlumno";
  String urlGetArchivosMateria = "https://libretavirtual.cl/getArchivosMateria";

  List<AlumnoSel> alumnosSel = [];
  List<Profesor> profesorList = [];
  List<Apoderado> apoderadoList = [];
  List<Alumno> alumnoList = [];
  List<Curso> cursoList = [];
  List<AlumnoSelect> alumnoSelectList = [];
  List<Mensaje> mensajeListProfesor = [];
  List<Mensaje> mensajeListAlumno = [];
  List<Mensaje> mensajeListApoderado = [];
  List<Institucion> institucionList = [];
  List<Taller> tallerList = [];
  List<Fechas> fechas = [];
  List<Apoderado> perfilApoderado = [];
  List<Profesor> perfilProfesor = [];
  List<Alumno> perfilAlumno = [];
  List<Materia> listMateria = [];
  List<Archivo> listArchivo = [];

  Future<List<Profesor>> loginProfesor(rut, clave) async {
    var response =
        await http.post(urlLoginProfesor, body: {'rut': rut, 'clave': clave});

    if (response.statusCode == 200 && response.body != '"Error"') {
      profesorList = (json.decode(response.body) as List)
          .map((o) => Profesor.fromJson(o))
          .toList();
    }
    return profesorList;
  }

  Future<List<Alumno>> loginAlumno(rut, clave, token) async {
    var response = await http.post(urlLoginAlumno,
        body: {'rut': rut, 'clave': clave, 'token': token});

    if (response.statusCode == 200 && response.body != '"Error"') {
      alumnoList = (json.decode(response.body) as List)
          .map((o) => Alumno.fromJson(o))
          .toList();
    }
    return alumnoList;
  }

  Future<List<Apoderado>> loginApoderado(rut, clave, token) async {
    var response = await http.post(urlLoginApoderado,
        body: {'rut': rut, 'clave': clave, 'token': token});

    if (response.statusCode == 200 && response.body != '"Error"') {
      apoderadoList = (json.decode(response.body) as List)
          .map((o) => Apoderado.fromJson(o))
          .toList();
    }
    return apoderadoList;
  }

  Future<List<Curso>> getCursoProfesor(id) async {
    var response = await http.post(urlCursosProfesor, body: {'id': id});

    if (response.statusCode == 200 && response.body != '"Error"') {
      cursoList = (json.decode(response.body) as List)
          .map((o) => Curso.fromJson(o))
          .toList();
    }
    return cursoList;
  }

  Future<List<Taller>> getTallerProfesor(id) async {
    var response = await http.post(urlGetTalleres, body: {'id': id});

    if (response.statusCode == 200 && response.body != '"Error"') {
      tallerList = (json.decode(response.body) as List)
          .map((o) => Taller.fromJson(o))
          .toList();
    }
    return tallerList;
  }

  Future<List<AlumnoSelect>> getAlumnoCurso(id) async {
    var response = await http.post(urlAlumnosCurso, body: {'id': id});

    if (response.statusCode == 200 && response.body != '"Error"') {
      alumnoSelectList = (json.decode(response.body) as List)
          .map((o) => AlumnoSelect.fromJson(o))
          .toList();
    }
    return alumnoSelectList;
  }

  Future agregarEvento(nombre, descripcion, fecha, curso) async {
    var response = await http.post(urlAddEvento, body: {
      'nombreEvento': nombre,
      'descripcionEvento': descripcion,
      'fechaEvento': fecha,
      'idCurso': curso
    });

    return response.body;
  }

  Future<List<Mensaje>> getMensajeProfesor(id) async {
    var response = await http.post(urlGetMensajesProfesor, body: {"id": id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      mensajeListProfesor = (json.decode(response.body) as List)
          .map((o) => Mensaje.fromJson(o))
          .toList();
    }
    return mensajeListProfesor;
  }

  Future<List<Mensaje>> getMensajeAlumno(id) async {
    var response = await http.post(urlGetMensajesAlumno, body: {"id": id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      mensajeListAlumno = (json.decode(response.body) as List)
          .map((o) => Mensaje.fromJson(o))
          .toList();
    }
    return mensajeListAlumno;
  }

  Future<List<Mensaje>> getMensajeApoderado(id) async {
    var response = await http.post(urlGetMensajesApoderado, body: {"id": id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      mensajeListApoderado = (json.decode(response.body) as List)
          .map((o) => Mensaje.fromJson(o))
          .toList();
    }
    return mensajeListApoderado;
  }

  Future enviarMensajeCurso(
      nombre, descripcion, fecha, curso, alumnos, profe) async {
    var response = await http.post(urlAddMensajeCurso, body: {
      'nombreMensaje': nombre,
      'descripcionMensaje': descripcion,
      'fechaCreacionMensaje': fecha,
      'idCurso': curso,
      'alumnos': alumnos,
      'idProfesor': profe,
    });
    return response.body;
  }

  Future enviarMensajeTaller(
      nombre, descripcion, fecha, curso, listAlumnos, profe) async {
    var response = await http.post(urlAddMensajeTaller, body: {
      'nombreMensaje': nombre,
      'descripcionMensaje': descripcion,
      'fechaCreacionMensaje': fecha,
      'idCurso': curso,
      'alumnos': listAlumnos,
      'idProfesor': profe,
    });
    if (response.statusCode == 200) {
      return "ok";
    } else {
      return "no";
    }
  }

  Future<List<Institucion>> getInstitucion() async {
    var response = await http.post(urlGetInstitucion);
    if (response.statusCode == 200 && response.body != '"Error"') {
      institucionList = (json.decode(response.body) as List)
          .map((o) => Institucion.fromJson(o))
          .toList();
    }
    return institucionList;
  }

  Future<List<AlumnoSel>> getAlumnosSel(String id) async {
    var response = await http.post(urlGetAlumnos, body: {'id': id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      alumnosSel = (json.decode(response.body) as List)
          .map((o) => AlumnoSel.fromJson(o))
          .toList();
    } else {
      print("algo anda mal");
    }
    return alumnosSel;
  }

  Future<List<Fechas>> getFechas() async {
    var response = await http.post(urlGetFechas);
    if (response.statusCode == 200 && response.body != '"Error"') {
      fechas = (json.decode(response.body) as List)
          .map((o) => Fechas.fromJson(o))
          .toList();
    }
    return fechas;
  }

  Future agregarVistoAlumno(idAlumno, idMensaje, fechaMensaje) async {
    var response = await http.post(urlAddVistoAlumno, body: {
      'idAlumno': idAlumno,
      'idMensaje': idMensaje,
      'fechaEvento': fechaMensaje
    });

    return response.body;
  }

  Future agregarVistoApoderado(idApoderado, idMensaje, fechaMensaje) async {
    var response = await http.post(urlAddVistoApoderado, body: {
      'idApoderado': idApoderado,
      'idMensaje': idMensaje,
      'fechaEvento': fechaMensaje
    });

    return response.body;
  }

  Future<List<Apoderado>> getPerfilApoderado(id) async {
    var response = await http.post(urlGetPerfilApoderado, body: {"id": id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      perfilApoderado = (json.decode(response.body) as List)
          .map((o) => Apoderado.fromJson(o))
          .toList();
    }
    return perfilApoderado;
  }

  Future<List<Alumno>> getPerfilAlumno(id) async {
    var response = await http.post(urlGetPerfilAlumno, body: {"id": id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      perfilAlumno = (json.decode(response.body) as List)
          .map((o) => Alumno.fromJson(o))
          .toList();
    }
    return perfilAlumno;
  }

  Future<List<Profesor>> getPerfilProfesor(id) async {
    var response = await http.post(urlGetPerfilProfesor, body: {"id": id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      perfilProfesor = (json.decode(response.body) as List)
          .map((o) => Profesor.fromJson(o))
          .toList();
    }
    return perfilProfesor;
  }

  Future mensajesSinLeerApoderado(idApoderado) async {
    var response = await http.post(urlGetMensajesSinLeerApoderado,
        body: {'idApoderado': idApoderado});

    return response.body;
  }

  Future mensajesSinLeerAlumno(idAlumno) async {
    var response = await http
        .post(urlGetMensajesSinLeerAlumno, body: {'idAlumno': idAlumno});

    return response.body;
  }

  Future<List<Curso>> getCursosAlumnos(id) async {
    var response = await http.post(urlGetCursosAlumno, body: {'idAlumno': id});

    if (response.statusCode == 200 && response.body != '"Error"') {
      cursoList = (json.decode(response.body) as List)
          .map((o) => Curso.fromJson(o))
          .toList();
    }
    return cursoList;
  }

  Future<List<Materia>> getMateriaAlumnos(id) async {
    var response = await http.post(urlGetMateriasAlumno, body: {'idCurso': id});

    if (response.statusCode == 200 && response.body != '"Error"') {
      listMateria = (json.decode(response.body) as List)
          .map((o) => Materia.fromJson(o))
          .toList();
    }
    return listMateria;
  }

  Future<List<Archivo>> getAchivoMateria(idCurso, idMateria) async {
    var response = await http.post(urlGetArchivosMateria,
        body: {'idCurso': idCurso, 'idMateria': idMateria});

    if (response.statusCode == 200 && response.body != '"Error"') {
      listArchivo = (json.decode(response.body) as List)
          .map((o) => Archivo.fromJson(o))
          .toList();
    }
    return listArchivo;
  }
}
