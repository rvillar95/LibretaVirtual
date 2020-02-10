import 'dart:async';
import 'dart:io';

import 'package:demo_sesion/data/controladorAlumno.dart';
import 'package:demo_sesion/data/controladorApoderado.dart';
import 'package:demo_sesion/data/datos.dart';
import 'package:demo_sesion/login/login.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:demo_sesion/principal/Alumno/stream_alumno.dart';
import 'package:demo_sesion/principal/Apoderado/stream_apoderado.dart';
import 'package:demo_sesion/principal/calendario.dart';
import 'package:flutter/material.dart';
import 'package:wave_progress_widget/wave_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/principal/widgets/loader.dart';
import 'package:image_downloader/image_downloader.dart';
import '../detalle_mensaje.dart';
import 'package:flutter/services.dart';

class MenuApoderado extends StatefulWidget {
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MenuApoderado>
    with SingleTickerProviderStateMixin {
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

  List<String> data = [];
  List<Curso> listCursos = [];
  List<Materia> listMateria = [];
  List<Archivo> listArchivo = [];
  List<Fechas> fechas;
  int text = 0;
  String valorCurso = "";
  String valorMateria = "";
  String _value;
  final StreamApoderado demo = StreamApoderado();
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getFechas() async {
    ControladorApoderado servicio = ControladorApoderado();
    fechas = await servicio.getFechasApoderado(data[0]);
    await Future.delayed(Duration(seconds: 2));
    demo.resetCounter(2);
  }

  @override
  Widget build(BuildContext context) {
    //PASO EL ID ALTIRO AL CONTROLADOR
    demo.cambiarIdApoderado(data[0]);
    print("Archivo Apoderado");
    var alto = MediaQuery.of(context).size.height;

    Widget perfil() {
      return StreamBuilder(
        stream: demo.getPerfil,
        builder:
            (BuildContext context, AsyncSnapshot<List<Apoderado>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              List<Apoderado> apoderado = snapshot.data;
              return Container(
                  color: Color(0xFFE6E6E6),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: apoderado?.length ?? 0,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (lista, position) {
                      Apoderado _apoderado = apoderado[position];
                      print(_apoderado.rutApoderado);
                      return Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image(
                              image:
                                  Image.network(_apoderado.fotoApoderado).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      margin: EdgeInsets.only(top: 16.0),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(60.0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 96.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  _apoderado.nombresApoderado +
                                                      " " +
                                                      _apoderado
                                                          .apellidosApoderado,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  title: Text(
                                                    "Institución:",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  subtitle: Text(
                                                    _apoderado
                                                        .nombreInstitucion,
                                                    style: TextStyle(
                                                        color: Colors.white),
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
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      _apoderado.mensajes,
                                                      style: TextStyle(
                                                          color: Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                              image: Image.network(
                                                      _apoderado.fotoApoderado)
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Divider(),
                                        ListTile(
                                          title: Text(
                                            "Rut",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            _apoderado.rutApoderado,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          leading: Icon(
                                            Icons.ac_unit,
                                            color: Colors.white,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Correo Electronico",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            _apoderado.correoApoderado,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          leading: Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Telefono",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            _apoderado.numeroApoderado,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          leading: Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "Parentesco",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            _apoderado.nombreParentesco,
                                            style:
                                                TextStyle(color: Colors.white),
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
                      );
                    },
                  ));
          }
        },
      );
    }

    Widget mensajes() {
      return StreamBuilder(
        stream: demo.listViewMensajes,
        builder: (BuildContext context, AsyncSnapshot<List<Mensaje>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              List<Mensaje> mensajes = snapshot.data;
              return mensajes?.length == null
                  ? Center(
                      child: Text(
                      "No tiene mensajes.",
                      style: TextStyle(color: Colors.red),
                    ))
                  : Container(
                      color: Color(0xFFE6E6E6),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mensajes?.length ?? 0,
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (lista, position) {
                          Mensaje _mensaje = mensajes[position];
                          return GestureDetector(
                              onTap: () {
                                demo.vistoMensajeApoderado(_mensaje.idMensaje);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetalleMensaje(
                                            _mensaje.idMensaje,
                                            _mensaje.nombreMensaje,
                                            _mensaje.descripcionMensaje,
                                            _mensaje.fechaCreacionMensaje,
                                            _mensaje.nombreProfesor,
                                            _mensaje.fotoProfesor,
                                            _mensaje.curso)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 4.0, //degradado
                                          offset: Offset(
                                              2.0, 5.0) //posision de la sombra
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
                                          Container(
                                              margin: EdgeInsets.all(10.0),
                                              height: 70.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: Image.network(
                                                              _mensaje
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Profesor: " +
                                                          _mensaje
                                                              .nombreProfesor),
                                                      Text("Fecha: " +
                                                          _mensaje
                                                              .fechaCreacionMensaje),
                                                      Text("Titulo: " +
                                                          _mensaje
                                                              .nombreMensaje),
                                                      Text("Curso: " +
                                                          _mensaje.curso),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          _mensaje.visto == "Procesando"
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
          }
        },
      );
    }

    Widget mensajesSinVer() {
      return StreamBuilder(
        stream: demo.mensajesSinLeer,
        builder: (BuildContext context, AsyncSnapshot<List<Mensaje>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              List<Mensaje> mensajesSinLeer = snapshot.data;

              return mensajesSinLeer?.length == 0
                  ? Center(
                      child: Text(
                      "No tiene mensajes sin leer.",
                      style: TextStyle(color: Colors.red),
                    ))
                  : Container(
                      color: Color(0xFFE6E6E6),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: mensajesSinLeer?.length ?? 0,
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (lista, position) {
                          Mensaje _mensaje = mensajesSinLeer[position];
                          return GestureDetector(
                              onTap: () {
                                demo.vistoMensajeApoderado(_mensaje.idMensaje);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetalleMensaje(
                                            _mensaje.idMensaje,
                                            _mensaje.nombreMensaje,
                                            _mensaje.descripcionMensaje,
                                            _mensaje.fechaCreacionMensaje,
                                            _mensaje.nombreProfesor,
                                            _mensaje.fotoProfesor,
                                            _mensaje.curso)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 4.0, //degradado
                                          offset: Offset(
                                              2.0, 5.0) //posision de la sombra
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
                                          Container(
                                              margin: EdgeInsets.all(10.0),
                                              height: 70.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: Image.network(
                                                              _mensaje
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Profesor: " +
                                                          _mensaje
                                                              .nombreProfesor),
                                                      Text("Fecha: " +
                                                          _mensaje
                                                              .fechaCreacionMensaje),
                                                      Text("Titulo: " +
                                                          _mensaje
                                                              .nombreMensaje),
                                                      Text("Curso: " +
                                                          _mensaje.curso),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          _mensaje.visto == "Procesando"
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
          }
        },
      );
    }

    Widget pregunta() {
      final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);
      final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
      return SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: 370,
            child: Dialog(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Gracias por consultar!",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(
                          "En este modal te enseñaremos mas de nuestra aplicación.",
                          style: label,
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Chip(
                              label: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              backgroundColor: Colors.green,
                            ),
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
                                            "Aqui podras ver los eventos que tengas durante esta semana!")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Chip(
                              label: Icon(
                                Icons.announcement,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              backgroundColor: Colors.red,
                            ),
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
                                            "Aqui podras ver el numero de mensajes sin leer, haz click y leelos!")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        FlatButton(
                          child: Text(
                            'Cerrar',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      );
    }

    _dialogConsulta(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return pregunta();
          });
    }

    Widget institucion() {
      return StreamBuilder(
        stream: demo.getInstitucion,
        builder:
            (BuildContext context, AsyncSnapshot<List<Institucion>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              List<Institucion> institucion = snapshot.data;

              return Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(20.0),
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  Image.network(institucion[0].logoInstitucion)
                                      .image,
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
                              institucion[0].nombreInstitucion),
                          Text("Descripcion Institución: " +
                              institucion[0].descripcionInstitucion),
                          Text("Ciudad Institución: " +
                              institucion[0].ciudadInstitucion),
                        ],
                      ),
                    ),
                  )
                ],
              );
          }
        },
      );
    }

    return Scaffold(
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

                          demo.resetCounter(1);
                          //    cursosAlumnos();
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

                          getFechas();
                          demo.resetCounter(10);
                        }),
                    new ListTile(
                      leading: new Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      title: Text("Mi Institución",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).pop();

                        demo.resetCounter(3);
                      },
                    ),
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
                          demo.resetCounter(4);
                        }),
                    Container(
                      width: double.infinity,
                      color: Colors.blue,
                      margin: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 0),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text('Cerrar'),
                          textColor: Colors.blue,
                          color: (Colors.white),
                          onPressed: () {
                            print('close sesion');
                            demo.resetCounter(69);
                            _removeData();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login(1)));
                          }),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
        appBar: new AppBar(
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: StreamBuilder<Object>(
                stream: demo.contadorSinVer,
                initialData: 0,
                builder: (context, snapshot) {
                  return GestureDetector(
                      child: Chip(
                        label: Icon(
                          Icons.announcement,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        backgroundColor: Colors.red,
                      ),
                      onTap: () {
                        demo.resetCounter(5);
                      });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.white,
              child: GestureDetector(
                  child: Icon(
                    Icons.help_outline,
                    color: Colors.black,
                  ),
                  onTap: () {
                    _dialogConsulta(context);
                  }),
            )
          ],
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<int>(
          stream: demo.streamCounter,
          initialData: 0,
          builder: (context, snapshot) {
            return snapshot.data == 1
                ? mensajes()
                : snapshot.data == 3
                    ? institucion()
                    : snapshot.data == 5
                        ? mensajesSinVer()
                        : snapshot.data == 4
                            ? perfil()
                            : snapshot.data == 2
                                ? MaterialApp(
                                    debugShowCheckedModeBanner: false,
                                    home: SafeArea(
                                      child: CalendarPage2(fechas),
                                    ),
                                  )
                                : snapshot.data == 10 ?Center(child: LoaderOne(),) : Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/apoderados.png"),
                                            fit: BoxFit.contain)),
                                  );
          },
        ));
  }
}
