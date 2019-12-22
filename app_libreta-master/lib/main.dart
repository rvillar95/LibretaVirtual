import 'package:demo_sesion/principal/menu.dart';
import 'package:flutter/material.dart';
import 'package:demo_sesion/login/login.dart';
import 'package:demo_sesion/principal/principal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_sesion/data/datos.dart';

import 'provider/push_notifications_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  List<String> data = [];

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = (prefs.getStringList('data') ?? []);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    final pushProvider = PushNotificationsProvider();
    pushProvider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final c = Container(
      margin: EdgeInsets.all(40.0),
      height: 360.0,
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
      child: Column(
        children: <Widget>[Text("ok")],
      ),
    );

    return new MaterialApp(
        title: 'Libreta Virtual',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.lightBlue,

            //appBar: AppBar(title: Text("Demo Sesion"),),
            body: data.length > 0 ? PrincipalMenu([], 5, 1, "", "") : Login(0)
            //Menu()

            ));
  }
}
