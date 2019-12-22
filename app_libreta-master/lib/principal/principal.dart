import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/profesor.dart';
import 'package:demo_sesion/model/taller.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_sesion/login/login.dart';
import 'package:demo_sesion/principal/calendario.dart';
import 'package:demo_sesion/principal/detalle_mensaje.dart';
import 'package:demo_sesion/data/datos.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/alumnoSel.dart';
import 'dart:async';
import 'package:demo_sesion/principal/cal.dart';
import 'package:demo_sesion/principal/data_table.dart';
import 'package:demo_sesion/principal/prueba.dart';

class PrincipalMenu extends StatefulWidget {
  List<AlumnoSel> alumnosSeleccionados = [];
  int resp;
  int text2;
  String seleccion;
  String idCurso;
  PrincipalMenu(this.alumnosSeleccionados, this.resp, this.text2,
      this.seleccion, this.idCurso);
  @override
  State<StatefulWidget> createState() => new _MyButtonState(
      this.alumnosSeleccionados,
      this.resp,
      this.text2,
      this.seleccion,
      this.idCurso);
}

class _MyButtonState extends State<PrincipalMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  List<AlumnoSel> alumnosSeleccionados = [];
  int resp;
  String seleccion;
  int text2;
  String idCurso;
  _MyButtonState(this.alumnosSeleccionados, this.resp, this.text2,
      this.seleccion, this.idCurso);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _loadData();
  }

  final verde = const Color(0xF5970B);
  List<DropdownMenuItem<String>> items = [];
  String valor = "0";
  String nombreEvento = "";
  String descripcionEvento = "";
  String nombreMensaje = "";
  String descripcionMensaje = "";
  String fechaMensaje = DateTime.now().toString().substring(0, 11) +
      " " +
      TimeOfDay.now().toString().substring(10, 15);
  List<String> data = [];
  int text;
  Widget respuestaMensajes = Text("");
  String _value = "1";
  String _value2;

  List<Curso> cursoList;
  List<AlumnoSel> alumnoSelectList;
  List<String> alumnosFinal = [];
  List<Taller> tallerList;
  List<Mensaje> mensajeListProfesor;
  List<Mensaje> mensajeListAlumno;
  List<Mensaje> mensajeListApoderado;
  List<Institucion> institucionList;
  int contador = 0;
  int boton = 0;
  int contAlumn = 0;
  int contadorT = 0;
  int respuesta;
  int respuestaMensaje;
  int prueba;
  int contadorCursoAlumno = 0;
  int contadorArchivo = 0;
  int prueba2;
  int prueba3;
  int prueba4;
  int prueba5;
  int contFecha = 0;
  int pruebaInstitucion;
  int contadorPerfilApoderado;
  int contadorPerfilAlumno;
  int contadorPerfilProfesor;
  int contadorMateriaAlumno = 0;
  int contadorAviso = 0;
  int contadorAviso1 = 0;
  String contMsgApoderado = "";
  String contMsgAlumno = "";
  String valorCurso = "";
  String valorMateria = "";
  DateTime _fecha = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();
  Widget listview = Text("");
  List<AlumnoSel> alumnos = [];
  List<Fechas> fechas = [];
  List<Apoderado> listPerfilApoderado = [];
  List<Profesor> listPerfilProfesor = [];
  List<Alumno> listPerfilAlumno = [];
  List<Materia> listMateria = [];
  List<Archivo> listArchivo = [];
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<Null> _seleccionarFecha(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _fecha,
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2025));

    if (picked != null && picked != _fecha) {
      print('Fecha Seleccionada :${_fecha.toString()}');
      setState(() {
        _fecha = picked;
      });
    }
  }

  int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  Future<Null> _seleccionarHora(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _hora);

    if (picked != null && picked != _hora) {
      print('Hora Seleccionada :${_hora.toString()}');
      setState(() {
        _hora = picked;
      });
    }
  }

  void loadAlumnos(id, seleccion) {
    print("xxxxxxxxxxxxxxxxxxx");
    print(id);
    print("xxxxxxxxxxxxxxxxxxx");
    Servicio servicio = Servicio();
    setState(() {
      listview = Center(child: CircularProgressIndicator());
      //listview=Center(child:WaveProgress(100.0, Colors.blue, Colors.blueAccent,50.0));
    });
    new Future<List<AlumnoSel>>.delayed(Duration(seconds: 2), () {
      Future<List<AlumnoSel>> future = servicio.getAlumnosSel(id);
      future.then((List<AlumnoSel> value) {
        setState(() {
          alumnos = value;
          if (alumnos.length == 0) {
            listview = Text("Sin Registros");
          } else {
            listview = DataTableDemo(alumnos, seleccion, _value);
          }
        });
      });
    });
  }

  void cargarAlumnos(id) async {
    Servicio servicio = Servicio();
    var ccc = await servicio.getAlumnosSel(id);
    setState(() {
      alumnos = ccc;
    });

    print("TAM: ${alumnos.length}");
    for (AlumnoSel a in alumnos) {
      print(a.nombreAlumno);
    }
  }

  void agregarEvento() async {
    Servicio servicio = Servicio();
    String fecha = _fecha.toString().substring(0, 11);
    String hora = _hora.toString().substring(10, 15);
    String fechaTotal = fecha + hora;
    String resultado = await servicio.agregarEvento(
        nombreEvento, descripcionEvento, fechaTotal, _value);
    print(resultado);
    if (resultado == "ok") {
      alertMensaje("Evento Agregado");
    } else if (resultado == "error") {
      alertMensaje("Evento no");
    } else if (resultado == "vacio") {
      alertMensaje("Faltan datos para agregar Evento");
    }
  }

  void vistoMensajeAlumno(String idMensaje) async {
    Servicio servicio = Servicio();
    String fecha = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);
    String resultado =
        await servicio.agregarVistoAlumno(data[0], idMensaje, fecha);
    print(resultado);
  }

  void vistoMensajeApoderado(String idMensaje) async {
    Servicio servicio = Servicio();
    String fecha = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);
    String resultado =
        await servicio.agregarVistoApoderado(data[0], idMensaje, fecha);
    print(resultado);
  }

  void mensajesSinLeerApoderado() async {
    Servicio servicio = Servicio();
    String resultado = await servicio.mensajesSinLeerApoderado(data[0]);
    print("apo1");
    if (resultado != "0") {
      setState(() {
        contadorAviso = 1;
        contMsgApoderado = resultado;
      });
    } else {
      setState(() {
        contadorAviso = 0;

        contMsgApoderado = resultado;
      });
    }
  }

  void mensajesSinLeerAlumno() async {
    Servicio servicio = Servicio();
    String resultado = await servicio.mensajesSinLeerAlumno(data[0]);
    print("alu");
    if (resultado != "0") {
      setState(() {
        contadorAviso1 = 1;
        contMsgAlumno = resultado;
      });
    } else {
      setState(() {
        contadorAviso1 = 0;
        contMsgAlumno = resultado;
      });
    }
  }

  enviarMensaje() async {
    String alumnos = "";
    for (var i = 0; i < alumnosSeleccionados.length; i++) {
      alumnos = alumnosSeleccionados[i].idAlumno + ",${alumnos}";
    }
    Servicio servicio = Servicio();
    if (seleccion == "") {
      alertMensaje("Seleccione Curso o Taller");
    } else {
      String resultado = await servicio.enviarMensajeCurso(nombreMensaje,
          descripcionMensaje, fechaMensaje, _value, alumnos, data[0]);
      print("bbb");
      print(resultado);
      respuestaMensajes = Text("");
      setState(() {
        if (resultado == "ok") {
          respuestaMensajes = Text("");
          respuestaMensajes = Center(
              child: Text(
            "Mensaje Enviado",
            style: TextStyle(
                color: Colors.green,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ));
        } else if (resultado == "error") {
          respuestaMensajes = Text("");
          respuestaMensajes = Center(
              child: Text(
            "Error al enviar Mensaje",
            style: TextStyle(
                color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),
          ));
        } else if (resultado == "vacio") {
          respuestaMensajes = Text("");
          respuestaMensajes = Center(
              child: Text(
            "Faltan Datos para enviar Mensaje",
            style: TextStyle(
                color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),
          ));
        }
      });
    }
  }

  void getMensajeProfesor() async {
    Servicio servicio = Servicio();
    print(data[0]);
    mensajeListProfesor = await servicio.getMensajeProfesor(data[0]);
    print(mensajeListProfesor.length);
    if (mensajeListProfesor.length > 0) {
      prueba3 = 1;
      setState(() {
        if (prueba3 == 1) {
          mensajeTotalProfesor();
        } else {
          print("error");
        }
      });
    } else {
      print("false");
    }
  }

  void getMensajeApoderado() async {
    Servicio servicio = Servicio();
    print(data[0]);
    mensajeListApoderado = await servicio.getMensajeApoderado(data[0]);
    print(mensajeListApoderado.length);
    if (mensajeListApoderado.length > 0) {
      prueba5 = 1;
      setState(() {
        if (prueba5 == 1) {
          mensajeTotalApoderado();
        } else {
          print("error");
        }
      });
    } else {
      print("false");
    }
  }

  void getMensajeAlumno() async {
    Servicio servicio = Servicio();
    print(data[0]);
    mensajeListAlumno = await servicio.getMensajeAlumno(data[0]);
    print(mensajeListAlumno.length);
    if (mensajeListAlumno.length > 0) {
      prueba2 = 1;
      setState(() {
        mensajeTotalAlumno();
      });
    } else {
      print("false");
    }
  }

  void getPerfilApoderado() async {
    Servicio servicio = Servicio();
    listPerfilApoderado = await servicio.getPerfilApoderado(data[0]);

    print(listPerfilApoderado.length);

    if (listPerfilApoderado.length > 0) {
      setState(() {
        contadorPerfilApoderado = 1;
      });
    } else {
      print("false");
    }
  }

  void getPerfilAlumno() async {
    Servicio servicio = Servicio();
    listPerfilAlumno = await servicio.getPerfilAlumno(data[0]);

    print(listPerfilAlumno.length);
    print(listPerfilAlumno[0].rutAlumno);
    if (listPerfilAlumno.length > 0) {
      setState(() {
        contadorPerfilAlumno = 1;
      });
    } else {
      print("false");
    }
  }

  void getPerfilProfesor() async {
    Servicio servicio = Servicio();
    listPerfilProfesor = await servicio.getPerfilProfesor(data[0]);

    print(listPerfilProfesor.length);
    print(listPerfilProfesor[0].rut);
    if (listPerfilProfesor.length > 0) {
      setState(() {
        contadorPerfilProfesor = 1;
      });
    } else {
      print("false");
    }
  }

  void getFechas() async {
    Servicio servicio = Servicio();
    fechas = await servicio.getFechas();
    if (fechas.length > 0) {
      contFecha = 1;
      setState(() {
        if (contFecha == 1) {
          pruebaFechas();
        } else {
          print("error");
        }
      });
    } else {
      print("Error");
    }
  }

  void getInstitucion() async {
    Servicio servicio = Servicio();
    institucionList = await servicio.getInstitucion();
    print(institucionList.length);
    print(institucionList[0].nombreInstitucion);
    if (institucionList.length > 0) {
      pruebaInstitucion = 1;
      setState(() {
        if (pruebaInstitucion == 1) {
          institucionTotal();
        } else {
          print("error");
        }
      });
    } else {
      print("false");
    }
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = (prefs.getStringList('data') ?? []);
    });
  }

  _removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('data');
  }

  void cursosProfesor() async {
    Servicio servicio = Servicio();
    cursoList = await servicio.getCursoProfesor(data[0]);
    print(cursoList.length);
    if (cursoList.length > 0) {
      print("+++++++++++++");
      contador = 1;
      setState(() {
        if (contador == 1) {
          _crearDropdown();
          _crearDropdownBlanco();
        } else {
          print("Error");
        }
      });
    } else {
      contador = 0;
    }
  }

  void cursosAlumnos() async {
    Servicio servicio = Servicio();
    cursoList = await servicio.getCursosAlumnos(data[0]);
    print(cursoList.length);
    if (cursoList.length > 0) {
      setState(() {
        contadorCursoAlumno = 1;
        _cursosAlumno();
      });
    } else {}
  }

  void archivoMateria() async {
    Servicio servicio = Servicio();
    listArchivo = await servicio.getAchivoMateria(valorCurso, valorMateria);
    print("curso:" + valorCurso);
    print("materia:" + valorMateria);
    print(listArchivo.length);
    if (listArchivo.length > 0) {
      setState(() {
        contadorArchivo = 1;
      });
    } else if (listArchivo.length == 0) {
      setState(() {
        contadorArchivo = 0;
      });
    }
  }

  void materiasAlumno(_value) async {
    Servicio servicio = Servicio();
    listMateria = await servicio.getMateriaAlumnos(_value);
    print("///////////////");
    print(listMateria.length);
    print("///////////////");
    if (listMateria.length > 0) {
      contadorMateriaAlumno = 1;
      setState(() {
        if (contadorMateriaAlumno == 1) {
        } else {
          print("Error");
        }
      });
    } else {
      contadorMateriaAlumno = 0;
    }
  }

  void talleresProfesor() async {
    Servicio servicio = Servicio();
    print("2222222222222222222222");
    tallerList = await servicio.getTallerProfesor(data[0]);
    print("33333333333333333333333");
    if (tallerList.length > 0) {
      contadorT = 1;
      setState(() {
        if (contadorT == 1) {
          _crearDropdownTaller();
        } else {
          print("Error");
        }
      });
    } else {
      print("llllllllllllllllll");
      print(tallerList.length);
      print("llllllllllllllllll");
      print(contadorT);
      print("llllllllllllllllll");
    }
  }

  Widget eventoCorrecto(String respuesta) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blue,
      content: Text(respuesta),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Salir',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget eventoErroneo(String respuesta) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blue,
      content: Text(respuesta),
      action: SnackBarAction(
        label: 'Salir',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void alertMensaje(String hola) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text(hola),
        action: SnackBarAction(
          label: 'Salir',
          textColor: Colors.black,
          onPressed: () {
            // Some code to undo the change.
          },
        )));
  }

  void alertMensaje2(String texto) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(texto),
    ));
  }

  Widget institucionTotal() {
    final hola = Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(20.0),
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        Image.network(institucionList[0].logoInstitucion).image,
                    fit: BoxFit.cover),
                border: Border.all(color: Colors.black, width: 2.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 7.0))
                ],
                shape: BoxShape.rectangle)),
        Flexible(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              runSpacing: 3.0,
              children: <Widget>[
                Text("Nombre Institución: " +
                    institucionList[0].nombreInstitucion),
                Text("Descripcion Institución: " +
                    institucionList[0].descripcionInstitucion),
                Text("Ciudad Institución: " +
                    institucionList[0].ciudadInstitucion),
              ],
            ),
          ),
        )
      ],
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(child: hola),
          backgroundColor: Colors.white,
        ));
  }

  Widget pruebaFechas() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: contFecha == 1
            ? MyApp()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget mensajeTotalAlumno() {
    final cuadrado = Container(
        color: Color(0xFFE6E6E6),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: mensajeListAlumno.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (lista, position) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    vistoMensajeAlumno(mensajeListAlumno[position].idMensaje);
                    getMensajeAlumno();
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetalleMensaje(
                              mensajeListAlumno[position].idMensaje,
                              mensajeListAlumno[position].nombreMensaje,
                              mensajeListAlumno[position].descripcionMensaje,
                              mensajeListAlumno[position].fechaCreacionMensaje,
                              mensajeListAlumno[position].nombreProfesor,
                              mensajeListAlumno[position].fotoProfesor,
                              mensajeListAlumno[position].curso)));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4.0, //degradado
                            offset: Offset(2.0, 5.0) //posision de la sombra
                            )
                      ]),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(10.0),
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Image.network(
                                                mensajeListAlumno[position]
                                                    .fotoProfesor)
                                            .image,
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle)),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,
                                  runSpacing: 5.0,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Profesor: " +
                                            mensajeListAlumno[position]
                                                .nombreProfesor),
                                        Text("Fecha: " +
                                            mensajeListAlumno[position]
                                                .fechaCreacionMensaje),
                                        Text("Titulo: " +
                                            mensajeListAlumno[position]
                                                .nombreMensaje),
                                        Text("Curso: " +
                                            mensajeListAlumno[position].curso),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            mensajeListAlumno[position].visto == "Procesando"
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                  ),
                          ],
                        )),
                  ),
                ));
          },
        ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: cuadrado,
          backgroundColor: Colors.white,
        ));
  }

  Widget mensajeTotalApoderado() {
    final cuadrado = Container(
        color: Color(0xFFE6E6E6),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: mensajeListApoderado.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (lista, position) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    vistoMensajeApoderado(
                        mensajeListApoderado[position].idMensaje);
                    getMensajeApoderado();
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetalleMensaje(
                              mensajeListApoderado[position].idMensaje,
                              mensajeListApoderado[position].nombreMensaje,
                              mensajeListApoderado[position].descripcionMensaje,
                              mensajeListApoderado[position]
                                  .fechaCreacionMensaje,
                              mensajeListApoderado[position].nombreProfesor,
                              mensajeListApoderado[position].fotoProfesor,
                              mensajeListApoderado[position].curso)));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4.0, //degradado
                            offset: Offset(2.0, 5.0) //posision de la sombra
                            )
                      ]),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(10.0),
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Image.network(
                                                mensajeListApoderado[position]
                                                    .fotoProfesor)
                                            .image,
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle)),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,
                                  runSpacing: 5.0,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Profesor: " +
                                            mensajeListApoderado[position]
                                                .nombreProfesor),
                                        Text("Fecha: " +
                                            mensajeListApoderado[position]
                                                .fechaCreacionMensaje),
                                        Text("Titulo: " +
                                            mensajeListApoderado[position]
                                                .nombreMensaje),
                                        Text("Curso: " +
                                            mensajeListApoderado[position]
                                                .curso),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            mensajeListApoderado[position].visto == "Procesando"
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                  ),
                          ],
                        )),
                  ),
                ));
          },
        ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: cuadrado,
          backgroundColor: Colors.white,
        ));
  }

  Widget mensajeTotalProfesor() {
    final cuadrado = Container(
        color: Color(0xFFE6E6E6),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: mensajeListProfesor.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (lista, position) {
            return GestureDetector(
                onTap: () {
                  vistoMensajeAlumno(mensajeListProfesor[position].idMensaje);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetalleMensaje(
                              mensajeListProfesor[position].idMensaje,
                              mensajeListProfesor[position].nombreMensaje,
                              mensajeListProfesor[position].descripcionMensaje,
                              mensajeListProfesor[position]
                                  .fechaCreacionMensaje,
                              mensajeListProfesor[position].nombreProfesor,
                              mensajeListProfesor[position].fotoProfesor,
                              mensajeListProfesor[position].curso)));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4.0, //degradado
                            offset: Offset(2.0, 5.0) //posision de la sombra
                            )
                      ]),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(10.0),
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Image.network(
                                                mensajeListProfesor[position]
                                                    .fotoProfesor)
                                            .image,
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle)),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,
                                  runSpacing: 5.0,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Profesor: " +
                                              mensajeListProfesor[position]
                                                  .nombreProfesor,
                                        ),
                                        Text("Fecha: " +
                                            mensajeListProfesor[position]
                                                .fechaCreacionMensaje),
                                        Text("Titulo: " +
                                            mensajeListProfesor[position]
                                                .nombreMensaje),
                                        Text("Curso: " +
                                            mensajeListProfesor[position]
                                                .curso),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ));
          },
        ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: cuadrado,
          backgroundColor: Colors.white,
        ));
  }

  Widget _cursosAlumno() {
    List<DropdownMenuItem<String>> items = [];
    for (Curso cur in cursoList) {
      items.add(new DropdownMenuItem<String>(
        value: cur.idCurso.toString(),
        child: Text(cur.nombreCurso.toString()),
      ));
    }
    return Container(
        child: Column(
      children: <Widget>[
        DropdownButton(
          value: _value == null ? cursoList[0].idCurso.toString() : _value,
          items: items,
          onChanged: (opt) {
            setState(() {
              _value = opt;
              print("------------");
              print(_value);
              valorCurso = _value;
              materiasAlumno(_value);
              print("------------");
            });
          },
        ),
      ],
    ));
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccione Su Curso'),
          content: SingleChildScrollView(
              child: Center(
            child: _cursosAlumno(),
          )),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _crearDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (Curso cur in cursoList) {
      items.add(new DropdownMenuItem<String>(
        value: cur.idCurso.toString(),
        child: Text(cur.nombreCurso.toString()),
      ));
    }
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          "Seleccione Curso",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontFamily: "Lobster"),
        ),
        DropdownButton(
          value: _value == null ? cursoList[0].idCurso.toString() : _value,
          items: items,
          onChanged: (opt) {
            setState(() {
              _value = opt;
              print("------------");
              print(_value);
              print("------------");
              seleccion = "Curso";
              loadAlumnos(_value, seleccion);
              cargarAlumnos(_value);
            });
          },
        ),
      ],
    ));
  }

  Widget _crearDropdownBlanco() {
    List<DropdownMenuItem<String>> items = [];
    for (Curso cur in cursoList) {
      items.add(new DropdownMenuItem<String>(
        value: cur.idCurso.toString(),
        child: Text(cur.nombreCurso.toString()),
      ));
    }
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          "Seleccione Curso",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: "Lobster"),
        ),
        DropdownButton(
          value: _value,
          items: items,
          onChanged: (opt) {
            setState(() {
              print("jiji");
              _value = opt;
              seleccion = "Curso";
              loadAlumnos(_value, seleccion);
              cargarAlumnos(_value);
            });
          },
        ),
      ],
    ));
  }

  Widget _crearDropdownTaller() {
    List<DropdownMenuItem<String>> items = [];
    for (Taller ta in tallerList) {
      items.add(new DropdownMenuItem<String>(
        value: ta.idTaller.toString(),
        child: Text(ta.nombreTaller.toString()),
      ));
    }
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          "Seleccione Taller",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontFamily: "Lobster"),
        ),
        DropdownButton(
          value: _value2 == null ? tallerList[0].idTaller.toString() : _value2,
          items: items,
          onChanged: (opt) {
            setState(() {
              _value2 = opt;
              seleccion = "Taller";
              loadAlumnos(_value2, seleccion);
              // cargarAlumnos(_value2);
            });
          },
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context).orientation;
    var alto = MediaQuery.of(context).size.height;
    var ancho = MediaQuery.of(context).size.height;
    //mensajesSinLeerApoderado();
    //mensajesSinLeerAlumno();
    setState(() {
      if (contadorCursoAlumno == 0) {
        cursosAlumnos();
      }
      if (contadorAviso == 0) {
        mensajesSinLeerApoderado();
      }
      if (contadorAviso1 == 0) {
        mensajesSinLeerAlumno();
      }
    });

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('DraggableScrollableSheet'),
        ),
        body: SizedBox.expand(
          child: DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.blue[100],
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(title: Text('Item $index'));
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    Widget prueba2019() {
      return DraggableScrollableSheet(
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.blue[100],
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          );
        },
      );
    }

    Widget cuerpoMateriasAlumno() {
      final cuadrado = Container(
          color: Color(0xFFE6E6E6),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: listMateria.length,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (lista, position) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      print(listMateria[position].idMateria);
                      // valorMateria = listMateria[position].idMateria;

                      print("id materia = " + valorMateria);
                      print("id curso = " + valorCurso);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4.0, //degradado
                              offset: Offset(2.0, 5.0) //posision de la sombra
                              )
                        ]),
                    child: Card(
                      color: Colors.white,
                      child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 70.0,
                                  width: 70.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: Image.network(
                                                  listMateria[position]
                                                      .imagenMateria)
                                              .image,
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle)),
                              Flexible(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Materia: " +
                                            listMateria[position]
                                                .nombreMateria),
                                        FloatingActionButton(
                                          child: AnimatedIcon(
                                              icon: AnimatedIcons.menu_close,
                                              progress: _controller),
                                          elevation: 5,
                                          backgroundColor: Colors.deepOrange,
                                          foregroundColor: Colors.white,
                                          onPressed: () async {
                                            setState(() {
                                              valorMateria =
                                                  listMateria[position]
                                                      .idMateria;
                                              archivoMateria();
                                              if (_controller.isDismissed)
                                                _controller.forward();
                                              else if (_controller.isCompleted)
                                                _controller.reverse();
                                            });
                                          },
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          )),
                    ),
                  ));
            },
          ));

      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  cuadrado,
                  SizedBox.expand(
                    child: SlideTransition(
                      position: _tween.animate(_controller),
                      child: DraggableScrollableSheet(
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return Container(
                              color: Colors.blue[800],
                              child: contadorArchivo == 0 ?Center(child: Text("No tiene archivos subidos.",style: TextStyle(color: Colors.white),),) :ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: listArchivo.length,
                                padding: EdgeInsets.all(10.0),
                                itemBuilder: (lista, position) {
                                  return GestureDetector(
                                      child: Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 4.0, //degradado
                                              offset: Offset(2.0,
                                                  5.0) //posision de la sombra
                                              )
                                        ]),
                                    child: Card(
                                      color: Colors.white,
                                      child: Container(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                child: Container(
                                                  margin: EdgeInsets.all(5.0),
                                                  child: Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    direction: Axis.horizontal,
                                                    runSpacing: 5.0,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Nombre: " +
                                                                listArchivo[
                                                                        position]
                                                                    .nombreArchivo,
                                                          ),
                                                          Text("Descripcion: " +
                                                              listArchivo[
                                                                      position]
                                                                  .descripcionArchivo),
                                                          Text("Materia: " +
                                                              listArchivo[
                                                                      position]
                                                                  .nombreMateria),
                                                          Text("Profesor: " +
                                                              listArchivo[
                                                                      position]
                                                                  .nombreProfesor),
                                                          Icon(
                                                            Icons.file_download,
                                                            color: Colors.pink,
                                                            size: 24.0,
                                                            semanticLabel:
                                                                'Text to announce in accessibility modes',
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ));
                                },
                              ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
          ));
    }

    //
    Widget perfilProfesor() {
      return ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image(
                  image: Image.network(listPerfilProfesor[0].foto).image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(60.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 96.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      listPerfilProfesor[0].nombres +
                                          " " +
                                          listPerfilProfesor[0].apellidos,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        "Institución:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        listPerfilProfesor[0].nombreInstitucion,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Mensajes Enviados:",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          listPerfilProfesor[0].mensajes,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image:
                                      Image.network(listPerfilProfesor[0].foto)
                                          .image,
                                  fit: BoxFit.cover)),
                          margin: EdgeInsets.only(left: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Card(
                      elevation: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 1.0))
                            ]),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Información",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Rut",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilProfesor[0].rut,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.ac_unit,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Correo Electronico",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilProfesor[0].correo,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Telefono",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilProfesor[0].numero,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget perfilApoderado() {
      return ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image(
                  image:
                      Image.network(listPerfilApoderado[0].fotoApoderado).image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(60.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 96.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      listPerfilApoderado[0].nombresApoderado +
                                          " " +
                                          listPerfilApoderado[0]
                                              .apellidosApoderado,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        "Institución:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        listPerfilApoderado[0]
                                            .nombreInstitucion,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Mensajes Recibidos:",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          listPerfilApoderado[0].mensajes,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: Image.network(
                                          listPerfilApoderado[0].fotoApoderado)
                                      .image,
                                  fit: BoxFit.cover)),
                          margin: EdgeInsets.only(left: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Card(
                      elevation: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 1.0))
                            ]),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Información",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Rut",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilApoderado[0].rutApoderado,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.ac_unit,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Correo Electronico",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilApoderado[0].correoApoderado,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Telefono",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilApoderado[0].numeroApoderado,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Parentesco",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilApoderado[0].nombreParentesco,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.accessibility,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget perfilAlumno() {
      return ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image(
                  image: Image.network(listPerfilAlumno[0].fotoAlumno).image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(60.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 96.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      listPerfilAlumno[0].nombresAlumno +
                                          " " +
                                          listPerfilAlumno[0].apellidosAlumno,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        "Institución:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        listPerfilAlumno[0].nombreInstitucion,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Mensajes Recibidos:",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          listPerfilAlumno[0].mensajes,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: Image.network(
                                          listPerfilAlumno[0].fotoAlumno)
                                      .image,
                                  fit: BoxFit.cover)),
                          margin: EdgeInsets.only(left: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Card(
                      elevation: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0.0, 1.0))
                            ]),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Información",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Rut",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilAlumno[0].rutAlumno,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.ac_unit,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Correo Electronico",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilAlumno[0].correoAlumno,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Telefono",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilAlumno[0].numeroAlumno,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Nacionalidad",
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                listPerfilAlumno[0].nombreNacionalidad,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                Icons.accessibility,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget calendarizarFinal() {
      final txt1 = Container(
        margin: EdgeInsets.all(10),
        child: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: "Nombre Evento",
            icon: Icon(
              Icons.perm_identity,
              color: Colors.grey,
            ),
          ),
          style: TextStyle(fontFamily: 'Lobster', color: Colors.grey),
          onChanged: (value) {
            this.nombreEvento = value;
          },
        ),
      );

      final txt2 = Container(
          margin: EdgeInsets.all(10),
          child: TextField(
            maxLines: 3,
            style: TextStyle(fontFamily: 'Lobster', color: Colors.grey),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.assignment,
                  color: Colors.grey,
                ),
                hintText: "De que trata el evento a realizar?",
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                labelText: 'Descripcion'),
            onChanged: (value) {
              this.descripcionEvento = value;
            },
          ));

      final btn1 = Container(
          margin: EdgeInsets.all(10),
          child: RaisedButton.icon(
            color: Colors.grey,
            icon: Icon(Icons.calendar_today, color: Colors.white),
            label: Text(
              "Seleccionar Fecha",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _seleccionarFecha(context);
            },
          ));

      final btn2 = Container(
          margin: EdgeInsets.all(10),
          child: RaisedButton.icon(
            color: Colors.grey,
            icon: Icon(Icons.access_time, color: Colors.white),
            label: Text(
              "Seleccionar Hora",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _seleccionarHora(context);
            },
          ));

      final txt3 = Container(
          margin: EdgeInsets.all(10),
          child: Text(
            "Fecha seleccionada: ${_fecha.toString().substring(0, 11)} ${_hora.toString().substring(10, 15)}",
            style: TextStyle(fontFamily: 'Lobster', color: Colors.grey),
          ));

      final btn3 = Container(
          margin: EdgeInsets.all(10),
          child: RaisedButton.icon(
            color: Colors.orange,
            icon: Icon(Icons.check, color: Colors.white),
            label: Text(
              "Agregar Evento",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              agregarEvento();
            },
          ));

      return Container(
        margin: EdgeInsets.only(top: 30, bottom: 20, left: 15, right: 15),
        height: alto,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 4.0, //degradado
                  offset: Offset(10.0, 15.0) //posision de la sombra
                  )
            ]),
        child: deviceData.toString() == "Orientation.portrait"
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  txt1,
                  txt2,
                  btn1,
                  btn2,
                  txt3,
                  contador == 1
                      ? _crearDropdownBlanco()
                      : Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "No tiene cursos asociados. Consulte con el administrador dentro de su Institución",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                  btn3
                ],
              ))
            : ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  txt1,
                  txt2,
                  btn1,
                  btn2,
                  txt3,
                  contador == 1
                      ? _crearDropdownBlanco()
                      : Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "No tiene cursos asociados. Consulte con el administrador dentro de su Institución",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                  btn3
                ],
              ),
      );
    }

    final _tabMensajes = <Widget>[
      deviceData.toString() == "Orientation.portrait"
          ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: contador == 1
                        ? _crearDropdown()
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "No tiene cursos asociados. Consulte con el administrador dentro de su Institución",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                  ),
                  Container(padding: EdgeInsets.all(10.0), child: Text("Ó")),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: contadorT == 1
                        ? _crearDropdownTaller()
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "No tiene Talleres asociados. Consulte con el administrador dentro de su Institución",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                  ),
                ])
          : SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: contador == 1
                        ? _crearDropdown()
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "No tiene Cursos asociados. Consulte con el administrador dentro de su Institución",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                  ),
                  Container(padding: EdgeInsets.all(10.0), child: Text("Ó")),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: contadorT == 1
                        ? _crearDropdownTaller()
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "No tiene Talleres asociados. Consulte con el administrador dentro de su Institución",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                  )
                ])),
      deviceData.toString() == "Orientation.portrait"
          ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  Expanded(child: SizedBox(height: 200.0, child: listview)),
                ])
          : SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  listview,
                ])),
      SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 5.0,
            runSpacing: 5.0,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Asunto Mensaje",
                  icon: Icon(Icons.perm_identity),
                ),
                style: TextStyle(color: Colors.grey),
                onChanged: (value) {
                  this.nombreMensaje = value;
                },
              ),
              TextField(
                maxLines: 3,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    icon: Icon(Icons.assignment),
                    hintText: "Envie el mensaje que desee...",
                    border: OutlineInputBorder(),
                    labelText: 'Descripcion'),
                onChanged: (value) {
                  this.descripcionMensaje = value;
                },
              ),
              RaisedButton.icon(
                color: Colors.orange,
                icon: Icon(Icons.check, color: Colors.white),
                label: Text(
                  "Enviar Mensaje",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  enviarMensaje();
                },
              ),
              respuestaMensajes
            ],
          ),
        ),
      )
    ];

    final _tabs = <Widget>[
      Tab(
          icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  shape: BoxShape.circle),
              child: Text(
                "1",
                style: TextStyle(color: Colors.white),
              )),
          child: Flexible(
            child: Wrap(
              children: <Widget>[Text("Destinatario")],
            ),
          )),
      Tab(
          icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  shape: BoxShape.circle),
              child: Text(
                "2",
                style: TextStyle(color: Colors.white),
              )),
          child: Flexible(
            child: Wrap(
              children: <Widget>[Text("Alumnos")],
            ),
          )),
      Tab(
          icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  shape: BoxShape.circle),
              child: Text(
                "3",
                style: TextStyle(color: Colors.white),
              )),
          child: Flexible(
            child: Wrap(
              children: <Widget>[Text("Enviar")],
            ),
          )),
    ];

    final button = Container(
      width: double.infinity,
      color: Colors.blue,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 0),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Text('Cerrar'),
          textColor: Colors.blue,
          color: (Colors.white),
          onPressed: () {
            print('close sesion');
            _removeData();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login(1)));
          }),
    );

    final pruebamensaje2 = DefaultTabController(
      initialIndex: resp == 0 ? 0 : resp == 1 ? 2 : 0,
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          bottom: TabBar(
            indicatorColor: Color(0xff06ACC4),
            indicatorWeight: 5,
            tabs: _tabs,
          ),
        ),
        body: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                shape: BoxShape.rectangle,
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 4.0, //degradado
                      offset: Offset(10.0, 15.0) //posision de la sombra
                      )
                ]),
            child: TabBarView(
              children: _tabMensajes,
            )),
        backgroundColor: Color(0xFFE6E6E6),
      ),
    );

    final alumno = Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        drawer: new Drawer(
          child: Container(
            color: Colors.blue,
            child: new ListView(
              children: <Widget>[
                new Container(
                    color: Colors.blue,
                    height: 200.0,
                    child: new DrawerHeader(
                        child: new Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10.0),
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                image: DecorationImage(
                                    image: Image.network(data[3]).image,
                                    fit: BoxFit.cover),
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 15.0,
                                      offset: Offset(0.0, 7.0))
                                ],
                                shape: BoxShape.rectangle),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                spacing: 5.0,
                                runSpacing: 2.0,
                                children: <Widget>[
                                  Text(
                                    data[1],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    data[2],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
                new Container(
                  color: Colors.blue,
                  child: new Column(children: <Widget>[
                    new ListTile(
                        leading: new Icon(
                          Icons.class_,
                          color: Colors.white,
                        ),
                        title: Text("Mis Asignaturas",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            text = 1;
                            cursosAlumnos();
                            _neverSatisfied();
                          });
                        }),
                    new ListTile(
                        leading: new Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        title: Text("Ver Calendario",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            text = 2;
                          });
                        }),
                    new ListTile(
                      leading: new Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      title: Text("Ver Mensajes",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          getMensajeAlumno();
                          text = 10;
                        });
                      },
                      trailing: contadorAviso1 == 0
                          ? Text("")
                          : Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Text(
                                  contMsgAlumno,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                    ),
                    new ListTile(
                        leading: new Icon(
                          Icons.account_balance,
                          color: Colors.white,
                        ),
                        title: Text("Mi Institucion",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            getInstitucion();
                            text = 4;
                          });
                        }),
                    Divider(
                      height: 5.0,
                      color: Colors.white,
                    ),
                    new ListTile(
                        leading: new Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        title: Text("Ver Perfil",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            getPerfilAlumno();
                            text = 5;
                          });
                        }),
                    button,
                  ]),
                )
              ],
            ),
          ),
        ),
        appBar: new AppBar(
          backgroundColor: Colors.blue,
        ),
        body: text == 10
            ? prueba2 == 1
                ? mensajeTotalAlumno()
                : Center(
                    child: Text("Sin Mensajes"),
                  )
            : text == 2
                ? MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: SafeArea(
                      child: CalendarPage2(fechas),
                    ),
                  )
                : text == 5
                    ? contadorPerfilAlumno == 1
                        ? perfilAlumno()
                        : Text("Sin Perfil")
                    : text == 1
                        ? contadorMateriaAlumno == 1
                            ? cuerpoMateriasAlumno()
                            : CircularProgressIndicator()
                        : text == 4
                            ? pruebaInstitucion == 1
                                ? institucionTotal()
                                : Center(
                                    child: Text("Sin Institucion"),
                                  )
                            : Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/img/alumnos.png"),
                                        fit: BoxFit.contain)),
                              ));
    final profesor = Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      drawer: new Drawer(
        child: Container(
          color: Colors.blue,
          child: new ListView(
            children: <Widget>[
              new Container(
                  color: Colors.blue,
                  child: new DrawerHeader(
                      child: new Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: Image.network(data[3]).image,
                                  fit: BoxFit.cover),
                              border:
                                  Border.all(color: Colors.orange, width: 2.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 15.0,
                                    offset: Offset(0.0, 7.0))
                              ],
                              shape: BoxShape.rectangle),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(data[1],
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              Text(data[2],
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))),
              new Container(
                color: Colors.blue,
                child: new Column(children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.perm_contact_calendar,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Calendarizar Evento",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();

                        setState(() {
                          text = 1;
                          cursosProfesor();
                        });
                      }),
                  new ListTile(
                      leading: new Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Mensajes Enviados",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          getMensajeProfesor();
                          text = 15;
                        });
                      }),
                  new ListTile(
                      leading: new Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Enviar Mensaje",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          cursosProfesor();
                          talleresProfesor();
                          text = 8;
                        });
                      }),
                  new ListTile(
                      leading: new Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Ver Calendario",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          getFechas();
                          text = 5;
                          text2 = 2;
                        });
                      }),
                  Divider(
                    height: 5.0,
                    color: Colors.white,
                  ),
                  new ListTile(
                      leading: new Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Ver Perfil",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          getPerfilProfesor();
                          text = 6;
                          text2 = 2;
                          //cambio el text2 para que se pueda acceder a estas opciones
                        });
                      }),
                  button,
                ]),
              )
            ],
          ),
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.blue,
      ),
      body: text == 1
          ? calendarizarFinal()
          : text == 15
              ? prueba3 == 1
                  ? mensajeTotalProfesor()
                  : Center(
                      child: Text("Sin Mensajes"),
                    )
              : text2 == 8
                  ? pruebamensaje2
                  : text == 8
                      ? pruebamensaje2
                      : text == 4
                          ? calendarizarFinal()
                          : text == 5
                              ? contFecha == 1
                                  ? pruebaFechas()
                                  : CircularProgressIndicator()
                              : text == 6
                                  ? contadorPerfilProfesor == 1
                                      ? perfilProfesor()
                                      : Text("Cargando datos")
                                  : text == 7
                                      ? Text("Cuadro 7")
                                      : Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/img/profesor.png"),
                                                  fit: BoxFit.contain)),
                                        ),
      backgroundColor: Color(0xFFE6E6E6),
    );

    final apoderado = Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        drawer: new Drawer(
          child: Container(
            color: Colors.blue,
            child: new ListView(
              children: <Widget>[
                new Container(
                    color: Colors.blue,
                    height: 200.0,
                    child: new DrawerHeader(
                        child: new Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10.0),
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                image: DecorationImage(
                                    image: Image.network(data[3]).image,
                                    fit: BoxFit.cover),
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 15.0,
                                      offset: Offset(0.0, 7.0))
                                ],
                                shape: BoxShape.rectangle),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                spacing: 5.0,
                                runSpacing: 2.0,
                                children: <Widget>[
                                  Text(
                                    data[1],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    data[2],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))),
                new Container(
                  color: Colors.blue,
                  child: new Column(children: <Widget>[
                    new ListTile(
                      leading: new Icon(
                        Icons.class_,
                        color: Colors.white,
                      ),
                      title: Text("Ver Mensajes",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          getMensajeApoderado();
                          text = 1;
                        });
                      },
                      trailing: contadorAviso == 0
                          ? Text("")
                          : Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Text(
                                  contMsgApoderado,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                    ),
                    new ListTile(
                        leading: new Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        title: Text("Ver Calendario",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            text = 2;
                          });
                        }),
                    new ListTile(
                        leading: new Icon(
                          Icons.account_balance,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Mi Institución",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            getInstitucion();
                            text = 16;
                          });
                        }),
                    Divider(
                      height: 5.0,
                      color: Colors.white,
                    ),
                    new ListTile(
                        leading: new Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        title: Text("Ver Perfil",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            getPerfilApoderado();
                            text = 4;
                          });
                        }),
                    button,
                    Container(
                      color: Colors.blue,
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
        appBar: new AppBar(
          backgroundColor: Colors.blue,
        ),
        body: text == 16
            ? pruebaInstitucion == 1
                ? institucionTotal()
                : Center(
                    child: Text("Sin Institucion"),
                  )
            : text == 1
                ? prueba5 == 1
                    ? mensajeTotalApoderado()
                    : Center(
                        child: Text("Sin Mensajes"),
                      )
                : text == 2
                    ? MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: SafeArea(
                          child: CalendarPage2(fechas),
                        ),
                      )
                    : text == 4
                        ? contadorPerfilApoderado == 1
                            ? perfilApoderado()
                            : Text("Cargando Datos")
                        : Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/img/apoderados.png"),
                                    fit: BoxFit.contain)),
                          ));

    return data[5] == "1"
        ? (profesor)
        : data[5] == "2"
            ? (alumno)
            : data[5] == "3" ? (apoderado) : Text("Error");
  }
}
