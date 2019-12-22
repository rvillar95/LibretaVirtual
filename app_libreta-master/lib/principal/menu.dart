import 'package:flutter/material.dart';
import 'opcion.dart';

class Menu extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 2,
      children: <Widget>[
        GestureDetector(
          child: Opcion("Opcion 1", Icon(Icons.message, size: 50.0, color: Colors.blue,)),
          onTap: (){
            print("option 1");
          },
        ),
        Opcion("Opcion 2", Icon(Icons.account_circle, size: 50.0,color: Colors.blue)),
        Opcion("Opcion 3", Icon(Icons.add_alert, size: 50.0,color: Colors.blue)),
        Opcion("Opcion 4", Icon(Icons.assignment, size: 50.0,color: Colors.blue)),
      ],
    );
  }
}