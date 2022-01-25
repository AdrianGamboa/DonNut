import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:don_nut/src/models/producto.dart';

class ProductService {
  Future<List<Producto>> getProducts(url) async {
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
}
