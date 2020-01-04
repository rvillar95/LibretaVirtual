import 'dart:async';
import 'package:demo_sesion/data/datos.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamAlumno {
  final _controllerCounter = StreamController<int>();
  final _controllerCurso = StreamController<String>();
  final _controllerTheme = StreamController<bool>();
  final _controllerContadorArchivo = StreamController<int>();
  final _controllerMateria = StreamController<String>();

  Stream<int> get streamCounterArchivo => _controllerContadorArchivo.stream;
  Stream<bool> get streamTheme => _controllerTheme.stream;
  Stream<int> get streamCounter => _controllerCounter.stream;
  Stream<String> get streamCurso => _controllerCurso.stream;
  Stream<String> get streamMateria => _controllerMateria.stream;

  int counterAchivo = 0;
  int counter = 0;
  int nMaterias = 0;
  String curso = "0";
  String materia;

  bool _isDark = false;

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

  final String idAlumno;
  StreamAlumno(this.idAlumno) {
    listViewMensajes.listen((list) => _contadorMensaje.add(list.length));
    mensajesSinLeer.listen((list) => _contadorSinVer.add(list.length));
    getArchivos.listen((list) => _contadorArchivos.add(list.length));
    getMateriasAlumno.listen((list) => _contadorMaterias.add(list.length));
  }
  Servicio servicio = Servicio();

  final StreamController<int> _contadorMensaje = StreamController<int>();
  Stream<int> get contadorMensaje => _contadorMensaje.stream;

  final StreamController<int> _contadorSinVer = StreamController<int>();
  Stream<int> get contadorSinVer => _contadorSinVer.stream;

  final StreamController<int> _contadorArchivos = StreamController<int>();
  Stream<int> get contadorArchivos => _contadorArchivos.stream;

  final StreamController<int> _contadorMaterias = StreamController<int>();
  Stream<int> get contadorMaterias => _contadorMaterias.stream;

  Stream<List<Mensaje>> get listViewMensajes async* {
    yield await Servicio.mensajesAlumnos(idAlumno);
    print(Servicio.mensajesAlumnos(idAlumno));
  }

  Stream<List<Institucion>> get getInstitucion async* {
    yield await Servicio.institucionAlumno(idAlumno);
  }

  Stream<List<Mensaje>> get mensajesSinLeer async* {
    yield await Servicio.mensajesSinVerAlumnos(idAlumno);
  }

  Stream<List<Curso>> get getCursosAlumnos async* {
    yield await Servicio.getCursosAlumnos(idAlumno);
  }

  Stream<List<Materia>> get getMateriasAlumno async* {
    yield await Servicio.getMateriaAlumnos(curso);
  }

  Stream<List<Archivo>> get getArchivos async* {
    yield await Servicio.getAchivoMateria(curso, materia);
  }

  Stream<List<Alumno>> get getPerfil async* {
    yield await Servicio.getPerfilAlumno(idAlumno);
  }

  void vistoMensajeAlumno(String idMensaje) async {
    String fecha = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);

    await servicio.agregarVistoAlumno(idAlumno, idMensaje, fecha);
  }
}
