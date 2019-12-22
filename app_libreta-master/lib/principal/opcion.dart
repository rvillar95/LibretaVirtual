import 'package:flutter/material.dart';

class Opcion extends StatelessWidget{

  String titulo="";
  var icon = Icon(Icons.message);


  Opcion(this.titulo, this.icon);


  @override
  Widget build(BuildContext context) {





    final item = Container(
      margin: EdgeInsets.all(10.0),
      height: 360.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,//degradado
                offset: Offset(0.0, 7.0)//posision de la sombra
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Text(titulo),
        ],
      ),
    );

    return item;
  }
}