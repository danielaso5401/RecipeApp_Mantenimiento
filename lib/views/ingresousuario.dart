import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IngresoSalud extends StatefulWidget {
  @override
  _IngresoSalud createState() => _IngresoSalud();
}

class _IngresoSalud extends State<IngresoSalud> {
  TextEditingController name = new TextEditingController();
  TextEditingController peso = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("INGRESO DE DATOS"),
        backgroundColor: Color(0xff213A50),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: !kIsWeb
                ? Platform.isIOS
                    ? 20
                    : 30
                : 30,
            horizontal: 24),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xff213A50), const Color(0xff071930)],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft)),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Image(
              image: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/1077/1077012.png"),
              height: 150,
            ),
            SizedBox(height: 10),
            TextField(
              controller: name,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
              decoration: new InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: peso,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
              decoration: new InputDecoration(
                labelText: 'Peso',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
              ),
            ),
            SizedBox(height: 20),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 90.0),
              child: RaisedButton(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  textColor: Colors.white,
                  child: Text(
                    "Ingresar",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () async {
                    var url =
                        Uri.parse('http://192.168.0.8:5000/creat_usuario');

                    var response = await http.post(url,
                        headers: {
                          "content-type": "application/json",
                        },
                        body: jsonEncode({
                          "name": name.text,
                          "peso": peso.text,
                        }));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
