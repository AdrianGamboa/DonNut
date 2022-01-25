import 'package:don_nut/src/models/producto.dart';
import 'package:don_nut/src/screens/product_info.dart';

import 'package:don_nut/src/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.listTopProducts,
      required this.listBanners,
      required this.listProducts})
      : super(key: key);

  final Future<List<Producto>> listTopProducts;
  final Future<List<Producto>> listBanners;
  final Future<List<Producto>> listProducts;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ProductService productServices = ProductService();

  final List<String> listCategories = [
    //Sacar las categorias de bd
    'Top Ventas',
    'Dulces',
    'Saladas',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listCategories.length, //Cantidad de categorias(sacar de bd)
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            //Banner tipo carrusel que va a mostrar promociones y descuentos en curso
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 220,
              backgroundColor: Colors.white,
              title: Container(
                color: Colors.white,
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: FutureBuilder(
                  future: widget.listBanners,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _getBanners(snapshot.data, context);
                    } else if (snapshot.hasError) {
                      return const Text("Error al extraer la información");
                    }

                    return const Center(
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
                preferredSize: const Size.fromHeight(55.0), //Tamaño del TabBar
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TabBar(
                    unselectedLabelColor: const Color(0xff707070),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffAD53AE),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              CustomBoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(0, 1),
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
                child: productCategory(widget.listTopProducts, "Top Ventas"),
              ),
              for (var i = 1; i < listCategories.length; i++)
                ScrollConfiguration(
                  behavior: ListViewGlow(),
                  child:
                      productCategory(widget.listProducts, listCategories[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//Establece a los productos de esa categoria en un mismo GridView
Widget productCategory(_products, _category) {
  return FutureBuilder(
    future: _products,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          margin: const EdgeInsets.only(bottom: 22, top: 22),
          child: GridView.count(
              clipBehavior: Clip.none,
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 22,
              children: _listProducts(snapshot.data, _category, context)),
        );
      } else if (snapshot.hasError) {
        return const Text("Error al extraer la información");
      }

      return const Center(
          child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: CircularProgressIndicator()));
    },
  );
}

//Metodo que devuelve la lista de los productos divididos por su categoria
List<Widget> _listProducts(data, category, context) {
  List<Widget> products = [];

  for (var item in data) {
    if (item.tipo == category ||
        category ==
            'Top Ventas' /*no hay tipo top ventas, asi por el momento para que aparezca algo*/) {
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
            margin: const EdgeInsets.only(left: 22, right: 22),
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
                      style: const TextStyle(
                          fontSize: 20, color: Color(0xff707070)))),
              const SizedBox(height: 8),
              AutoSizeText(
                '₡' + item.precio,
                textAlign: TextAlign.center,
                style: const TextStyle(
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

Widget _getBanners(data, context) {
  List<Widget> banners = [];
  for (var item in data) {
    banners.add(Container(
        width: 260,
        decoration: const BoxDecoration(color: Color(0xffC4C2C2)),
        constraints: const BoxConstraints(
          maxWidth: 260,
        ),
        child: Image.network(
          'https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Y2hhbmdlfGVufDB8fDB8fA%3D%3D&w=1000&q=80', //item.imgBanner,
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
