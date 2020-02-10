import 'dart:convert';

import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:http/http.dart' as http;

class ControladorApoderado {
  List<Fechas> fechas;

  static Future mensajesApoderado(idApoderado) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getMensajesApoderado",
        body: {'id': idApoderado});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Mensaje> _mensajes =
        collection.map((json) => Mensaje.fromJson(json)).toList();
    return _mensajes;
  }

  static Future mensajesSinVerApoderado(idApoderado) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getMensajesSinProcesarApoderado",
        body: {'idApoderado': idApoderado});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Mensaje> _mensajesSinVer =
        collection.map((json) => Mensaje.fromJson(json)).toList();
    return _mensajesSinVer;
  }

  static Future institucionApoderado(idApoderado) async {
    http.Response response = await http.post(
        "https://libretavirtual.cl/getInstitucion2",
        body: {'id': idApoderado});

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<Institucion> _institucion =
        collection.map((json) => Institucion.fromJson(json)).toList();
    return _institucion;
  }

  static Future<List<Apoderado>> getPerfilApoderado(id) async {
    http.Response response = await http
        .post("https://libretavirtual.cl/getPerfilApoderado", body: {'id': id});
    await Future.delayed(Duration(seconds: 2));
    String content = response.body;
    List collection = json.decode(content);
    List<Apoderado> _apoderado =
        collection.map((json) => Apoderado.fromJson(json)).toList();
    return _apoderado;
  }

  Future<List<Fechas>> getFechasApoderado(id) async {
    var response = await http.post("https://libretavirtual.cl/getFechasApoderado",
        body: {'idApoderado': id});
    if (response.statusCode == 200 && response.body != '"Error"') {
      fechas = (json.decode(response.body) as List)
          .map((o) => Fechas.fromJson(o))
          .toList();
    }
    return fechas;
  }

  Future agregarVistoApoderado(idApoderado, idMensaje, fechaMensaje) async {
    var response = await http.post("https://libretavirtual.cl/addVistoApoderado",
        body: {
          'idApoderado': idApoderado,
          'idMensaje': idMensaje,
          'fechaEvento': fechaMensaje
        });

    return response.body;
  }

  static Future<String> mensajesSinLeerApoderado(idApoderado) async {
    var response = await http.post(
        "https://libretavirtual.cl/getMensajeSinLeerApoderado",
        body: {'idApoderado': idApoderado});

    return response.body;
  }
}
