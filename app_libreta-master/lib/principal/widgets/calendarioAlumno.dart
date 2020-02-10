import 'package:demo_sesion/model/fechas.dart';
import 'package:flutter/material.dart';
import 'package:demo_sesion/data/datos.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class CalendarioAlumno extends StatefulWidget {
  List<Fechas> fechas;

  CalendarioAlumno(this.fechas) : super();
  @override
  _CalendarPage2State createState() => new _CalendarPage2State(this.fechas);
}

class _CalendarPage2State extends State<CalendarioAlumno> {
  List<Fechas> fechas;
  List<Fechas> listFechas;
  int jiji = 0;
  int repetidor = 0;
  List<DateTime> diasEventos = [DateTime(2019, 09, 1)];
  List<String> dias;
  _CalendarPage2State(this.fechas);
  double cHeight;
  int prueba = 0;
  Widget listview = Text(
      "Seleccione el dia correspondiente al evento para ver su descripción");

  @override
  void initState() {
    super.initState();
    hola();
  }

  void hola() {
    diasEventos.clear();
    for (int i = 0; i < fechas.length; i++) {
      dias = fechas[i].fecha.split('/');

      diasEventos.add(
          DateTime(int.parse(dias[0]), int.parse(dias[1]), int.parse(dias[2])));
    }
  }

  @override
  Widget build(BuildContext context) {
    var alto = MediaQuery.of(context).size.height;
    List<DateTime> presentDates = [
      DateTime(2019, 2, 1),
      DateTime(2019, 2, 3),
      DateTime(2019, 2, 4),
      DateTime(2019, 2, 5),
      DateTime(2019, 2, 6),
      DateTime(2019, 2, 9),
      DateTime(2019, 2, 10),
      DateTime(2019, 2, 11),
      DateTime(2019, 2, 15),
      DateTime(2019, 2, 11),
      DateTime(2019, 2, 15),
      DateTime(2019, 7, 17),
    ];

    List<DateTime> absentDates = [
      DateTime(2019, 2, 2),
      DateTime(2019, 2, 7),
      DateTime(2019, 2, 8),
      DateTime(2019, 2, 12),
      DateTime(2019, 2, 13),
      DateTime(2019, 2, 14),
      DateTime(2019, 2, 16),
      DateTime(2019, 2, 17),
      DateTime(2019, 2, 18),
      DateTime(2019, 2, 17),
      DateTime(2019, 2, 18),
      DateTime(2019, 7, 17),
    ];

    DateTime _currentDate2 = DateTime.now();
    Widget _presentIcon(String day, String nombre, String descripcion,
            String fechaEvento, String fechaTotal) =>
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(1000),
            ),
          ),
          child: Center(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    print(fechaTotal);
                    print(fechas[1].fecha);
                    repetidor = 0;
                    for (var i = 0; i < fechas.length; i++) {
                      if (fechas[i].fecha == fechaTotal) {
                        repetidor++;
                      }
                    }
                    print(repetidor);
                    listview = Text("");
                    listview = repetidor == 1
                        ? ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
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
                                          "Nombre: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(nombre),
                                        Text(
                                          "Fecha: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(fechaEvento),
                                        Text(
                                          "Descripcion: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(descripcion),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: fechas?.length ?? 0,
                            itemBuilder: (lista, position) {
                              Fechas prueba = fechas[position];
                              if (prueba.fecha == fechaTotal) {
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(5),
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
                                            "Nombre Evento: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(prueba.nombreEvento),
                                          Text("Fecha: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(prueba.fechaEvento),
                                          Text("Descripcion: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(prueba.descripcionEvento),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  width: 1,
                                );
                              }
                            });
                  });
                },
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
          ),
        );

    Widget _iconosPresentador(
            String day,
            String month,
            String year,
            String nombre,
            String descripcion,
            String fechaEvento,
            diasEventos) =>
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(1000),
            ),
          ),
          child: Center(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    listview = ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: fechas?.length ?? 0,
                        itemBuilder: (lista, position) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
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
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              runSpacing: 5.0,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Nombre: " +
                                          fechas[position].nombreEvento,
                                    ),
                                    Text("Descripcion: " +
                                        fechas[position].descripcionEvento),
                                    Text("Materia: " + fechas[position].fecha),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  });
                },
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
          ),
        );

    EventList<Event> _markedDateMap = new EventList<Event>(
      events: {},
    );

    CalendarCarousel _calendarCarouselNoHeader;

    cHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < diasEventos.length; i++) {
      _markedDateMap.add(
        diasEventos[i],
        new Event(
            date: diasEventos[i],
            title: 'Event 5',
            icon: _presentIcon(
                diasEventos[i].day.toString(),
                fechas[i].nombreEvento,
                fechas[i].descripcionEvento,
                fechas[i].fechaEvento,
                fechas[i].fecha)),
      );
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      locale: "es",
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.blue[200],
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal:
          null, // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );

    return new Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _calendarCarouselNoHeader,
          ),
          Expanded(
            flex: 4,
            child: listview,
          )
        ],
      ),
      backgroundColor: Color(0xFFE6E6E6),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.022,
      ),
      title: new Text(
        data,
      ),
    );
  }
}
