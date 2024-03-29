import 'dart:async';
import 'dart:io';

import 'package:demo_sesion/data/controladorAlumno.dart';
import 'package:demo_sesion/data/datos.dart';
import 'package:demo_sesion/login/login.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/fechas.dart';
import 'package:demo_sesion/model/institucion.dart';
import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:demo_sesion/principal/Alumno/stream_alumno.dart';
import 'package:demo_sesion/principal/calendario.dart';
import 'package:flutter/material.dart';
import 'package:wave_progress_widget/wave_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/principal/widgets/loader.dart';
import 'package:image_downloader/image_downloader.dart';
import '../detalle_mensaje.dart';
import 'package:flutter/services.dart';
import 'package:demo_sesion/principal/widgets/calendario.dart';

class MenuAlumno extends StatefulWidget {
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MenuAlumno>
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

  String _message = "";
  String _path = "";
  String _size = "";
  String _mimeType = "";
  File _imageFile;
  int _progress = 0;

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);

  List<String> data = [];
  List<Curso> listCursos = [];
  List<Materia> listMateria = [];
  List<Archivo> listArchivo = [];
  List<Fechas> fechas = [];
  int text = 0;
  String valorCurso = "";
  String valorMateria = "";
  String _value;
  final StreamAlumno demo = StreamAlumno();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _loadData();

    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      _progress = progress;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getFechas() async {
    ControladorAlumno servicio = ControladorAlumno();
    fechas = await servicio.getFechasAlumno(data[0]);
    await Future.delayed(Duration(seconds: 2));
    demo.resetCounter(99);
  }

  @override
  Widget build(BuildContext context) {
    //PASO EL ID ALTIRO AL CONTROLADOR
    demo.cambiarIdAlumno(data[0]);
    print("Archivo alumno");
    var alto = MediaQuery.of(context).size.height;

    Future<void> _downloadImage(String url,
        {AndroidDestinationType destination, bool whenError = false}) async {
      String fileName;
      String path;
      int size;
      String mimeType;
      try {
        String imageId;

        if (whenError) {
          imageId =
              await ImageDownloader.downloadImage(url).catchError((error) {
            if (error is PlatformException) {
              var path = "";
              if (error.code == "404") {
                print("Not Found Error.");
              } else if (error.code == "unsupported_file") {
                print("UnSupported FIle Error.");
                path = error.details["unsupported_file_path"];
              }

              _message = error.toString();
              _path = path;
            }

            print(error);
          }).timeout(Duration(seconds: 10), onTimeout: () {
            print("timeout");
          });
        } else {
          if (destination == null) {
            imageId = await ImageDownloader.downloadImage(url);
          } else {
            imageId = await ImageDownloader.downloadImage(
              url,
              destination: destination,
            );
          }
        }

        if (imageId == null) {
          return;
        }
        fileName = await ImageDownloader.findName(imageId);
        path = await ImageDownloader.findPath(imageId);
        size = await ImageDownloader.findByteSize(imageId);
        mimeType = await ImageDownloader.findMimeType(imageId);
      } on PlatformException catch (error) {
        _message = error.message;

        return;
      }

      if (!mounted) return;

      var location = Platform.isAndroid ? "Directory" : "Photo Library";
      _message = 'Saved as "$fileName" in $location.\n';
      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';
      _path = path;

      if (!_mimeType.contains("video")) {
        _imageFile = File(path);
      }
    }

    Widget archivosAlumnos() {
      return SingleChildScrollView(
        child: Container(
          height: alto * .90,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Container(
                    child: StreamBuilder(
                  stream: demo.getArchivos,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Archivo>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Center(child: LoaderOne());
                      case ConnectionState.done:
                        List<Archivo> archivo = snapshot.data;
                        return archivo?.length == 0 || archivo?.length == null
                            ? Center(
                                child: Text(
                                "No tiene archivos para descargar en esta materia.",
                                style: TextStyle(color: Colors.black),
                              ))
                            : Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: archivo?.length ?? 0,
                                  padding: EdgeInsets.all(10.0),
                                  itemBuilder: (lista, position) {
                                    Archivo _archivo = archivo[position];
                                    return GestureDetector(
                                        child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          shape: BoxShape.rectangle,
                                          color: Colors.blue,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      direction:
                                                          Axis.horizontal,
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
                                                                  _archivo
                                                                      .nombreArchivo,
                                                            ),
                                                            Text("Descripcion: " +
                                                                _archivo
                                                                    .descripcionArchivo),
                                                            Text("Materia: " +
                                                                _archivo
                                                                    .nombreMateria),
                                                            Text("Profesor: " +
                                                                _archivo
                                                                    .nombreProfesor),
                                                            RaisedButton.icon(
                                                              icon: Icon(
                                                                Icons
                                                                    .file_download,
                                                                color: Colors
                                                                    .white,
                                                                size: 30.0,
                                                              ),
                                                              label: Text(
                                                                  "Descargar"),
                                                              onPressed: () {
                                                                _downloadImage(
                                                                  "https://libretavirtual.cl/" +
                                                                      _archivo
                                                                          .rutaArchivo,
                                                                  destination: AndroidDestinationType
                                                                      .directoryPictures
                                                                    ..inExternalFilesDir()
                                                                    ..subDirectory(
                                                                        _archivo
                                                                            .nombreArchivo),
                                                                );
                                                              },
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
                    }
                  },
                )),
              )
            ],
          ),
        ),
      );
    }

    Widget eventosSemanaAlumno() {
      return SingleChildScrollView(
        child: Container(
          height: alto * .90,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: Container(
                    child: StreamBuilder(
                  stream: demo.getEventosSemanaAlumno,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Fechas>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Center(child: LoaderOne());
                      case ConnectionState.done:
                        List<Fechas> fechas = snapshot.data;
                        return fechas?.length == 0
                            ? Center(
                                child: Text(
                                "No tiene eventos durante esta semana.",
                                style: TextStyle(color: Colors.red),
                              ))
                            : Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: fechas?.length ?? 0,
                                  padding: EdgeInsets.all(10.0),
                                  itemBuilder: (lista, position) {
                                    Fechas _fechas = fechas[position];
                                    return GestureDetector(
                                        child: Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          shape: BoxShape.rectangle,
                                          color: Colors.blue,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      direction:
                                                          Axis.horizontal,
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
                                                              "Nombre: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(_fechas
                                                                .nombreEvento),
                                                            Text(
                                                              "Profesor: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(_fechas
                                                                .nombreProfesor),
                                                            Text(
                                                              "Fecha: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(_fechas
                                                                .fechaEvento),
                                                            Text(
                                                              "Descripcion: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(_fechas
                                                                .descripcionEvento)
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
                    }
                  },
                )),
              )
            ],
          ),
        ),
      );
    }

    Widget perfil() {
      return StreamBuilder(
        stream: demo.getPerfil,
        builder: (BuildContext context, AsyncSnapshot<List<Alumno>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              List<Alumno> alumno = snapshot.data;
              return Container(
                  color: Color(0xFFE6E6E6),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: alumno?.length ?? 0,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (lista, position) {
                      Alumno _alumno = alumno[position];
                      print(_alumno.rutAlumno);
                      return Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image(
                              image: Image.network(_alumno.fotoAlumno).image,
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
                                                  _alumno.nombresAlumno +
                                                      " " +
                                                      _alumno.apellidosAlumno,
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
                                                    _alumno.nombreInstitucion,
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
                                                      _alumno.mensajes,
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
                                                      _alumno.fotoAlumno)
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
                                            _alumno.rutAlumno,
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
                                            _alumno.correoAlumno,
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
                                            _alumno.numeroAlumno,
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
                                            "Nacionalidad",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            _alumno.nombreNacionalidad,
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
                                demo.vistoMensajeAlumno(_mensaje.idMensaje);

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

    Widget cuerpoMateriasAlumno() {
      return SingleChildScrollView(
        child: Container(
          height: alto * .90,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  child: StreamBuilder(
                    stream: demo.getMateriasAlumno,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Materia>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return Center(child: LoaderOne());
                        case ConnectionState.done:
                          List<Materia> materia = snapshot.data;
                          return materia?.length == 0
                              ? Center(
                                  child: Text(
                                  "No tiene materias asociadas a este curso.",
                                  style: TextStyle(color: Colors.red),
                                ))
                              : Container(
                                  color: Color(0xFFE6E6E6),
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: materia?.length ?? 0,
                                    padding: EdgeInsets.all(10.0),
                                    itemBuilder: (lista, position) {
                                      Materia materias = materia[position];
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                      height: 70.0,
                                                      width: 70.0,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: Image.network(
                                                                      materias
                                                                          .imagenMateria)
                                                                  .image,
                                                              fit:
                                                                  BoxFit.cover),
                                                          shape:
                                                              BoxShape.circle)),
                                                  Flexible(
                                                    child: Container(
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text("Materia: " +
                                                                materias
                                                                    .nombreMateria),
                                                            FloatingActionButton(
                                                              child: AnimatedIcon(
                                                                  icon: AnimatedIcons
                                                                      .menu_close,
                                                                  progress:
                                                                      _controller),
                                                              elevation: 5,
                                                              backgroundColor:
                                                                  Colors
                                                                      .deepOrange,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              onPressed:
                                                                  () async {
                                                                //GUARDO VAIRABLE DE LA MATERIA
                                                                demo.guardarMateria(
                                                                    materias
                                                                        .idMateria);
                                                                print("curso: " +
                                                                    demo.curso);
                                                                print("materia: " +
                                                                    demo.materia);
                                                                demo.contadorArchivo(
                                                                    1);
                                                                demo.resetCounter(
                                                                    13);
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
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
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
                                demo.vistoMensajeAlumno(_mensaje.idMensaje);
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

    Widget _cursosAlumno() {
      return StreamBuilder(
        stream: demo.getCursosAlumnos,
        builder: (BuildContext context, AsyncSnapshot<List<Curso>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              listCursos = snapshot.data;

              List<DropdownMenuItem<String>> items = [];
              for (Curso cur in listCursos) {
                items.add(new DropdownMenuItem<String>(
                  value: cur.idCurso.toString(),
                  child: Text(cur.nombreCurso.toString()),
                ));
              }
              return Container(
                  child: Column(
                children: <Widget>[
                  listCursos.length == 0
                      ? Center(
                          child: Text(
                          "No tiene cursos registrados, comuniquese con el administrador.",
                          style: TextStyle(color: Colors.red),
                        ))
                      : DropdownButton(
                          value: _value == null
                              ? listCursos[0].idCurso.toString()
                              : _value,
                          items: items,
                          onChanged: (opt) {
                            demo.guardarCurso(opt);
                            demo.resetCounter(6);
                          },
                        ),
                ],
              ));
          }
        },
      );
    }

    Future<void> _modalCursos() async {
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
                        title: Text("Mis Asignaturas",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          _modalCursos();
                          demo.resetCounter(3);
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
                          demo.resetCounter(55);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CalendarScreen()));
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
                        demo.resetCounter(1);
                      },
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
                          demo.resetCounter(4);
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

                          //      getPerfilAlumno();
                          demo.resetCounter(7);
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
                stream: demo.contadorFechasSemana,
                initialData: 0,
                builder: (context, snapshot) {
                  return GestureDetector(
                    child: Chip(
                      label: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onTap: () {
                      demo.resetCounter(66);
                    },
                  );
                },
              ),
            ),
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
                : snapshot.data == 4
                    ? institucion()
                    : snapshot.data == 5
                        ? mensajesSinVer()
                        : snapshot.data == 7
                            ? perfil()
                            : snapshot.data == 3
                                ? Center(
                                    child: WaveProgress(100.0, Colors.blue,
                                        Colors.blueAccent, 50.0))
                                : snapshot.data == 6
                                    ? cuerpoMateriasAlumno()
                                    : snapshot.data == 66
                                        ? eventosSemanaAlumno()
                                        : snapshot.data == 13
                                            ? archivosAlumnos()
                                            : snapshot.data == 99
                                                ? MaterialApp(
                                                    debugShowCheckedModeBanner:
                                                        false,
                                                    home: SafeArea(
                                                      child:
                                                          CalendarPage2(fechas),
                                                    ),
                                                  )
                                                : snapshot.data == 55
                                                    ? Center(child: LoaderOne())
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/img/alumnos.png"),
                                                                fit: BoxFit
                                                                    .contain)),
                                                      );
          },
        ));
  }
}
