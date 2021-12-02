import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class ProductInfoPage extends StatefulWidget {
  const ProductInfoPage({Key? key}) : super(key: key);

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  int cont = 1;
  void contadorMas() {
    if (cont > -1) {
      setState(() {
        cont++;
      });
    }
  }

  void contadorMenos() {
    if (cont > 1) {
      setState(() {
        cont--;
      });
    }
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 180,
                    child: AutoSizeText(
                      arguments.nombre,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    arguments.descripcion,
                    style:
                        const TextStyle(color: Color(0xff707070), fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(TextSpan(
                      text: "₡" + arguments.costo,
                      style: const TextStyle(
                          color: Color(0xffAD53AE),
                          fontWeight: FontWeight.w600),
                      children: const <TextSpan>[
                        TextSpan(
                          text: ' c/u',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontWeight: FontWeight.w600),
                        )
                      ]))
                ],
              ),
              Image.network(arguments.imagen, height: 150, width: 150),
            ],
          ),
          const SizedBox(height: 90),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Unidades",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                width: 180,
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: const Text("-"),
                      onPressed: () {
                        contadorMenos();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: const Color(0xffAD53AE),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text('    $cont    ',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18)),
                    ElevatedButton(
                      child: const Text("+"),
                      onPressed: () {
                        contadorMas();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffAD53AE),
                        shape: const CircleBorder(),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
              const Text(
                "Observaciones",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  minLines: 2,
                  maxLength: 200,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Escribe algo...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff707070),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffAD53AE),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 40, left: 40, top: 20, bottom: 20),
                width: 400,
                child: ElevatedButton(
                  child: Text("Agregar al pedido ₡" + arguments.costo),
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
