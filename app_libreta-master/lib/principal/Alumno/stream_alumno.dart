import 'dart:async';
import 'package:demo_sesion/data/controladorAlumno.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamAlumno {
  

  ControladorAlumno servicio = ControladorAlumno();
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
  String idAlumno;
  String curso = "0";
  String materia;
  int contadorMensajes;

  void cambiarIdAlumno(String dato) {
    idAlumno = dato;
    _controllerAlumno.add(idAlumno);
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
    yield await ControladorAlumno.mensajesAlumnos(idAlumno);
    print("MENSAJES ALUMNO");
  }

  Stream<List<Institucion>> get getInstitucion async* {
    yield await ControladorAlumno.institucionAlumno(idAlumno);
    print("INSTITUCION ALUMNO");
  }

  Stream<List<Mensaje>> get mensajesSinLeer async* {
    yield await ControladorAlumno.mensajesSinVerAlumnos(idAlumno);
    print("MENSAJES SIN VER ALUMNO");
  }

  Stream<List<Curso>> get getCursosAlumnos async* {
    yield await ControladorAlumno.getCursosAlumnos(idAlumno);
    print("CURSOS ALUMNO");
  }

  Stream<List<Materia>> get getMateriasAlumno async* {
    yield await ControladorAlumno.getMateriaAlumnos(curso);
    print("MATERIAS ALUMNO");
  }

  Stream<List<Archivo>> get getArchivos async* {
    yield await ControladorAlumno.getAchivoMateria(curso, materia);
    print("ARCHIVOS ALUMNO");
  }

  Stream<List<Alumno>> get getPerfil async* {
    yield await ControladorAlumno.getPerfilAlumno(idAlumno);
    print("PERFIl ALUMNO");
  }



  Stream<List<Fechas>> get getEventosSemanaAlumno async* {
    yield await ControladorAlumno.getFechasSemanaAlumno(idAlumno);
    print("EVENTOS SEMANA ALUMNO");
  }

  void vistoMensajeAlumno(String idMensaje) async {
    String fecha = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);

    await servicio.agregarVistoAlumno(idAlumno, idMensaje, fecha);
  }
}
