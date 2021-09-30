import 'package:flutter/material.dart';
import 'package:recipe_app/views/categorias_select.dart';

class Categoria extends StatefulWidget {
  @override
  _Categoria createState() => _Categoria();
}

class _Categoria extends State<Categoria> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("CATEGORIAS"),
        backgroundColor: Color(0xff213A50),
      ),
      body: Stack(
        children: [
          Container(
            width: 2000,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [const Color(0xff213A50), const Color(0xff071930)],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  gestureDetectorCategory(
                      size,
                      'Frituras',
                      "https://www.receitasdecomida.com.br/wp-content/uploads/2013/05/bolinho-com-linguica-creme-de-queijo-3053.jpg",
                      Colors.white, () {
                    navigateCategory("fried", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Ensaladas',
                      "https://i.pinimg.com/564x/20/0f/f9/200ff967586fd3b3e08d5464c01625bf.jpg",
                      Colors.white, () {
                    navigateCategory("ensaladas", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Pastas',
                      "https://i.pinimg.com/564x/f1/62/a1/f162a11b56aee58dd1d6483018d73d96.jpg",
                      Colors.white, () {
                    navigateCategory("pastas", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Frutas',
                      "https://i.pinimg.com/564x/f9/18/13/f91813cbacbf29d992de0721cf99680b.jpg",
                      Colors.white, () {
                    navigateCategory("frutas", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Cereales',
                      "https://i.pinimg.com/564x/06/f9/26/06f926e81b3fefcf6cce78f2cc615974.jpg",
                      Colors.white, () {
                    navigateCategory("cereales", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Sopas',
                      "https://i.pinimg.com/564x/9f/3d/53/9f3d53fc1f851c8c8c764630e7077e3c.jpg",
                      Colors.white, () {
                    navigateCategory("sopas", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Carnes',
                      "https://i.pinimg.com/564x/5b/a7/51/5ba751a1907a6bcf02cd7e703e067c3e.jpg",
                      Colors.white, () {
                    navigateCategory("carnes", context);
                  }),
                  gestureDetectorCategory(
                      size,
                      'Postres',
                      "https://i.pinimg.com/564x/de/dd/dd/deddddb3e3824539d01b156313d55fcd.jpg",
                      Colors.white, () {
                    navigateCategory("postres", context);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateCategory(String category, context) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Select(category),
        ),
      );
    });
  }
}

GestureDetector gestureDetectorCategory(Size size, String categoryText,
    String image2, Color colorText, Function onTap) {
  return GestureDetector(
    child: Container(
      width: size.height,
      height: size.height / 6,
      //color: colorBackground,
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: NetworkImage(image2),
              fit: BoxFit.cover)),
      child: Center(
        child: Text(
          categoryText.toUpperCase(),
          style: TextStyle(
            color: colorText,
            fontWeight: FontWeight.bold,
            fontSize: 50.0,
            fontFamily: 'Impact',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    onTap: onTap,
  );
}
