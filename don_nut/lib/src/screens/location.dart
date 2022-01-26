import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final busquedaTextController = TextEditingController();
  bool banderaAgrandar= false;
  static const _initialCameraPosition = CameraPosition(target: LatLng(9.373786, -83.703023),
    zoom: 17,);
    Marker _destination =Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: 
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          leading: const BackButton(
          color: Colors.black
          ), 
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              markers: {
                if(_destination != null)_destination
              },
              onLongPress: _addMarker,),
             BottomModal() 
        ],
      ),
    );
  }
  void _biggerSetLocation(){
    banderaAgrandar=true;
  }
  void _addMarker(LatLng pos){
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: 
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: pos,
      );
    });
  }

}
  class BottomModal extends StatelessWidget {
  const BottomModal({Key? key}) : super(key: key);

  
    @override
    Widget build(BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.05,
        minChildSize: 0.05,
        maxChildSize: 0.4,
        builder: (context, scrollController){
          return Container(
            child: SetLocation(scrollController) ,
             decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )
          ),
        );
        });
    }
  }
  class SetLocation extends StatelessWidget {
    final ScrollController scrollController;
    const SetLocation(this.scrollController,{Key? key}) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              
              const Text("Establecer Ubicación",style: TextStyle(color: Colors.black, fontSize: 20)), 
              Row(
                children: const [
                  SizedBox(width: 50,height: 80,),
                   Text("Favoritos:",style: TextStyle(color:  Color(0xff707070), fontSize: 20,)),   
                ]
              ),
              Row(
                children: const [
                  SizedBox(width: 50,height: 30,),
                  Text("Observaciones:",style: TextStyle(color: Color(0xff707070), fontSize: 20),),
                ],
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: TextFormField(
                  maxLength: 200,
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
            ],
          ),
        ),
      );
    }
  }