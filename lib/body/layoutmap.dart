import 'dart:async';

import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LayoutMap extends StatefulWidget {
  const LayoutMap({super.key});

  @override
  State<LayoutMap> createState() => _LayoutMapState();
}

class _LayoutMapState extends State<LayoutMap> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerbitmap = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerbitmap_pic = BitmapDescriptor.defaultMarker;
  double partking_p1_x = 16.287308;
  double partking_p1_y = 102.786792;
  double partking_p2_x = 16.287315;
  double partking_p2_y = 102.786825;
  double partking_p3_x = 16.287298;
  double partking_p3_y = 102.786822;
  double partking_p4_x = 16.287292;
  double partking_p4_y = 102.786790;

  double offset_x_parkingarea = 0.000018;
  double offset_y_parkingarea = 0.000003;

  LatLng intialLocation = LatLng(16.287200, 102.786622);
  List<LatLng> polygonPoint_parkarea = [
    LatLng(16.287323, 102.786792),
    LatLng(16.287305, 102.786928),
    LatLng(16.286963, 102.786876),
    LatLng(16.287032, 102.786432),
    LatLng(16.287104, 102.786443),
    LatLng(16.287055, 102.786753),
  ];

  List<LatLng> polygonPoint = [];
  List<LatLng> polygonPoint_2 = [];

  @override
  void initState() {
    addMarkers();
    // TODO: implement initState
    super.initState();
  }

  Future<Null> addMarkers() async {
    setState(() {
      polygonPoint = [
        LatLng(partking_p1_x, partking_p1_y),
        LatLng(partking_p2_x, partking_p2_y),
        LatLng(partking_p3_x, partking_p3_y),
        LatLng(partking_p4_x, partking_p4_y),
      ];
      polygonPoint_2 = [
        LatLng(partking_p1_x - offset_x_parkingarea,
            partking_p1_y - offset_y_parkingarea),
        LatLng(partking_p2_x - offset_x_parkingarea,
            partking_p2_y - offset_y_parkingarea),
        LatLng(partking_p3_x - offset_x_parkingarea,
            partking_p3_y - offset_y_parkingarea),
        LatLng(partking_p4_x - offset_x_parkingarea,
            partking_p4_y - offset_y_parkingarea),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: intialLocation,
                zoom: 19.5,
              ),
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: MarkerId("1"),
                  position: intialLocation,
                  icon: markerbitmap_pic,
                ),
              },
              circles: {
                Circle(
                  circleId: CircleId("1"),
                  center: intialLocation,
                  radius: 5,
                  strokeWidth: 2,
                  fillColor: Color.fromARGB(38, 164, 222, 237),
                ),
              },
              polygons: {
                Polygon(
                  polygonId: PolygonId("1"),
                  points: polygonPoint,
                  strokeWidth: 1,
                  fillColor: Color.fromARGB(111, 246, 156, 156),
                ),
                Polygon(
                  polygonId: PolygonId("1"),
                  points: polygonPoint_parkarea,
                  strokeWidth: 1,
                  fillColor: Color.fromARGB(110, 233, 228, 228),
                ),
                Polygon(
                  polygonId: PolygonId("1"),
                  points: polygonPoint_2,
                  strokeWidth: 1,
                  fillColor: Color.fromARGB(111, 246, 156, 156),
                ),
              },
            ),
          )
        ],
      ),
    );
  }
}
