import 'dart:async';

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
  LatLng intialLocation = LatLng(13.717254, 100.662794);
  List<LatLng> polygonPoint = [
    LatLng(13.717472, 100.662687),
    LatLng(13.717479, 100.662848),
    LatLng(13.717039, 100.662868),
    LatLng(13.717034, 100.662708),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: intialLocation,
                zoom: 25,
              ),
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: MarkerId("1"),
                  position: intialLocation,
                  icon: markerbitmap,
                ),
              },
              circles: {
                Circle(
                  circleId: CircleId("1"),
                  center: intialLocation,
                  radius: 400,
                  strokeWidth: 2,
                  fillColor: Color.fromARGB(38, 164, 222, 237),
                ),
              },
              polygons: {
                Polygon(
                    polygonId: PolygonId("1"),
                    points: polygonPoint,
                    strokeWidth: 1,
                    fillColor: Color.fromARGB(111, 246, 156, 156)),
              },
            ),
          )
        ],
      ),
    );
  }
}
