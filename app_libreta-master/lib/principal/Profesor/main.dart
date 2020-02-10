import 'dart:async';

import 'package:demo_sesion/data/controladorProfesor.dart';
import 'package:demo_sesion/data/datos.dart';
import 'package:demo_sesion/login/login.dart';
import 'package:demo_sesion/model/alumnoSel.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:demo_sesion/model/archivo.dart';
import 'package:demo_sesion/model/fechas.dart';

import 'package:demo_sesion/model/materia.dart';
import 'package:demo_sesion/model/mensaje.dart';
import 'package:demo_sesion/model/profesor.dart';
import 'package:http/http.dart' as http;
import 'package:demo_sesion/principal/Profesor/stream_profesor.dart';
import 'package:demo_sesion/principal/calendario.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_sesion/model/curso.dart';
import 'package:demo_sesion/principal/widgets/loader.dart';
import '../data_table.dart';
import '../detalle_mensaje.dart';

class MenuProfesor extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libreta Virtual',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class IntroItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bg;
  final String imageUrl;
  final Widget wid1;

  const IntroItem(
      {Key key,
      @required this.title,
      this.subtitle,
      this.bg,
      this.imageUrl,
      this.wid1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg ?? Theme.of(context).primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                    color: Colors.white),
              ),
              if (subtitle != null) ...[
                
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
              ],
              Container(
                child: Center(
                  child: wid1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String descripcionEvento;

  Widget listview = Text("");
  String nombreEvento;
  SwiperController _controller = SwiperController();
  int _currentIndex = 0;
  List<Widget> widgetCurso2 = [];
  DateTime _fecha = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();
  String alumnosFinales = "";

  var contador;
  final List<Widget> widgetCurso = [];

  final List<String> titles = [
    "Seleccione el Curso",
    "Seleccione Destinatarios",
    "Desarrolle el Mensaje",
  ];
  final List<String> subtitles = [
    "Seleccione el curso al cual quiere enviar el mensaje.",
    "Seleccione el o los alumnos quienes recibiran el mensaje.",
    "Complete de manera correcta el asunto y la descripción del mensaje."
  ];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
  ];

  final List<String> titles2 = [
    "Seleccione el Taller",
    "Seleccione Destinatarios",
    "Desarrolle el Mensaje",
  ];
  final List<String> subtitles2 = [
    "Seleccione el taller al cual quiere enviar el mensaje.",
    "Seleccione el o los alumnos quienes recibiran el mensaje.",
    "Complete de manera correcta el asunto y la descripción del mensaje."
  ];

  final List<Color> colors2 = [
    Colors.blue.shade300,
    Colors.indigo.shade300,
    Colors.green.shade300,
  ];

  List<Curso> cursoList;

  String nombreMensaje;

  String descripcionMensaje;

  var respuestaMensajes;
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
  List<AlumnoSel> alumnos = [];
  List<AlumnoSel> selectedUsers;
  String alumnosSeleccionados;
  bool sort;
  int cont = 0;
  List<AlumnoSel> users;
  int text = 0;
  String valorCurso = "";
  String valorMateria = "";
  String _value = "1";
  final StreamProfesor demo = StreamProfesor();
  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getFechas() async {
    ControladorProfesor servicio = ControladorProfesor();
    fechas = await servicio.getFechasProfesor(data[0]);
    await Future.delayed(Duration(seconds: 2));
    demo.resetCounter(4);
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.idAlumno.compareTo(b.idAlumno));
      } else {
        users.sort((a, b) => b.idAlumno.compareTo(a.idAlumno));
      }
    }
  }

  onSelectedRow(bool selected, AlumnoSel user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  selected() async {
    if (selectedUsers.length == 0) {
      print("malo");
    } else {
      // demo.cargarAlumnos(selectedUsers);
      // demo.pruebaAlumno(selectedUsers);
      // demo.mostrarPrueba();
      String alumnos = "";
      for (var i = 0; i < selectedUsers.length; i++) {
        alumnos = selectedUsers[i].idAlumno + ",${alumnos}";
      }
      alumnosSeleccionados = alumnos;
    }
  }

  Future<List<AlumnoSel>> listaAlumnosSeleccionados() async {
    return selectedUsers;
  }

  void alertMensaje2() {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text("Seleccione Alumnos"),
        action: SnackBarAction(
          label: 'Salir',
          textColor: Colors.black,
          onPressed: () {
            // Some code to undo the change.
          },
        )));
  }

  enviarMensaje() async {
    String fechaMensaje = DateTime.now().toString().substring(0, 11) +
        " " +
        TimeOfDay.now().toString().substring(10, 15);
    Servicio servicio = Servicio();
    print(nombreMensaje);
    print(descripcionMensaje);
    print(fechaMensaje);
    print(_value);
    print(alumnosSeleccionados);
    print(data[0]);

    String resultado = await servicio.enviarMensajeCurso(
        nombreMensaje,
        descripcionMensaje,
        fechaMensaje,
        _value,
        alumnosSeleccionados,
        data[0]);
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
              color: Colors.green, fontSize: 25.0, fontWeight: FontWeight.bold),
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

  SingleChildScrollView dataBody() {
    print("PASO POR AQUI");
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        columns: [
          DataColumn(
            label: Text("Nombre del Alumno"),
            numeric: false,
            tooltip: "Nombre del alumno",
          ),
          DataColumn(
              label: Text(""),
              numeric: false,
              tooltip: "Id del alumno",
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                onSortColum(columnIndex, ascending);
              }),
        ],
        rows: users
            .map(
              (user) => DataRow(
                  selected: selectedUsers.contains(user),
                  onSelectChanged: (b) {
                    print("Onselect");
                    onSelectedRow(b, user);
                  },
                  cells: [
                    DataCell(
                      Text(user.nombreAlumno),
                    ),
                    DataCell(
                      Text(
                        user.idAlumno,
                        style: TextStyle(color: Colors.transparent),
                      ),
                      onTap: () {
                        print('Selected ${user.idAlumno}');
                      },
                    ),
                  ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //PASO EL ID ALTIRO AL CONTROLADOR
    demo.cambiarIdProfesor(data[0]);
    var deviceData = MediaQuery.of(context).orientation;
    print("Archivo Profesor");
    var alto = MediaQuery.of(context).size.height;

    Widget finalDataTable() {
      return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: dataBody(),
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: OutlineButton(
                        child: Text('Seleccionados ${selectedUsers.length}'),
                        onPressed: () {
                          listaAlumnosSeleccionados();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: OutlineButton(
                        child: Text('Seleccionar Alumnos'),
                        onPressed: selectedUsers.isEmpty
                            ? alertMensaje2
                            : () {
                                selected();
                              },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      );
    }

    void loadAlumnos(id) {
      print("xxxxxxxxxxxxxxxxxxx");
      print(id);
      print("xxxxxxxxxxxxxxxxxxx");
      Servicio servicio = Servicio();
      setState(() {
        listview = Center(child: LoaderOne());
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
              cont = 2;
              users = alumnos;
            }
          });
        });
      });
    }

    Widget estructuraMensaje() {
      return SingleChildScrollView(
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
      );
    }

    Widget cursosMensaje() {
      List<DropdownMenuItem<String>> items = [];
      for (Curso cur in cursoList) {
        items.add(new DropdownMenuItem<String>(
          value: cur.idCurso.toString(),
          child: Text(cur.nombreCurso.toString() ,style: TextStyle(color: Colors.blue,backgroundColor: Colors.black),),
        ));
      }
      return Container(
          child: Column(
        children: <Widget>[
          DropdownButton(
            value: _value,
            items: items,
            onChanged: (opt) {
              setState(() {
                print("jiji");
                _value = opt;
                loadAlumnos(opt);
                selectedUsers = [];
                cont = 1;
              });
            },
          ),
        ],
      ));
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

    Widget alumnosPrueba() {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Asunto Mensaje",
                    focusColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelStyle: TextStyle(
                        color: Colors.white, decorationColor: Colors.red),
                    icon: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    this.nombreMensaje = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      hintText: "Envie el mensaje que desee...",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Descripcion'),
                  onChanged: (value) {
                    this.descripcionMensaje = value;
                  },
                ),
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
            ],
          ),
        ),
      );
    }

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
              });
            },
          ),
        ],
      ));
    }

    Widget cuerpoMensajeCurso() {
      return Stack(
        children: <Widget>[
          Swiper(
            loop: false,
            index: _currentIndex,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            controller: _controller,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: Colors.red,
                activeSize: 20.0,
              ),
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return IntroItem(
                title: titles[index],
                subtitle: subtitles[index],
                bg: colors[index],
                wid1: index == 0
                    ? Center(child:cursosMensaje())
                    : index == 1
                        ? cont == 0
                            ? listview
                            : cont == 1 ? LoaderOne() : finalDataTable()
                        : alumnosPrueba(),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_currentIndex != 0) _controller.previous();

                if (_currentIndex == 0) demo.resetCounter(2);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon:
                  Icon(_currentIndex == 2 ? Icons.check : Icons.arrow_forward),
              onPressed: () {
                if (_currentIndex != 2)
                  _controller.next();
                else
                  _controller.move(0);
              },
            ),
          )
        ],
      );
    }

    Widget cuerpoMensajeTaller() {
      return Stack(
        children: <Widget>[
          Swiper(
            loop: false,
            index: _currentIndex,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            controller: _controller,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: Colors.red,
                activeSize: 20.0,
              ),
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return IntroItem(
                title: titles2[index],
                subtitle: subtitles2[index],
                bg: colors2[index],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_currentIndex != 0) _controller.previous();

                if (_currentIndex == 0) demo.resetCounter(2);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon:
                  Icon(_currentIndex == 2 ? Icons.check : Icons.arrow_forward),
              onPressed: () {
                if (_currentIndex != 2)
                  _controller.next();
                else
                  _controller.move(0);
              },
            ),
          )
        ],
      );
    }

    Widget perfil() {
      return StreamBuilder(
        stream: demo.getPerfil,
        builder:
            (BuildContext context, AsyncSnapshot<List<Profesor>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: LoaderOne());
            case ConnectionState.done:
              List<Profesor> profesor = snapshot.data;
              return Container(
                  color: Color(0xFFE6E6E6),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: profesor?.length ?? 0,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (lista, position) {
                      Profesor _profesor = profesor[position];
                      print(_profesor.rut);
                      return Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image(
                              image: Image.network(_profesor.foto).image,
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
                                                  _profesor.nombres +
                                                      " " +
                                                      _profesor.apellidos,
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
                                                    _profesor.nombreInstitucion,
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
                                                      "Mensajes Enviados:",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      _profesor.mensajes,
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
                                              image:
                                                  Image.network(_profesor.foto)
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
                                            _profesor.rut,
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
                                            _profesor.correo,
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
                                            _profesor.numero,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          leading: Icon(
                                            Icons.phone,
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

    Widget _cursosProfesor() {
      return StreamBuilder(
        stream: demo.getCursosProfesor,
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
                            print("-----------");
                            print(demo.streamCurso);
                            print("-----------");
                          },
                        ),
                ],
              ));
          }
        },
      );
    }

    Widget alertMensaje(String hola) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Context from Builder'),
        duration: Duration(seconds: 3),
      ));
    }

    void cursosProfesor() async {
      Servicio servicio = Servicio();
      cursoList = await servicio.getCursoProfesor(data[0]);

      print(cursoList.length);
      await Future.delayed(Duration(seconds: 2));
      demo.resetCounter(11);
      if (cursoList.length > 0) {
        print("+++++++++++++");
        contador = 1;
        setState(() {
          if (contador == 1) {
            _crearDropdownBlanco();
          } else {
            print("Error");
          }
        });
      } else {
        contador = 0;
      }
    }

    Future agregarEvento() async {
      String fecha = _fecha.toString().substring(0, 11);
      String hora = _hora.toString().substring(10, 15);
      String fechaTotal = fecha + hora;
      if (nombreEvento != null &&
          descripcionEvento != null &&
          fechaTotal != null &&
          _value != null &&
          data[0] != null) {
        var response =
            await http.post("https://libretavirtual.cl/addEvento", body: {
          'nombreEvento': nombreEvento,
          'descripcionEvento': descripcionEvento,
          'fechaEvento': fechaTotal,
          'idCurso': _value,
          'idProfesor': data[0]
        });

        return response.body;
      } else {
        return "malazo";
      }
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
          child: Builder(
            builder: (context) => RaisedButton.icon(
                color: Colors.blue,
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  'Agregar Evento',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  void hola() async {
                    String resultado = await agregarEvento();
                    print(resultado);
                    if (resultado == "ok") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Evento Agregado',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                        action: SnackBarAction(
                          label: 'Salir',
                          textColor: Colors.black,
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    } else if (resultado == "error") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Error al Agregar Evento.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                        action: SnackBarAction(
                          label: 'Salir',
                          textColor: Colors.black,
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    } else if (resultado == "vacio") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Faltan Datos.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                        action: SnackBarAction(
                          label: 'Salir',
                          textColor: Colors.black,
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    } else if (resultado == "malazo") {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Faltan Datos.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                        action: SnackBarAction(
                          label: 'Salir',
                          textColor: Colors.black,
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  }

                  hola();
                }),
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

    Widget elegirDestinatario() {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                  height: alto / 2.4,
                  width: double.infinity,
                  color: Colors.green.shade300,
                  child: GestureDetector(
                    onTap: () {
                      cursosProfesor();
                      demo.resetCounter(10);
                    },
                    child: Center(
                      child: Text(
                        "Curso",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                    ),
                  )),
              Container(
                height: alto / 2,
                width: double.infinity,
                color: Colors.blue.shade300,
                child: GestureDetector(
                  onTap: () {
                    demo.resetCounter(12);
                  },
                  child: Center(
                    child: Text(
                      "Taller",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        key: _scaffoldKey,
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
                          Icons.perm_contact_calendar,
                          color: Colors.white,
                        ),
                        title: Text("Calendarizar Evento",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          cursosProfesor();
                          demo.resetCounter(1);

                          //    cursosAlumnos();
                        }),
                    new ListTile(
                        leading: new Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        title: Text("Enviar Mensaje",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          demo.resetCounter(2);
                        }),
                    new ListTile(
                      leading: new Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      title: Text("Mensajes Enviados",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).pop();

                        demo.resetCounter(3);
                      },
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
                        getFechas();
                        demo.resetCounter(10);
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
                          demo.resetCounter(5);
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
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<int>(
          stream: demo.streamCounter,
          initialData: 0,
          builder: (context, snapshot) {
            return snapshot.data == 1
                ? calendarizarFinal()
                : snapshot.data == 2
                    ? elegirDestinatario()
                    : snapshot.data == 11
                        ? cuerpoMensajeCurso()
                        : snapshot.data == 12
                            ? cuerpoMensajeTaller()
                            : snapshot.data == 3
                                ? mensajes()
                                : snapshot.data == 5
                                    ? perfil()
                                    : snapshot.data == 4
                                        ? MaterialApp(
                                            debugShowCheckedModeBanner: false,
                                            home: SafeArea(
                                              child: CalendarPage2(fechas),
                                            ),
                                          )
                                        : snapshot.data == 10
                                            ? Center(
                                                child: LoaderOne(),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/img/profesor.png"),
                                                        fit: BoxFit.contain)),
                                              );
          },
        ));
  }
}
