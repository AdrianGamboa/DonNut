import 'dart:convert';

import 'package:don_nut/src/models/order_original.dart';
import 'package:don_nut/src/models/producto.dart';
import 'package:don_nut/src/screens/delivery_page.dart';
import 'package:don_nut/src/screens/order_page.dart';
import 'package:don_nut/src/screens/preparation_page.dart';
import 'package:don_nut/src/screens/search.dart';
import 'package:don_nut/src/services/order_original_service.dart';
import 'package:don_nut/src/services/product_service.dart';
import 'package:don_nut/src/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:don_nut/src/utils/global.dart' as globals;
import 'package:get_storage/get_storage.dart';
import 'home_page.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

late Future<List<Producto>> _listTopProducts;
late Future<List<Producto>> _listBanners;
late Future<List<Producto>> _listProducts;
Future<List<OrderOriginal>>? _listOrders;
Future<List<OrderOriginal>>? _listOrdersDelivery;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentTab = 0;
  late Widget currentPage;
  late MyHomePage homePage;
  late LoginPage loginPage;
  late SearchPage searchPage;
  late PreparationPage preparationPage;
  late DeliveryPage deliveryPage;
  late OrderPage orderPage;
  late List<Widget> pages;

  ProductService productServices = ProductService();
  OrderOriginalService orderServices = OrderOriginalService();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    if (GetStorage().read('email') != null ||
        GetStorage().read('password') != null) {
      login().whenComplete(() {
        /*_listOrders = orderServices.getOrders(globals.url+ "pedidos/lista/preparacion").whenComplete(() {
        preparationPage = PreparationPage(listOrders: _listOrders,);
        pages[1]=preparationPage;
        });*/
        /*_listOrdersDelivery = orderServices.getOrders(globals.url+ "pedidos/lista/entrega").whenComplete(() {
        deliveryPage = DeliveryPage(listOrders: _listOrdersDelivery,);
        pages[1]=deliveryPage;
        });*/
        
    });
    }
    _listTopProducts = productServices.getProducts(
        globals.url + "productos/tipo/Saladas"); //Se carga el top ventas
    _listProducts = productServices.getProducts(globals.url + "productos");
    _listBanners = productServices.getProducts(
        globals.url + "productos/tipo/Banners"); //Se cargan los banners
    
    loginPage = const LoginPage();
    homePage = MyHomePage(
        listTopProducts: _listTopProducts,
        listBanners: _listBanners,
        listProducts: _listProducts);
    searchPage = SearchPage(listTopProducts: _listTopProducts);
    preparationPage = PreparationPage(listOrders: _listOrders,);
    deliveryPage = DeliveryPage(listOrders: _listOrdersDelivery,);
    orderPage = const OrderPage();
    pages = [homePage,  searchPage, orderPage, loginPage];
    currentPage = homePage;

    

    super.initState();
  }

  Future<void> refreshPage() async {
    setState(() {
      currentTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //Barra superior de la pantalla
      appBar: currentTab == 0 || currentTab == 1
          ? PreferredSize(
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
            )
          : null,
      body: currentPage,
      //Barra de navegacion inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
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
      ),
    );
  }

  Future<String> login() async {
    final response = await http.post(
      Uri.parse(url + 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": GetStorage().read('email'),
        "password": GetStorage().read('password')
      }),
    );
  

    if (response.statusCode == 200) {
      token = json.decode(response.body)['token'];
      return token;
    }
    else{
      return "";
    }
  }
}
