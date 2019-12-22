import 'package:flutter/material.dart';

class DetalleMensaje extends StatelessWidget {
  final String idMensaje;
  final String nombreMensaje;
  final String descripcionMensaje;
  final String fechaCreacionMensaje;
  final String nombreProfesor;
  final String fotoProfesor;
  final String curso;

  DetalleMensaje(
      this.idMensaje,
      this.nombreMensaje,
      this.descripcionMensaje,
      this.fechaCreacionMensaje,
      this.nombreProfesor,
      this.fotoProfesor,
      this.curso);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensaje',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  fotoProfesor,
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
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(60.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 96.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        nombreProfesor,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        fechaCreacionMensaje,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        curso,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: Image.network(fotoProfesor).image,
                                fit: BoxFit.cover),
                          ),
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
                                nombreMensaje,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Divider(),
                            Container(
                                margin: EdgeInsets.all(10.0),
                                height: 320.0,
                                child: Text(descripcionMensaje,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(color: Colors.white)))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
