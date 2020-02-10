import 'dart:convert';

import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:http/http.dart' as http;

class ControladorAlumno {
  List<Fechas> fechas;

  static Future mensajesAlumnos(idAlumno) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getMensajesAlumno",
        body: {'id': idAlumno});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Mensaje> _mensajes =
        collection.map((json) => Mensaje.fromJson(json)).toList();
    return _mensajes;
  }

  static Future mensajesSinVerAlumnos(idAlumno) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getMensajesSinProcesarAlumno",
        body: {'idAlumno': idAlumno});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Mensaje> _mensajesSinVer =
        collection.map((json) => Mensaje.fromJson(json)).toList();
    return _mensajesSinVer;
  }

  static Future institucionAlumno(idAlumno) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getInstitucion2",
        body: {'id': idAlumno});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Institucion> _institucion =
        collection.map((json) => Institucion.fromJson(json)).toList();
    return _institucion;
  }

  static Future<List<Curso>> getCursosAlumnos(id) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getCursosAlumno",
        body: {'idAlumno': id});

    //  await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Curso> _curso =
        collection.map((json) => Curso.fromJson(json)).toList();
    return _curso;
  }

  static Future<List<Materia>> getMateriaAlumnos(id) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getMateriasAlumno",
        body: {'idCurso': id});

    //  await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Materia> _materia =
        collection.map((json) => Materia.fromJson(json)).toList();
    return _materia;
  }

  static Future<List<Archivo>> getAchivoMateria(idCurso, idMateria) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getArchivosMateria",
        body: {'idCurso': idCurso, 'idMateria': idMateria});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Archivo> _archivo =
        collection.map((json) => Archivo.fromJson(json)).toList();
    return _archivo;
  }

  static Future<List<Alumno>> getPerfilAlumno(id) async {
    http.Response response = await http
        .post("https://libretavirtual.cl/getPerfilAlumno", body: {'id': id});
    await Future.delayed(Duration(seconds: 2));
    String content = response.body;
    List collection = json.decode(content);
    List<Alumno> _alumno =
        collection.map((json) => Alumno.fromJson(json)).toList();
    return _alumno;
  }

  Future<List<Fechas>> getFechasAlumno(id) async {
    var response = await http.post("https://libretavirtual.cl/getFechasAlumno",
        body: {'idAlumno': id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      fechas = (json.decode(response.body) as List)
          .map((o) => Fechas.fromJson(o))
          .toList();
    }
    return fechas;
  }

  static Future<List<Fechas>> getFechasSemanaAlumno(id) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getFechasSemanaAlumno",
        body: {'idAlumno': id});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Fechas> _fechas =
        collection.map((json) => Fechas.fromJson(json)).toList();
    return _fechas;
  }

  Future agregarVistoAlumno(idAlumno, idMensaje, fechaMensaje) async {
    var response = await http.post("https://libretavirtual.cl/addVistoAlumno",
        body: {
          'idAlumno': idAlumno,
          'idMensaje': idMensaje,
          'fechaEvento': fechaMensaje
        });

    return response.body;
  }

  static Future<String> mensajesSinLeerAlumno(idAlumno) async {
    var response = await http.post(
        "https://libretavirtual.cl/getMensajeSinLeerAlumno",
        body: {'idAlumno': idAlumno});

    return response.body;
  }
}
