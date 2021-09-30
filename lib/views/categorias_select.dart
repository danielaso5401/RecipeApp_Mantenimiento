import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';

import 'RecipieTile.dart';

String dato;

class Select extends StatefulWidget {
  Select(categoria) {
    dato = categoria;
  }
  @override
  _Select createState() => _Select();
}

class _Select extends State<Select> {
  List<RecipeModel> recipies = new List();
  String ingridients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();
  Future<List<RecipeModel>> productos() async {
    setState(() {
      _loading = true;
    });
    recipies = new List();
    String url =
        "https://api.edamam.com/search?q=${dato}&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
    var response = await http.get(url);
    print(" $response this is response");
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print("this is json Data $jsonData");
    jsonData["hits"].forEach((element) {
      print(element.toString());
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipies.add(recipeModel);
      print(recipeModel.url);
    });
    setState(() {
      _loading = false;
    });
  }

  void initState() {
    productos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(dato),
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
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
