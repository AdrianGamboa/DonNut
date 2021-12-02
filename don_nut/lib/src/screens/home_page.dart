// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:don_nut/src/models/producto.dart';
import 'package:don_nut/src/screens/product_info.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:don_nut/src/utils/global.dart' as globals;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Future<List<Producto>> _listBanners;
  late Future<List<Producto>> _listProducts;
  late Future<List<Producto>> _listTopProducts;

  Future<List<Producto>> _getProducts(url) async {
    final response = await http.get(Uri.parse(url));
    List<Producto> products = [];
    if (response.statusCode == 202) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var i in jsonData["data"]) {
        products.add(Producto(
            i['idProducto'],
            i['nombre'],
            i['tipo'],
            i['imgBanner'],
            i['imgProducto'],
            i['descripcion'],
            i['fechaRegistro'],
            i['precio'],
            i['estado']));
      }
      return products;
    } else {
      throw Exception('Error en la conexión');
    }
  }

  //Lo primero que se ejecuta al abrir la pantalla
  @override
  void initState() {
    super.initState();
    _listProducts = _getProducts(globals.url + "productos");
    _listTopProducts = _getProducts(
        globals.url + "productos/tipo/Saladas"); //Se carga el top ventas
    _listBanners = _getProducts(
        globals.url + "productos/tipo/Banners"); //Se cargan los banners
  }

  final List<String> listCategories = [
    'Top Ventas',
    'Dulces',
    'Saladas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Image.network(
              'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
              height: 70,
              width: 70),
          elevation: 0,
        ),
      ),
      //Contenido de la pantalla
      body: DefaultTabController(
        length: listCategories.length,
        child: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              //Banner tipo carrusel que va a mostrar promociones y descuentos en curso
              SliverAppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 250,
                backgroundColor: Colors.white,
                title: Container(
                  color: Colors.white,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: FutureBuilder(
                    future: _listBanners,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _getBanners(snapshot.data, context);
                      } else if (snapshot.hasError) {
                        return Text("Error al extraer la información");
                      }

                      return Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: CircularProgressIndicator()));
                    },
                  )),
                ),
              ),
              //TabBar
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 0,
                pinned: true,
                floating: true,
                elevation: 1,
                bottom: PreferredSize(
                  preferredSize:
                      const Size.fromHeight(55.0), //Tamaño del TabBar
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: TabBar(
                      unselectedLabelColor: Color(0xff707070),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffAD53AE),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      isScrollable: true,
                      tabs: [
                        for (var item in listCategories)
                          Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                CustomBoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    blurStyle: BlurStyle.outer)
                              ],
                            ),
                            child: Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(item),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          //Tabs
          body: Container(
            color: Colors.white,
            child: TabBarView(
              children: <Widget>[
                ScrollConfiguration(
                  behavior: ListViewGlow(),
                  child: ListView(
                    children: [productCategory(_listTopProducts, "Top Ventas")],
                  ),
                ),
                for (var i = 1; i < listCategories.length; i++)
                  ScrollConfiguration(
                    behavior: ListViewGlow(),
                    child: ListView(
                      children: [
                        productCategory(_listProducts, listCategories[i])
                      ],
                    ),
                  ),
              ],
            ),
          ),
        )),
      ),

      //Barra de navegacion inferior
      bottomNavigationBar: const NavBar(),
    );
  }

//Recibe como parametro la lista de productos, junto a la categoria
//Establece a los productos de esa categoria en un mismo GridView
  Widget productCategory(_products, _category) {
    return FutureBuilder(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(bottom: 22, top: 22),
            child: GridView.count(
                clipBehavior: Clip.none,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                mainAxisSpacing: 22,
                children: _listProductsM(snapshot.data, _category)),
          );
        } else if (snapshot.hasError) {
          return Text("Error al extraer la información");
        }

        return Center(
            child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: CircularProgressIndicator()));
      },
    );
  }

//Metodo que devuelve la lista de los productos a mostrar ya colocados en sus "cajones"
  List<Widget> _listProductsM(data, category) {
    List<Widget> products = [];

    for (var item in data) {
      if (item.tipo == category || category == 'Top Ventas') {
        products.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/product_info",
                  arguments: ProductPageArguments(
                      nombre: item.nombre,
                      descripcion: item.descripcion,
                      costo: item.precio,
                      imagen: item.imgProducto));
            },
            child: Container(
              width: 155,
              height: 188,
              margin: EdgeInsets.only(left: 22, right: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(children: [
                const SizedBox(height: 10),
                Image.network(
                  'https://media.discordapp.net/attachments/775922349362642955/907742592479944774/unknown.png',
                  height: 91,
                  width: 102,
                  alignment: Alignment.topCenter,
                ),
                const SizedBox(height: 5),
                Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: AutoSizeText(item.nombre,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff707070)))),
                const SizedBox(height: 8),
                AutoSizeText(
                  '₡' + item.precio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffAD53AE),
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              ]),
            ),
          ),
        );
      }
    }

    return products;
  }
}

Widget _getBanners(data, context) {
  List<Widget> banners = [];
  for (var item in data) {
    banners.add(Container(
        width: 260,
        decoration: BoxDecoration(color: Color(0xffC4C2C2)),
        constraints: BoxConstraints(
          maxWidth: 260,
        ),
        child: Image.network(
          item.imgBanner,
          fit: BoxFit.fill,
        )));
  }

  return Container(
    color: Colors.white,
    height: 200,
    width: MediaQuery.of(context).size.width,
    child: Center(
        child: CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
            ),
            items: banners)),
  );
}

//Widget que establace la barra de navegacion inferior
class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (value) {
        if (value == 0) {
          Navigator.of(context).pushNamed("/");
        } else if (value == 1) {
          print('Vamos a buscar');
        }
        if (value == 2) {
          print('Vamos al carrito');
        }
        if (value == 3) {
          Navigator.of(context).pushNamed("/login");
        }
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Inicio',
          icon: Icon(
            Icons.home_outlined,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Buscar',
          icon: Icon(
            Icons.search,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Carrito',
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Perfil',
          icon: Icon(
            Icons.person_outline_outlined,
            size: 35,
          ),
        ),
      ],
    );
  }
}

//Elimina el efecto de arrastrado al final del ListView
class ListViewGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

//Permite establecer una sombra personalizada a los widgets
class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(
            color: color,
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }
}
