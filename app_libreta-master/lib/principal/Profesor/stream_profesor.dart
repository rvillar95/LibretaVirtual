import 'dart:async';
import 'package:demo_sesion/data/controladorAlumno.dart';
import 'package:demo_sesion/data/controladorApoderado.dart';
import 'package:demo_sesion/data/controladorProfesor.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/alumnoSel.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:demo_sesion/model/profesor.dart';
import 'package:demo_sesion/principal/Alumno/stream_alumno.dart';
import 'package:flutter/material.dart';

class StreamProfesor {
  ControladorApoderado servicio = ControladorApoderado();
  final mensajes = <Mensaje>[];
  final _controllerCounter = StreamController<int>();
  final _controllerAlumnos = StreamController<List<AlumnoSel>>();
  final _controllerAlumnos2 = StreamController<String>();
  final _controllerCurso = StreamController<String>();
  final _controllerContadorArchivo = StreamController<int>();
  final _controllerMateria = StreamController<String>();
  final _controllerProfesor = StreamController<String>();
  final controllerFecha = StreamController<DateTime>();
  final _controllerHora = StreamController<TimeOfDay>();
  final _controllerFechaTotal = StreamController<String>();
  final _controllerHoraTotal = StreamController<String>();
  var controller = new StreamController<String>();

  Stream<int> get streamCounterArchivo => _controllerContadorArchivo.stream;
  Stream<int> get streamCounter => _controllerCounter.stream;
  Stream<List<AlumnoSel>> get streamAlumnos => _controllerAlumnos.stream;
  Stream<String> get streamAlumnos2 => _controllerAlumnos2.stream;

  Stream<String> get streamCurso => _controllerCurso.stream;
  Stream<String> get streamMateria => _controllerMateria.stream;
  Stream<String> get streamProfesor => _controllerProfesor.stream;
  Stream<DateTime> get streamFecha => controllerFecha.stream;
  Stream<TimeOfDay> get streamHora => _controllerHora.stream;

  Stream<String> get streamFechaTotal => _controllerFechaTotal.stream;
  Stream<String> get streamHoraTotal => _controllerHoraTotal.stream;
  DateTime fecha;
  TimeOfDay hora;

  int counterAchivo = 0;
  int counter = 0;
  int nMaterias = 0;
  String idProfesor;
  String curso = "0";
  String materia;
  String alu;
  String h;
  String f;
  int contadorMensajes;
  List<AlumnoSel> alumnos;

  void cambiarIdProfesor(String dato) {
    idProfesor = dato;
    _controllerProfesor.add(idProfesor);
  }

  void pruebaAlumno(String hola) {
    controller.add(hola);
  }

  String mostrarPrueba() {
    controller.stream.listen((item) => print(item));
  }

  void guardarHora(TimeOfDay dato) {
    hora = dato;
    _controllerHora.add(dato);
  }

  void guardarFecha(DateTime dato) {
    fecha = dato;
    controllerFecha.add(dato);
  }

  final StreamController<String> _finalAlumno = StreamController<String>();
  Stream<String> get finalAlumno => _finalAlumno.stream;

  void wawa(String hola) {
    _finalAlumno.add(hola);
  }

  void saveAlumnos(String dato) {
    alu = dato;
    _controllerAlumnos2.add(alu);
  }

  void saveHora(String dato) {
    h = dato;
    _controllerHoraTotal.add(dato);
  }

  void saveFecha(String dato) {
    f = dato;
    _controllerFechaTotal.add(dato);
  }

  void closeStream() {
    _contadorSinVer.close();
    _contadorFechasSemana.close();
  }

  void resetCounter(int hola) {
    counter = hola;
    _controllerCounter.add(counter);
  }

  void cargarAlumnos(List<AlumnoSel> lista) {
    _controllerAlumnos.add(lista);
  }

  void contadorArchivo(int hola) {
    counterAchivo = hola;
    _controllerContadorArchivo.add(counterAchivo);
  }

  void guardarCurso(String hola) {
    curso = hola;
    _controllerCurso.add(curso);
  }

  final StreamController<int> _contadorSinVer = StreamController<int>();
  Stream<int> get contadorSinVer => _contadorSinVer.stream;

  final StreamController<int> _contadorFechasSemana = StreamController<int>();
  Stream<int> get contadorFechasSemana => _contadorFechasSemana.stream;

  Stream<List<AlumnoSel>> get listViewAlumnos async* {
    await controller.stream.listen((item) => print(item));
  }

  Stream<List<Mensaje>> get listViewMensajes async* {
    yield await ControladorProfesor.mensajesProfesor(idProfesor);
    print("MENSAJES Profesor");
  }

  Stream<List<Curso>> get getCursosProfesor async* {
    yield await ControladorProfesor.getCursosProfesor(idProfesor);
    print("CURSOS Profesor");
  }

  Stream<List<Mensaje>> get mensajesSinLeer async* {
    yield await ControladorApoderado.mensajesSinVerApoderado(idProfesor);
    print("MENSAJES SIN VER APODERADO");
  }

  Stream<List<Profesor>> get getPerfil async* {
    yield await ControladorProfesor.getPerfilProfesor(idProfesor);
    print("PERFIl APODERADO");
  }

  void vistoMensajeApoderado(String idMensaje) async {
    String fecha = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);

    await servicio.agregarVistoApoderado(idProfesor, idMensaje, fecha);
  }
}
