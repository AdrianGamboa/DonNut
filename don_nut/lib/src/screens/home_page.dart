import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names
  final List<String> ListCategories = [
    'Top Ventas',
    'Dulces',
    'Saladas',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: const Color(0xffFFFFFF),
          title: Image.network(
              'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
              height: 70,
              width: 70),
          elevation: 0,
        ),
      ),
      body: ListView(
        //Parte central de la pantalla, zona donde se puede arrastrar para subir y bajar por las donas
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
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
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Image.network(
                              'https://picsum.photos/id/$i/600/400',
                              fit: BoxFit.cover));
                    },
                  );
                }).toList(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 40.0,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  for (var i in ListCategories)
                    Padding(
                      padding: const EdgeInsets.all(5.5),
                      child: Container(
                        width: 130.0,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          color: const Color(0xffFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.05,
                              blurRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(i),
                      ),
                    )
                ]),
              ),
            ],
          ),
          //Seccion de las donas mostradas segun la categoria seleccionada
          Column(
            children: [
              for (var i = 0; i < 10; i++)
                Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 2; i++)
                          Container(
                            width: 155,
                            height: 188,
                            margin:
                                const EdgeInsets.only(left: 14.0, right: 14.0),
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
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
                                  child: const AutoSizeText('Chocolate Chips',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff707070)))),
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
                      ],
                    ))
            ],
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(), //Barra de navegacion inferior
    );
  }
}

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
          print('Vamos al perfil');
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
