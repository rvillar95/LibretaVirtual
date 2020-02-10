import 'dart:async';
import 'package:demo_sesion/data/controladorAlumno.dart';
import 'package:demo_sesion/data/controladorApoderado.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:flutter/material.dart';


class StreamApoderado {
  

  ControladorApoderado servicio = ControladorApoderado();
  final mensajes = <Mensaje>[];
  final _controllerCounter = StreamController<int>();
  final _controllerCurso = StreamController<String>();
  final _controllerContadorArchivo = StreamController<int>();
  final _controllerMateria = StreamController<String>();
  final _controllerAlumno = StreamController<String>();

  Stream<int> get streamCounterArchivo => _controllerContadorArchivo.stream;
  Stream<int> get streamCounter => _controllerCounter.stream;
  Stream<String> get streamCurso => _controllerCurso.stream;
  Stream<String> get streamMateria => _controllerMateria.stream;
  Stream<String> get streamAlumno => _controllerAlumno.stream;

  int counterAchivo = 0;
  int counter = 0;
  int nMaterias = 0;
  String idApoderado;
  String curso = "0";
  String materia;
  int contadorMensajes;

  void cambiarIdApoderado(String dato) {
    idApoderado = dato;
    _controllerAlumno.add(idApoderado);
  }

  void closeStream() {
    _contadorSinVer.close();
    _contadorFechasSemana.close();
  }

  void resetCounter(int hola) {
    counter = hola;
    _controllerCounter.add(counter);
  }

  void contadorArchivo(int hola) {
    counterAchivo = hola;
    _controllerContadorArchivo.add(counterAchivo);
  }

  void guardarCurso(String hola) {
    curso = hola;
    _controllerCurso.add(curso);
  }

  void guardarMateria(String hola) {
    materia = hola;
    _controllerMateria.add(materia);
  }

  final StreamController<int> _contadorSinVer = StreamController<int>();
  Stream<int> get contadorSinVer => _contadorSinVer.stream;

  final StreamController<int> _contadorFechasSemana = StreamController<int>();
  Stream<int> get contadorFechasSemana => _contadorFechasSemana.stream;

  Stream<List<Mensaje>> get listViewMensajes async* {
    yield await ControladorApoderado.mensajesApoderado(idApoderado);
    print("MENSAJES APODERADO");
  }

  Stream<List<Institucion>> get getInstitucion async* {
    yield await ControladorApoderado.institucionApoderado(idApoderado);
    print("INSTITUCION APODERADO");
  }

  Stream<List<Mensaje>> get mensajesSinLeer async* {
    yield await ControladorApoderado.mensajesSinVerApoderado(idApoderado);
    print("MENSAJES SIN VER APODERADO");
  }



  Stream<List<Apoderado>> get getPerfil async* {
    yield await ControladorApoderado.getPerfilApoderado(idApoderado);
    print("PERFIl APODERADO");
  }

  void vistoMensajeApoderado(String idMensaje) async {
    String fecha = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);

    await servicio.agregarVistoApoderado(idApoderado, idMensaje, fecha);
  }
}
