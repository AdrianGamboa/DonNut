import 'package:don_nut/src/models/producto.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.listTopProducts}) : super(key: key);
  final Future<List<Producto>> listTopProducts;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final busquedaTextController = TextEditingController();
  List<String> listCategories = [
    'Top Ventas',
    'Dulces',
    'Saladas',
  ];
  String? valueChoose;
  @override
  Widget build(BuildContext context) {
    RangeValues values = const RangeValues(1000, 3000);
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actions: [
                              TextButton(onPressed: () {Navigator.of(context).pop('Cancelar');}, child: const Text("Cancelar"), style: TextButton.styleFrom(primary: const Color(0xffAD53AE))),
                              TextButton(onPressed: () {Navigator.of(context).pop('Aplicar');}, child: const Text("Aplicar"),style: TextButton.styleFrom(primary: const Color(0xffAD53AE))),
                            ],
                            content: Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.white,
                              width: 380,
                              height: 440,
                              child: Column(
                                children: [
                                  
                                  const Text(
                                    "Filtro de busqueda",
                                    style: TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w700,fontSize: 20),
                                  ),
                                const SizedBox(height: 80,),
                                
                                Row(
                                  children: [
                                    const Text(
                                        "Categoria",
                                        style: TextStyle(color: Color(0xff707070),fontSize: 18),
                                    ),
                                    const SizedBox(width: 40,),
                                    Expanded(
                                      child: StatefulBuilder(builder: (context, setState) => 
                                      DropdownButton<String>(
                                      hint: const Text("Seleccionar"),
                                      value: valueChoose,
                                      onChanged: (newValue) { setState(() {
                                              valueChoose = newValue!;
                                            });  },
                                       items: listCategories.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                      ),  
                                      ),
                                    )  
                                  ],
                                ),
                                const SizedBox(height: 80,),
                                Row(
                                    children: [
                                      const Text(
                                        "Precio",
                                        style: TextStyle(color: Color(0xff707070),fontSize: 18),
                                      ),
                                      
                                      StatefulBuilder(
                                        builder: (context, setState) => SliderTheme(
                                        data: const SliderThemeData(
                                          trackHeight: 1,
                                        ),
                                        child:RangeSlider(
                                          values:values, 
                                          activeColor: const Color(0xffAD53AE),
                                          min: 500,
                                          max: 4000,
                                          divisions: 35,
                                          labels: RangeLabels(
                                            values.start.round().toString(),
                                            values.end.round().toString(),
                                          ),
                                          onChanged: (RangeValues newRange) {
                                            setState(() {
                                              values = newRange;
                                            });
                                          }
                                        )
                                        ),
                                      ),
                                    ],
                                  ),
                                     
                                ],
                              )
                            ),
                          );
                        },
                      );
                    },
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