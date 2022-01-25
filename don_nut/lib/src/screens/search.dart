import 'package:don_nut/src/models/producto.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

final bucketGlobal = PageStorageBucket();

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.listTopProducts}) : super(key: key);

  final Future<List<Producto>> listTopProducts;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final busquedaTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.center,
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 325,
            height: 35,
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: busquedaTextController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Buscar",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {},
                ),
                alignLabelWithHint: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          productCategory(widget.listTopProducts, "Top Ventas")
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    busquedaTextController.dispose();
  }
}
