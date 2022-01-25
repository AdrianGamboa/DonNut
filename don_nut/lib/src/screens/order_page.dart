import 'dart:convert';

import 'package:don_nut/src/models/order.dart';
import 'package:don_nut/src/models/producto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/global.dart';
import 'package:don_nut/src/utils/global.dart' as globals;

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => OrderPageState();
}

int subtotal = 0;

class OrderPageState extends State<OrderPage> {
  late Future<List<Order>> _listOrder; //Lista del carrito

  Future<List<Order>> _getOrder(url) async {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List<Order> orders = [];

    if (response.statusCode == 202) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var i in jsonData["data"]) {
        orders.add(Order(
            i['idProductoCarrito'],
            i['cantidad'],
            Producto(
                i['producto']['idProducto'],
                i['producto']['nombre'],
                i['producto']['tipo'],
                '', //imgBanner
                i['producto']['imgProducto'],
                i['producto']['descripcion'],
                '', //fechaRegistro
                i['producto']['precio'],
                '' //estado
                )));
      }
      return orders;
    } else if (response.statusCode == 401) {
      //No autorizado para ver el carrito
      print(response.body);
      return orders;
    } else {
      throw Exception('Error en la conexión');
    }
  }

  //Lo primero que se ejecuta al abrir la pantalla
  @override
  void initState() {
    super.initState();
    _listOrder = _getOrder(globals.url + "productoscarritos");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.network(
                'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
                height: 70,
                width: 70),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  primary: Colors.black),
              onPressed: () {},
              child: const Text('Editar'),
            ),
          ]),
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: const Text("Mi pedido",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: _listOrder,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            height: 420,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children:
                                    _getProductsOrder(snapshot.data, context)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                text: "Subtotal: ",
                                style:
                                    const TextStyle(color: Color(0xff707070)),
                                children: [
                                  TextSpan(
                                    text: "₡" + subtotal.toString(),
                                    style: const TextStyle(
                                        color: Color(0xffad53ae),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Error al extraer la información");
                    }
                    return const Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: CircularProgressIndicator()));
                  },
                ),
              ],
            ),
          ),
          const Divider(
            indent: 30,
            endIndent: 30,
            height: 40,
            thickness: 0.6,
            color: Colors.black,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Text.rich(
              TextSpan(
                text: "¿Desea aclararnos algo?  ",
                style: const TextStyle(color: Color(0xff707070)),
                children: [
                  TextSpan(
                    text: "Añadir observación",
                    style: const TextStyle(
                        color: Color(0xffad53ae), fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamed("/register");
                      },
                  )
                ],
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 20),
            width: 400,
            child: ElevatedButton(
              child: const Text("Procesar pedido"),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffAD53AE),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _getProductsOrder(data, context) {
  List<Widget> products = [];
  int _subtotal = 0;
  for (var item in data) {
    _subtotal =
        (_subtotal + (int.parse(item.producto.precio) * item.cantidad)) as int;
    products.add(Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 80,
      width: 155,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            item.cantidad.toString() + 'x ' + item.producto.nombre,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            item.producto.descripcion,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Color(0xff707070), fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: "Total ",
              style: const TextStyle(color: Color(0xff707070)),
              children: [
                TextSpan(
                  text: "₡" +
                      (int.parse(item.producto.precio) * item.cantidad)
                          .toString(),
                  style: const TextStyle(
                      color: Color(0xffad53ae), fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    ));

    products.add(
      const Divider(
        height: 40,
        thickness: 0.6,
        color: Colors.black,
      ),
    );
    subtotal = _subtotal;
  }

  return products;
}
