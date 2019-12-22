import 'package:demo_sesion/model/alumnoSel.dart';
import 'package:flutter/material.dart';
import 'package:demo_sesion/principal/principal.dart';
import 'dart:async';

class DataTableDemo extends StatefulWidget {
  List<AlumnoSel> users;
  String seleccion;
  String id;
  DataTableDemo(this.users, this.seleccion,this.id) : super();

  final String title = "Data Table Flutter Demo";

  @override
  DataTableDemoState createState() =>
      DataTableDemoState(this.users, this.seleccion,this.id);
}

class DataTableDemoState extends State<DataTableDemo> {
  List<AlumnoSel> users;
  String seleccion;
  String id;
  List<AlumnoSel> selectedUsers;
  bool sort;

  DataTableDemoState(this.users, this.seleccion,this.id);

  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    super.initState();
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
      print("jiji");
      print(selectedUsers);
      print("jiji");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PrincipalMenu(selectedUsers, 1, 8, seleccion,id)));

      print(selectedUsers.length);
    }
  }

  Future<List<AlumnoSel>> listaAlumnosSeleccionados() async {
    return selectedUsers;
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        columns: [
          DataColumn(
            label: Text("Nombre"),
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

  void alertMensaje() {
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

  @override
  Widget build(BuildContext context) {
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
                child: Center(
                  child: Text(
                    "Usted Selecciono un " + seleccion,
                    style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 30.0,
                        color: Colors.grey),
                  ),
                ),
              ),
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
                          ? alertMensaje
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
}
