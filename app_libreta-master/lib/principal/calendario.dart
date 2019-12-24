import 'package:demo_sesion/model/fechas.dart';
import 'package:flutter/material.dart';
import 'package:demo_sesion/data/datos.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class CalendarPage2 extends StatefulWidget {
  List<Fechas> fechas;

  CalendarPage2(this.fechas) : super();
  @override
  _CalendarPage2State createState() => new _CalendarPage2State(this.fechas);
}

class _CalendarPage2State extends State<CalendarPage2> {
  List<Fechas> fechas;
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
    getFechas();
    if (fechas.length != 0) {
      hola();
    } else {
      print("hola");
    }
  }

  void getFechas() async {
    Servicio servicio = Servicio();
    fechas = await servicio.getFechas();
    print(fechas.length);
  }

  void hola() {
    diasEventos.clear();
    for (int i = 0; i < fechas.length; i++) {
      print(fechas[i].fecha);
      dias = fechas[i].fecha.split('/');

      diasEventos.add(
          DateTime(int.parse(dias[0]), int.parse(dias[1]), int.parse(dias[2])));
    }
  }

  @override
  Widget build(BuildContext context) {
    hola();

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
            String fechaEvento) =>
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
                    listview = Text("");
                    listview = Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.all(15.0),
                              elevation: 100,
                              child: Container(
                                width: double.infinity,
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
                                    Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "Evento: ",
                                                style: TextStyle(
                                                    wordSpacing: 3.0,
                                                    color: Colors.black,
                                                    fontSize: 17.0,
                                                    fontFamily: "Lobster"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                nombre,
                                                style: TextStyle(
                                                    wordSpacing: 3.0,
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontFamily: "Lobster"),
                                              ),
                                            )
                                          ],
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "Fecha: ",
                                                style: TextStyle(
                                                    wordSpacing: 3.0,
                                                    color: Colors.black,
                                                    fontSize: 17.0,
                                                    fontFamily: "Lobster"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                fechaEvento,
                                                style: TextStyle(
                                                    wordSpacing: 3.0,
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontFamily: "Lobster"),
                                              ),
                                            )
                                          ],
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                child: Expanded(
                                                    child: Wrap(
                                              alignment: WrapAlignment.center,
                                              direction: Axis.horizontal,
                                              spacing: 5.0,
                                              runSpacing: 2.0,
                                              children: <Widget>[
                                                Text(
                                                  descripcion,
                                                  style: TextStyle(
                                                      wordSpacing: 3.0,
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                      fontFamily: "Lobster"),
                                                ),
                                              ],
                                            ))),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
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
      for (int j = 0; j < fechas.length; j++) {
        if (j == i) {
          _markedDateMap.add(
            diasEventos[i],
            new Event(
                date: diasEventos[i],
                title: 'Event 5',
                icon: _presentIcon(
                    diasEventos[i].day.toString(),
                    fechas[j].nombreEvento,
                    fechas[j].descripcionEvento,
                    fechas[j].fechaEvento)),
          );
        }
      }
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
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
            flex: 3,
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
