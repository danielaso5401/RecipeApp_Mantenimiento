import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe_fav.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Favoritos extends StatefulWidget {
  @override
  _Favoritos createState() => _Favoritos();
}

class _Favoritos extends State<Favoritos> {
  bool _loading = false;
  Future<List<RecipeFav>> listfav;
  Future<List<RecipeFav>> get_fav() async {
    var url = Uri.parse("http://192.168.0.8:5000/most_favoritos");
    final respuesta = await http.get(url);
    List<RecipeFav> cand = [];
    if (respuesta.statusCode == 200) {
      String cuerpo = utf8.decode(respuesta.bodyBytes);
      final jasodata = jsonDecode(cuerpo);
      for (var i in jasodata) {
        cand.add(RecipeFav(i["idfavoritos"], i["categoria"], i["url"],
            i["image"], i["label"], i["source"]));
      }
      return cand;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    listfav = get_fav();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("FAVORITOS"),
        backgroundColor: Color(0xff213A50),
      ),
      body: FutureBuilder(
        future: listfav,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: lista(snapshot.data, context),
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
      backgroundColor: const Color(0xff071930),
    );
  }

  List<Widget> lista(List<RecipeFav> data, context) {
    _launchURL(String url) async {
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    List<Widget> candi = [];
    for (var i in data) {
      candi.add(Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (kIsWeb) {
                _launchURL(i.url);
              } else {
                print(i.url + " this is what we are going to see");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeView(
                              postUrl: i.url,
                            )));
              }
            },
            child: Container(
              margin: EdgeInsets.all(8),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    i.image,
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: 300,
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white30, Colors.white],
                            begin: FractionalOffset.centerRight,
                            end: FractionalOffset.centerLeft)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            i.title,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontFamily: 'Overpass'),
                          ),
                          Text(
                            i.label,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontFamily: 'OverpassRegular'),
                          ),
                          FloatingActionButton(
                            child: Icon(Icons.favorite),
                            elevation: 5.0,
                            backgroundColor: Colors.red,
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              String url =
                                  "http://192.168.0.8:5000/delete_favoritos/" +
                                      i.id.toString();
                              var response = await http.delete(url);
                              setState(() {
                                _loading = true;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ));
    }
    return candi;
  }
}
