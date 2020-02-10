import 'package:demo_sesion/principal/Apoderado/main.dart';
import 'package:demo_sesion/principal/Profesor/main.dart';
import 'package:demo_sesion/provider/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:demo_sesion/principal/principal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demo_sesion/data/datos.dart';
import 'package:demo_sesion/model/profesor.dart';
import 'package:demo_sesion/model/alumno.dart';
import 'package:demo_sesion/model/apoderado.dart';
import 'package:demo_sesion/principal/Alumno/main.dart';
class Login extends StatefulWidget {
  var state;
  Login(this.state);

  @override
  State<StatefulWidget> createState() => new _Login(this.state);
}

class _Login extends State<Login> {
  int _radioValue1 = 0;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          _radioValue1 = 0;
          break;
        case 1:
          _radioValue1 = 1;
          break;
        case 2:
          _radioValue1 = 2;
          break;
      }
    });
  }

  String username = "";
  String password = "";
  int rol;
  List<Profesor> profesorList;
  List<Alumno> alumnoList;
  List<Apoderado> apoderadoList;
  var state;

  _Login(this.state);

  _addUser(id, name, lastname, foto, institucion, rol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList("data", [id, name, lastname, foto, institucion, rol]);
    });
  }

  void iniciarSesion(rut, clave) async {
    Servicio servicio = Servicio();

    if (_radioValue1 == 0) {
      profesorList = await servicio.loginProfesor(rut, clave);
      print(profesorList[0].nombres);
      if (profesorList.length > 0) {
        print(profesorList[0].nombres + " " + profesorList[0].apellidos);
        //save shared preferences
        _addUser(
            profesorList[0].id,
            profesorList[0].nombres,
            profesorList[0].apellidos,
            profesorList[0].foto,
            profesorList[0].institucion,
            "1");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuProfesor()));
      } else {
        print("error");
      }
    } else if (_radioValue1 == 1) {
      //call to pushNotifications provider
      final pushProvider = PushNotificationsProvider();
      //call to token id from notifications providers
      var token = await pushProvider.getToken();
      print("======TOKEN======");
      print(token);

      alumnoList = await servicio.loginAlumno(rut, clave, token);
      if (alumnoList.length > 0) {
        print(
            alumnoList[0].nombresAlumno + " " + alumnoList[0].apellidosAlumno);
        //save shared preferences
        _addUser(
            alumnoList[0].idAlumno,
            alumnoList[0].nombresAlumno,
            alumnoList[0].apellidosAlumno,
            alumnoList[0].fotoAlumno,
            alumnoList[0].institucion_idInstitucion,
            "2");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuAlumno()));
      } else {
        print("error");
      }
    } else if (_radioValue1 == 2) {
      //call to pushNotifications provider
      final pushProvider = PushNotificationsProvider();
      //call to token id from notifications providers
      var token = await pushProvider.getToken();
      print("======TOKEN======");
      print(token);

      apoderadoList = await servicio.loginApoderado(rut, clave, token);
      if (apoderadoList.length > 0) {
        print(apoderadoList[0].nombresApoderado +
            " " +
            apoderadoList[0].apellidosApoderado);
        //save shared preferences
        _addUser(
            apoderadoList[0].idApoderado,
            apoderadoList[0].nombresApoderado,
            apoderadoList[0].apellidosApoderado,
            apoderadoList[0].fotoApoderado,
            apoderadoList[0].institucionApoderado,
            "3");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuApoderado()));
      } else {
        print("error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    var deviceData = MediaQuery.of(context).orientation;
    var alto = MediaQuery.of(context).size.height;
    final foto = Container(
      height: alto *0.2,
      width:alto *0.2,
      alignment: Alignment(0.5, -1),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/img/logo.png",
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
           
          ]),
    );

    final titulo = Container(
      padding: EdgeInsets.only(top: 20),
        child: Center(
      child: Text(
        "Acceso",
        style: TextStyle( fontSize: 30.0),
      ),
    ));

    final txt1 = Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Rut",
          icon: Icon(Icons.perm_identity),
        ),
        style: TextStyle( color: Colors.grey),
        onChanged: (value) {
          this.username = value;
        },
      ),
    );

    final txt2 = Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Clave",
          icon: Icon(Icons.vpn_key),
        ),
        onChanged: (value) {
          this.password = value;
        },
        style: TextStyle( color: Colors.grey),
      ),
    );

    final radio2 = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValueChange1,
                ),
                Text("Profesor"),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValueChange1,
                ),
                Text("Alumno"),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Radio(
                  value: 2,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValueChange1,
                ),
                Text("Apoderado")
              ],
            ),
          ),
        ],
      ),
    );

    final radio = Flexible(
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: 2.0,
          runSpacing: 2.0,
          children: <Widget>[
            Radio(
              value: 0,
              groupValue: _radioValue1,
              onChanged: _handleRadioValueChange1,
            ),
            Text("Profesor"),
            Radio(
              value: 1,
              groupValue: _radioValue1,
              onChanged: _handleRadioValueChange1,
            ),
            Text("Alumno"),
            Radio(
              value: 2,
              groupValue: _radioValue1,
              onChanged: _handleRadioValueChange1,
            ),
            Text("Apoderado")
          ],
        ),
      ),
    );

    final button = Container(
      width: double.infinity,
      margin: EdgeInsets.all(10.0),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Text('Entrar'),
          textColor: Colors.white,
          color: (Colors.blue),
          onPressed: () {
            iniciarSesion(
              this.username,
              this.password,
            );
          }),
    );

    final contenedor = Container(
      margin: EdgeInsets.all(40.0),
      height:
          deviceData.toString() == "Orientation.portrait" ? 450.0 : alto * .67,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0, //degradado
                offset: Offset(0.0, 7.0) //posision de la sombra
                )
          ]),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[titulo, txt1, txt2, radio2, button],
      ),
    );

    return state == 1
        ? (Scaffold(
          
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.lightBlue,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment(-0.0, -1.2),
                  children: <Widget>[contenedor, foto],
                )
              ],
            ),
          ))
        : (Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment(-0.0, -1.2),
                children: <Widget>[contenedor, foto],
              )
            ],
          ));
  }
}
