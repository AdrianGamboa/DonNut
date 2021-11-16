import 'package:flutter/material.dart';
import 'home_page.dart';

class ProductInfoPage extends StatefulWidget {
  const ProductInfoPage({Key? key}) : super(key: key);

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductPageArguments;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Image.network(
              'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
              height: 70,
              width: 70),
          elevation: 0,
        ),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Row(
            children: [
              Column(
                children: [
                  Text(arguments.nombre),
                  Text(arguments.descripcion),
                  Text(arguments.costo),
                ],
              ),
              Image.network(arguments.imagen, height: 70, width: 70),
            ],
          )
        ],
      )), //bottomNavigationBar: const NavBar(), //Barra de navegacion inferior
      bottomNavigationBar: const NavBar(),
    );
  }
}

class ProductPageArguments {
  String nombre;
  String descripcion;
  String costo;
  String imagen;
  ProductPageArguments(
      {required this.nombre,
      required this.descripcion,
      required this.costo,
      required this.imagen});
}
