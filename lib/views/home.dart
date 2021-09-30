import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/views/categorias.dart';
import 'package:recipe_app/views/favoritos.dart';
import 'package:recipe_app/views/usuario.dart';
import 'RecipieTile.dart';
import 'ingresousuario.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  List<RecipeModel> recipies = new List();
  String ingridients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Container(
          width: 180,
          child: Drawer(
              child: ListView(
            children: [
              buildMenuItem(
                text: 'Categorias',
                icon: Icons.account_tree_sharp,
                onClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Categoria()),
                  );
                },
              ),
              const SizedBox(height: 16),
              buildMenuItem(
                  text: 'Favoritos',
                  icon: Icons.favorite_border,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favoritos()),
                    );
                  }),
              const SizedBox(height: 16),
              buildMenuItem(
                  text: 'Usuario',
                  icon: Icons.person,
                  onClicked: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IngresoSalud()));
                  }),
              const SizedBox(height: 16),
              buildMenuItem(
                  text: 'Historial',
                  icon: Icons.workspaces_outline,
                  onClicked: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Salud()));
                  }),
              const SizedBox(height: 12),
              Divider(color: Colors.white70),
              const SizedBox(height: 24),
              buildMenuItem(
                  text: 'Extras',
                  icon: Icons.account_tree_outlined,
                  onClicked: () {}),
              const SizedBox(height: 16),
              buildMenuItem(
                  text: 'Información',
                  icon: Icons.notifications_outlined,
                  onClicked: () {}),
            ],
          )),
        ),
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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: !kIsWeb
                      ? Platform.isIOS
                          ? 60
                          : 30
                      : 30,
                  horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState.openDrawer(),
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        "AppFull ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Overpass'),
                      ),
                      Text(
                        "Recetas",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontFamily: 'Overpass'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "¿Qué vas a cocinar hoy?",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Overpass'),
                  ),
                  Text(
                    "Simplemente ingrese los ingredientes que tiene y le mostraremos la mejor receta para usted",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'OverpassRegular'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Overpass'),
                            decoration: InputDecoration(
                              hintText: "Ingresar ingredientes",
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: 'Overpass'),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                            onTap: () async {
                              if (textEditingController.text.isNotEmpty) {
                                if (textEditingController.text == "palta" ||
                                    textEditingController.text == "aguacate" ||
                                    textEditingController.text == "avocado") {
                                  setState(() {
                                    _loading = true;
                                  });
                                  recipies = new List();
                                  String url =
                                      "https://api.edamam.com/search?q=palta&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  String url2 =
                                      "https://api.edamam.com/search?q=aguacate&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  var response = await http.get(url);
                                  var response2 = await http.get(url2);

                                  print(" $response this is response");
                                  Map<String, dynamic> jsonData =
                                      jsonDecode(response.body);
                                  print("this is json Data $jsonData");
                                  jsonData["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  Map<String, dynamic> jsonData2 =
                                      jsonDecode(response2.body);

                                  jsonData2["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  setState(() {
                                    _loading = false;
                                  });
                                  recipies =
                                      LinkedHashSet<RecipeModel>.from(recipies)
                                          .toList();
                                  print("doing it");
                                } else if (textEditingController.text ==
                                        "albaricoque" ||
                                    textEditingController.text == "durazno") {
                                  setState(() {
                                    _loading = true;
                                  });
                                  recipies = new List();
                                  String url =
                                      "https://api.edamam.com/search?q=albaricoque&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  String url2 =
                                      "https://api.edamam.com/search?q=durazno&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  var response = await http.get(url);
                                  var response2 = await http.get(url2);

                                  print(" $response this is response");
                                  Map<String, dynamic> jsonData =
                                      jsonDecode(response.body);
                                  print("this is json Data $jsonData");
                                  jsonData["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  Map<String, dynamic> jsonData2 =
                                      jsonDecode(response2.body);

                                  jsonData2["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  setState(() {
                                    _loading = false;
                                  });
                                  recipies =
                                      LinkedHashSet<RecipeModel>.from(recipies)
                                          .toList();
                                  print("doing it");
                                } else if (textEditingController.text ==
                                        "yuca" ||
                                    textEditingController.text == "mandioca") {
                                  setState(() {
                                    _loading = true;
                                  });
                                  recipies = new List();
                                  String url =
                                      "https://api.edamam.com/search?q=yuca&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  String url2 =
                                      "https://api.edamam.com/search?q=mandioca&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  var response = await http.get(url);
                                  var response2 = await http.get(url2);

                                  print(" $response this is response");
                                  Map<String, dynamic> jsonData =
                                      jsonDecode(response.body);
                                  print("this is json Data $jsonData");
                                  jsonData["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  Map<String, dynamic> jsonData2 =
                                      jsonDecode(response2.body);

                                  jsonData2["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  setState(() {
                                    _loading = false;
                                  });
                                  recipies =
                                      LinkedHashSet<RecipeModel>.from(recipies)
                                          .toList();
                                  print("doing it");
                                } else if (textEditingController.text ==
                                        "piña" ||
                                    textEditingController.text == "ananas") {
                                  setState(() {
                                    _loading = true;
                                  });
                                  recipies = new List();
                                  String url =
                                      "https://api.edamam.com/search?q=piña&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  String url2 =
                                      "https://api.edamam.com/search?q=ananas&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  var response = await http.get(url);
                                  var response2 = await http.get(url2);

                                  print(" $response this is response");
                                  Map<String, dynamic> jsonData =
                                      jsonDecode(response.body);
                                  print("this is json Data $jsonData");
                                  jsonData["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  Map<String, dynamic> jsonData2 =
                                      jsonDecode(response2.body);

                                  jsonData2["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  setState(() {
                                    _loading = false;
                                  });
                                  recipies =
                                      LinkedHashSet<RecipeModel>.from(recipies)
                                          .toList();
                                  print("doing it");
                                } else {
                                  setState(() {
                                    _loading = true;
                                  });
                                  recipies = new List();
                                  String url =
                                      "https://api.edamam.com/search?q=${textEditingController.text}&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                  var response = await http.get(url);
                                  print(" $response this is response");
                                  Map<String, dynamic> jsonData =
                                      jsonDecode(response.body);
                                  print("this is json Data $jsonData");
                                  jsonData["hits"].forEach((element) {
                                    print(element.toString());
                                    RecipeModel recipeModel = new RecipeModel();
                                    recipeModel =
                                        RecipeModel.fromMap(element['recipe']);
                                    recipies.add(recipeModel);
                                    print(recipeModel.url);
                                  });
                                  setState(() {
                                    _loading = false;
                                  });

                                  print("doing it");
                                }
                              } else {
                                print("not doing it");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0xffA2834D),
                                        const Color(0xffBC9A5F)
                                      ],
                                      begin: FractionalOffset.topRight,
                                      end: FractionalOffset.bottomLeft)),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.search,
                                      size: 18, color: Colors.white),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 10.0, maxCrossAxisExtent: 300.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(recipies.length, (index) {
                          return GridTile(
                              child: RecipieTile(
                            title: recipies[index].label,
                            imgUrl: recipies[index].image,
                            desc: recipies[index].source,
                            url: recipies[index].url,
                          ));
                        })),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//crear categorias del menu
Widget buildMenuItem({
  String text,
  IconData icon,
  VoidCallback onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(text, style: TextStyle(color: color)),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}
