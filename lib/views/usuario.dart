import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/views/salud.dart';

class Salud extends StatefulWidget {
  @override
  _Salud createState() => _Salud();
}

class _Salud extends State<Salud> {
  Future<List<Persona>> listfav;

  Future<List<Persona>> get_salud() async {
    var url = Uri.parse("http://192.168.0.8:5000/most_usuario");
    final respuesta = await http.get(url);
    List<Persona> cand = [];
    if (respuesta.statusCode == 200) {
      String cuerpo = utf8.decode(respuesta.bodyBytes);
      final jasodata = jsonDecode(cuerpo);
      for (var i in jasodata) {
        cand.add(Persona(i["name"], i["peso"]));
      }
      return cand;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    listfav = get_salud();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("SALUD"),
        backgroundColor: Color(0xff213A50),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [const Color(0xff213A50), const Color(0xff071930)],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
          ),
          FutureBuilder(
            future: listfav,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: lista(snapshot.data),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("error");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> lista(List<Persona> data) {
    List<Widget> candi = [];
    for (var i in data) {
      candi.add(Card(
          color: Color(0xff213A50),
          child: Row(children: [
            Icon(
              Icons.person,
              size: 50.0,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Usuario:  " + i.name + "\nPeso: " + i.peso + " Kg",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ),
          ])));
    }
    return candi;
  }
}
