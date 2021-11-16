// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:don_nut/src/models/productos.dart';
import 'package:don_nut/src/screens/product_info.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Future<List<Productos>> _listProducts;
  late Future<List<Productos>> _listTopProducts;

  Future<List<Productos>> _getProducts(url) async {
    final response = await http.get(Uri.parse(url));
    List<Productos> productos = [];
    if (response.statusCode == 202) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var i in jsonData["data"]) {
        productos.add(Productos(
            i['idProducto'],
            i['nombre'],
            i['tipo'],
            i['imgBanner'],
            i['imgProducto'],
            i['descripcion'],
            i['fechaRegistro'],
            i['estado']));
      }
      return productos;
    } else {
      throw Exception('Error en la conexión');
    }
  }

  //Lo primero que se ejecuta al abrir la pantalla
  @override
  void initState() {
    super.initState();
    _listProducts =
        _getProducts("https://donnutdev.000webhostapp.com/api/productos");
    _listTopProducts = _getProducts(
        "https://donnutdev.000webhostapp.com/api/productos/tipo/Saladas"); //Se carga el top ventas
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
      body: DefaultTabController(
        length: listCategories.length,
        child: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                toolbarHeight: 250,
                backgroundColor: Colors.white,
                title: Container(
                  color: Colors.white,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: CarouselSlider(
                    //Banner tipo carrusel que va a mostrar promociones y descuentos en curso
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                    ),
                    items: [1, 20, 300, 455, 545].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Image.network(
                                  'https://picsum.photos/id/$i/600/400',
                                  fit: BoxFit.cover));
                        },
                      );
                    }).toList(),
                  )),
                ),
              ),
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 0,
                pinned: true,
                floating: true,
                elevation: 1,
                bottom: PreferredSize(
                  preferredSize:
                      const Size.fromHeight(43.0), //Tamaño del TabBar
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TabBar(
                      unselectedLabelColor: Color(0xff707070),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffAD53AE),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
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
                                border: Border.all(
                                    color: Color(0xffAD53AE), width: 1)),
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
  Widget productCategory(_products, tipo) {
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
                children: _listProductsM(snapshot.data, tipo)),
          );
        } else if (snapshot.hasError) {
          return Text("Error al extraer la información");
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

//Metodo que devuelve la lista de los productos a mostrar ya colocados en sus "cajones"
  List<Widget> _listProductsM(data, tipo) {
    List<Widget> products = [];

    for (var item in data) {
      if (item.tipo == tipo || tipo == 'Top Ventas') {
        products.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/product_info",
                  arguments: ProductPageArguments(
                      nombre: item.nombre,
                      descripcion: item.descripcion,
                      costo: "1000",
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
                const AutoSizeText(
                  '₡1000',
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
          print('Vamos a home');
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

//Elimina el efecto de arrastrado final del ListView
class ListViewGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
