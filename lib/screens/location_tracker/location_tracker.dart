import 'dart:async';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pass_slip_management_web/utils/palettes.dart';

class LocationTracker extends StatefulWidget {
  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  MapType _mapType = MapType.normal;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Uint8List? _userPin;
  var _events = FirebaseDatabase.instance.ref().child('locations');

  Future _getByte({required String path}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 60);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getByte(path: 'assets/icons/user_location.png').then((value){
      setState(() {
        _userPin = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _events.onValue,
        builder: (context, snapshot) {
          List? datas;

          if(snapshot.hasData){
            if(snapshot.data!.snapshot.value != null){
              datas = (snapshot.data!.snapshot.value as Map).values.toList();
            }
          }
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(right: 25,top: 20,bottom: 20),
            child: !snapshot.hasData ?
            Center(
              child: CircularProgressIndicator(color: palettes.blue,),
            ) :  Stack(
              children: [
                GoogleMap(
                  mapType: _mapType,
                  markers: Set<Marker>.of([
                    if(datas != null)...{
                      for(int x = 0; x < datas.length; x++)...{
                        Marker(
                          markerId: MarkerId('User'),
                          flat: true,
                          position: LatLng(double.parse(datas[x]["latitude"]), double.parse(datas[x]["longitude"])),
                          infoWindow: InfoWindow(title: "${datas[x]["firstname"]}", snippet: "${datas[x]["lastname"]}"),
                          icon: _userPin == null ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(_userPin!),
                        ),
                      },
                    }
                  ]),
                  compassEnabled: false,
                  zoomControlsEnabled: true,

                  initialCameraPosition: CameraPosition(
                    target: LatLng(17.5784619, 120.3892525),
                    bearing: 8,
                    tilt: 0,
                    zoom: 15.00,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    print("onMapCreated");
                    _controller.complete(controller);
                    // controller.showMarkerInfoWindow(MarkerId("User"));
                  },
                  onCameraIdle: () {
                    print("idle");
                  },
                  onTap: (coordinates) async {
                    print(coordinates);
                    setState(() {

                    });
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              _mapType = MapType.normal;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(1000),
                                border: Border.all(color: _mapType == MapType.normal ? palettes.darkblue : Colors.transparent,width: 1.5),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage("https://kb.crmls.org/wp-content/uploads/2023/04/img_644707af297a9.png")
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              _mapType = MapType.satellite;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(1000),
                              border: Border.all(color: _mapType == MapType.satellite ? palettes.darkblue : Colors.transparent,width: 1.5),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                image: NetworkImage("https://global.discourse-cdn.com/flex016/uploads/inaturalist/original/3X/5/2/52bf35a9d808060c42ef19e0c029f49d7c51ed03.jpeg")
                              )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              _mapType = MapType.terrain;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(1000),
                                border: Border.all(color: _mapType == MapType.terrain ? palettes.darkblue : Colors.transparent,width: 1.5),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage("https://www.whiteclouds.com/wp-content/uploads/2023/04/Terrain-Maps-Idaho.jpg")
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              _mapType = MapType.hybrid;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(1000),
                                border: Border.all(color: _mapType == MapType.hybrid ? palettes.darkblue : Colors.transparent,width: 1.5),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                    image: NetworkImage("https://static.packt-cdn.com/products/9781849698863/graphics/B00100_03_03.jpg")
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.my_location,size: 25,),
                      onPressed: ()async{
                        final GoogleMapController controller = await _controller.future;
                        controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(17.5784619, 120.3892525),
                            bearing: 8,
                            tilt: 0,
                            zoom: 15.00,
                          ),
                        ));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
