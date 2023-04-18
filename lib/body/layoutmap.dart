import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/sitelist_model.dart';
import '../model/truckinstock_model.dart';
import '../state/truck_detail.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class LayoutMap extends StatefulWidget {
  const LayoutMap({super.key});

  @override
  State<LayoutMap> createState() => _LayoutMapState();
}

class _LayoutMapState extends State<LayoutMap> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerbitmap = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerbitmap_pic = BitmapDescriptor.defaultMarker;
  double partkingD_p1_x = 16.287312;
  double partkingD_p1_y = 102.786792;
  double partkingD_p2_x = 16.287317;
  double partkingD_p2_y = 102.786820;
  double partkingD_p3_x = 16.287302;
  double partkingD_p3_y = 102.786818;
  double partkingD_p4_x = 16.287297;
  double partkingD_p4_y = 102.786790;

  double partkingA_p1_x = 16.287187 + 0.000030;
  double partkingA_p1_y = 102.786877 + 0.000045;
  double partkingA_p2_x = 16.287177 + 0.000030;
  double partkingA_p2_y = 102.786905 + 0.000045;
  double partkingA_p3_x = 16.287162 + 0.000030;
  double partkingA_p3_y = 102.786903 + 0.000045;
  double partkingA_p4_x = 16.287172 + 0.000030;
  double partkingA_p4_y = 102.786875 + 0.000045;

  double partkingB_p1_x = 16.287312 - 0.000105;
  double partkingB_p1_y = 102.786792 + 0.000071;
  double partkingB_p2_x = 16.287317 - 0.000105;
  double partkingB_p2_y = 102.786820 + 0.000071;
  double partkingB_p3_x = 16.287302 - 0.000105;
  double partkingB_p3_y = 102.786818 + 0.000071;
  double partkingB_p4_x = 16.287297 - 0.000105;
  double partkingB_p4_y = 102.786790 + 0.000071;

  double partkingC_p1_x = 16.287187 + 0.000126;
  double partkingC_p1_y = 102.786877 - 0.000030;
  double partkingC_p2_x = 16.287177 + 0.000126;
  double partkingC_p2_y = 102.786905 - 0.000030;
  double partkingC_p3_x = 16.287162 + 0.000126;
  double partkingC_p3_y = 102.786903 - 0.000030;
  double partkingC_p4_x = 16.287172 + 0.000126;
  double partkingC_p4_y = 102.786875 - 0.000030;

  double partkingE_p1_x = 16.287312 - 0.000231;
  double partkingE_p1_y = 102.786792 - 0.000052;
  double partkingE_p2_x = 16.287317 - 0.000238;
  double partkingE_p2_y = 102.786820 - 0.000065;
  double partkingE_p3_x = 16.287302 - 0.000245;
  double partkingE_p3_y = 102.786818 - 0.000066;
  double partkingE_p4_x = 16.287297 - 0.000238;
  double partkingE_p4_y = 102.786790 - 0.000053;

  double partkingBuffer_p1_x = 16.287217 + 0.000060;
  double partkingBuffer_p1_y = 102.786922 + 0.000100;
  double partkingBuffer_p2_x = 16.287207 + 0.000060;
  double partkingBuffer_p2_y = 102.78695 + 0.000100;
  double partkingBuffer_p3_x = 16.287192 + 0.000060;
  double partkingBuffer_p3_y = 102.786948 + 0.000100;
  double partkingBuffer_p4_x = 16.287202 + 0.000060;
  double partkingBuffer_p4_y = 102.78692 + 0.000100;

  double offset_x_parkingarea = 0.000016;
  double offset_y_parkingarea = 0.0000023;

  double offset_x_parkingareaE = 0.0000025;
  double offset_y_parkingareaE = 0.000016;

  LatLng intialLocation = LatLng(16.287200, 102.786700);
  List<LatLng> polygonPoint_parkarea = [
    LatLng(16.287323, 102.786792),
    LatLng(16.287298, 102.786965),
    LatLng(16.286958, 102.786916),
    LatLng(16.287032, 102.786432),
    LatLng(16.287129, 102.786447),
    LatLng(16.287080, 102.786757),
  ];

  List<LatLng> polygonPoint_bufferArea = [
    LatLng(16.287287, 102.787015),
    LatLng(16.287278, 102.787060),
    LatLng(16.286610, 102.786965),
    LatLng(16.286620, 102.786917)
  ];

  List<List<LatLng>> polygonPoint = [];

  String? dropdownValue;
  List<String> list = [];
  List<TruckInStock> truckget_instock = [];

  int lineA = 12;
  int lineB = 10;
  int lineC = 16;
  int lineD = 16;
  int lineE = 16;
  int lineBuffer = 40;
  int totalLot = 0;

  List<Color> fillBG = [];
  List<String> indexTruckDataInPark = [];

  Set<Marker> markers = {};

  bool load = false;
  int totalLotWthBuf = 0;

  TextEditingController filter_serial = TextEditingController();
  TextEditingController filter_model = TextEditingController();

  @override
  void initState() {
    load = true;
    addMarkers();
    setState(() {
      totalLot = lineA + lineB + lineC + lineD + lineE + lineBuffer;
      totalLotWthBuf = lineA + lineB + lineC + lineD + lineE;
      for (var x = 0; x < totalLot; x++) {
        if (x >= totalLotWthBuf) {
          fillBG.add(Color.fromARGB(255, 255, 255, 255));
        } else {
          fillBG.add(Color.fromARGB(255, 211, 243, 199));
        }
        indexTruckDataInPark.add('null');
      }
    });
    getSiteList();

    // TODO: implement initState
    super.initState();
  }

  Future getSiteList() async {
    String apiPath =
        '${MyConstant.domain_warecondb}/select_sitelist.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}';

    await Dio().get(apiPath).then((value) {
      print(value);
      for (var datasite in jsonDecode(value.data)) {
        SiteListModel siteListModel = SiteListModel.fromMap(datasite);
        print('print site ==>>> ${siteListModel.location_name}');
        setState(() {
          list.add(siteListModel.location_name);
        });
      }
      setState(() {
        dropdownValue = list.first;
      });
    }).then((value) {
      gettruckbysite();
    });
  }

  Future gettruckbysite() async {
    int countGet = 0;
    int buffercount = totalLot - lineBuffer - 1;
    String apiPath =
        '${MyConstant.domain_warecondb}/select_truckbysite.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&site=$dropdownValue';
    await Dio().get(apiPath).then((value) {
      print('Print get data from site ${value}');
      if (value.toString() != 'error' && value.toString() != 'null') {
        truckget_instock.clear();
        for (var truck in jsonDecode(value.data)) {
          TruckInStock truckInStock = TruckInStock.fromMap(truck);
          countGet++;

          print(truckInStock.serial);
          print(truckInStock.parking_posi);

          setState(() {
            truckget_instock.add(truckInStock);
          });
        }
      }
    }).then((value) async {
      await processTruckDisplay(truckget_instock).then((value) {
        load = false;
      });
    });
  }

  Future processTruckDisplay(List<TruckInStock> truckreceive) async {
    setState(() {
      totalLot = lineA + lineB + lineC + lineD + lineE + lineBuffer;
      totalLotWthBuf = lineA + lineB + lineC + lineD + lineE;
      for (var x = 0; x < totalLot; x++) {
        if (x >= totalLotWthBuf) {
          fillBG[x] = Color.fromARGB(255, 255, 255, 255);
        } else {
          fillBG[x] = Color.fromARGB(255, 211, 243, 199);
        }
        indexTruckDataInPark[x] = 'null';
      }
    });

    markers.clear();
    markers
        .addLabelMarker(LabelMarker(
      label: "BufferArea",
      markerId: MarkerId("Buffer_Area"),
      position: LatLng(16.287278, 102.787060),
      backgroundColor: Color.fromARGB(255, 0, 74, 201),
    ))
        .then(
      (value) {
        setState(() {});
      },
    );

    markers
        .addLabelMarker(LabelMarker(
      label: "BTM_KhonkaenWH",
      markerId: MarkerId("WH_Area"),
      position: LatLng(16.287200, 102.786622),
      backgroundColor: Color.fromARGB(255, 159, 11, 3),
    ))
        .then(
      (value) {
        setState(() {});
      },
    );

    int countGetTruck = 0;
    int buffercount = totalLot - lineBuffer - 1;

    for (var truckInStockget in truckreceive) {
      if (truckInStockget.serial.contains(filter_serial.text) == true &&
          truckInStockget.model_item
                  .contains(filter_model.text.toUpperCase()) ==
              true) {
        countGetTruck++;

        if (truckInStockget.parking_posi.length > 0 &&
            truckInStockget.parking_posi != 'blank') {
          if (truckInStockget.parking_posi.contains('LatLng')) {
            print('Detect latlong ==> ${truckInStockget.parking_posi}');

            String latlngGet = truckInStockget.parking_posi;

            latlngGet = latlngGet.replaceAll('LatLng(', '');
            latlngGet = latlngGet.replaceAll(' ', '');
            latlngGet = latlngGet.replaceAll(')', '');

            double latitude = double.parse(latlngGet.split(',')[0]);
            double longitude = double.parse(latlngGet.split(',')[1]);

            LatLng getlalng = LatLng(latitude, longitude);

            print('Conver latlong ==> $getlalng');

            List<String> cacheImg = ['null', 'null', 'null', 'null'];

            String imgGet = truckInStockget.picture;

            if (imgGet.length > 0) {
              print('Image path => $imgGet');
              var imgGet_arr = imgGet.split(',');
              int count = 0;
              for (var data in imgGet_arr) {
                if (data.length > 0) {
                  print('Img file : $data');
                  setState(() {
                    cacheImg[count] = data;
                  });
                  count++;
                }
              }
            }

            markers
                .addLabelMarker(LabelMarker(
              onTap: () {
                buildDialogTruckinfo(truckInStockget, cacheImg);
              },
              textStyle: TextStyle(fontSize: 26, color: Colors.black),
              label: truckInStockget.serial,
              markerId: MarkerId('Point:${countGetTruck.toString()}'),
              position: getlalng,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ))
                .then(
              (value) {
                setState(() {});
              },
            );
          } else {
            int indexPosi = int.parse(truckInStockget.parking_posi) - 1;
            List<String> cacheImg = ['null', 'null', 'null', 'null'];
            setState(() {
              fillBG[indexPosi] = Color.fromARGB(255, 245, 95, 84);
              indexTruckDataInPark[indexPosi] = countGetTruck.toString();
              print('Position Get ==> ${polygonPoint[indexPosi][3]}');
            });

            String imgGet = truckInStockget.picture;

            if (imgGet.length > 0) {
              print('Image path => $imgGet');
              var imgGet_arr = imgGet.split(',');
              int count = 0;
              for (var data in imgGet_arr) {
                if (data.length > 0) {
                  print('Img file : $data');
                  setState(() {
                    cacheImg[count] = data;
                  });
                  count++;
                }
              }
            }

            markers
                .addLabelMarker(LabelMarker(
              onTap: () {
                buildDialogTruckinfo(truckInStockget, cacheImg);
              },
              textStyle: TextStyle(fontSize: 26, color: Colors.black),
              label: truckInStockget.serial,
              markerId: MarkerId('Point:${countGetTruck.toString()}'),
              position: polygonPoint[indexPosi][3],
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ))
                .then(
              (value) {
                setState(() {});
              },
            );
          }
        } else {
          buffercount++;
          List<String> cacheImg = ['null', 'null', 'null', 'null'];
          setState(() {
            fillBG[buffercount] = Color.fromARGB(255, 245, 95, 84);
            indexTruckDataInPark[buffercount] = countGetTruck.toString();
            print('Position Get ==> ${polygonPoint[buffercount][3]}');
          });

          String imgGet = truckInStockget.picture;

          if (imgGet.length > 0) {
            print('Image path => $imgGet');
            var imgGet_arr = imgGet.split(',');
            int count = 0;
            for (var data in imgGet_arr) {
              if (data.length > 0) {
                print('Img file : $data');
                setState(() {
                  cacheImg[count] = data;
                });
                count++;
              }
            }
          }

          markers
              .addLabelMarker(LabelMarker(
            onTap: () {
              buildDialogTruckinfo(truckInStockget, cacheImg);
            },
            textStyle: TextStyle(fontSize: 26, color: Colors.black),
            label: truckInStockget.serial,
            markerId: MarkerId('Point:${countGetTruck.toString()}'),
            position: polygonPoint[buffercount][3],
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ))
              .then(
            (value) {
              setState(() {});
            },
          );
        }
      }
    }
  }

  void buildDialogTruckinfo(TruckInStock truckData, List<String> imgCach) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: 300,
                    child: Container(
                      child: InkWell(
                        child: imgCach[0] == 'null'
                            ? Icon(Icons.image_outlined)
                            : imgCach[0].toString().contains('assets') == true
                                ? Image.asset(imgCach[0])
                                : FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image:
                                        '${MyConstant.domain_warecondb}showimgweb.php?url=${imgCach[0]}',
                                  ),
                      ),
                    )),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Serial:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Model:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Location:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Position:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'ModelYear:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Status:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Price:',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(
                            'Description:',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          truckData.serial,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          truckData.model_item,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          truckData.site,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 150,
                          height: 15,
                          child: AutoSizeText(
                            '${truckData.parking_posi}',
                            minFontSize: 14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          truckData.model_year,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          truckData.truck_status,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          truckData.price,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 150,
                          height: 30,
                          child: AutoSizeText(
                            '${truckData.note_info}',
                            minFontSize: 14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Container(
                height: 30,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 105, 105, 105),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TruckDetail(truckInStock: truckData),
                        ),
                      ).then((value) {
                        Navigator.pop(context);
                        setState(() {
                          fillBG.clear();
                          indexTruckDataInPark.clear();
                          for (var x = 0; x < totalLot; x++) {
                            fillBG.add(Color.fromARGB(255, 211, 243, 199));
                            indexTruckDataInPark.add('null');
                          }
                        });
                        gettruckbysite();
                      });
                    },
                    child: Text(
                      'More Detail',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )))
          ],
        );
      },
    );
  }

  Future<Null> addMarkers() async {
    setState(() {
      for (var x = 0; x < lineA; x++) {
        polygonPoint.add([
          LatLng(partkingA_p1_x - (offset_x_parkingarea * x),
              partkingA_p1_y - (offset_y_parkingarea * x)),
          LatLng(partkingA_p2_x - (offset_x_parkingarea * x),
              partkingA_p2_y - (offset_y_parkingarea * x)),
          LatLng(partkingA_p3_x - (offset_x_parkingarea * x),
              partkingA_p3_y - (offset_y_parkingarea * x)),
          LatLng(partkingA_p4_x - (offset_x_parkingarea * x),
              partkingA_p4_y - (offset_y_parkingarea * x)),
        ]);
      }
      for (var x = 0; x < lineB; x++) {
        polygonPoint.add([
          LatLng(partkingB_p1_x - (offset_x_parkingarea * x),
              partkingB_p1_y - (offset_y_parkingarea * x)),
          LatLng(partkingB_p2_x - (offset_x_parkingarea * x),
              partkingB_p2_y - (offset_y_parkingarea * x)),
          LatLng(partkingB_p3_x - (offset_x_parkingarea * x),
              partkingB_p3_y - (offset_y_parkingarea * x)),
          LatLng(partkingB_p4_x - (offset_x_parkingarea * x),
              partkingB_p4_y - (offset_y_parkingarea * x)),
        ]);
      }

      for (var x = 0; x < lineC; x++) {
        polygonPoint.add([
          LatLng(partkingC_p1_x - (offset_x_parkingarea * x),
              partkingC_p1_y - (offset_y_parkingarea * x)),
          LatLng(partkingC_p2_x - (offset_x_parkingarea * x),
              partkingC_p2_y - (offset_y_parkingarea * x)),
          LatLng(partkingC_p3_x - (offset_x_parkingarea * x),
              partkingC_p3_y - (offset_y_parkingarea * x)),
          LatLng(partkingC_p4_x - (offset_x_parkingarea * x),
              partkingC_p4_y - (offset_y_parkingarea * x)),
        ]);
      }

      for (var x = 0; x < lineD; x++) {
        polygonPoint.add([
          LatLng(partkingD_p1_x - (offset_x_parkingarea * x),
              partkingD_p1_y - (offset_y_parkingarea * x)),
          LatLng(partkingD_p2_x - (offset_x_parkingarea * x),
              partkingD_p2_y - (offset_y_parkingarea * x)),
          LatLng(partkingD_p3_x - (offset_x_parkingarea * x),
              partkingD_p3_y - (offset_y_parkingarea * x)),
          LatLng(partkingD_p4_x - (offset_x_parkingarea * x),
              partkingD_p4_y - (offset_y_parkingarea * x)),
        ]);
      }

      for (var x = 0; x < lineE; x++) {
        polygonPoint.add([
          LatLng(partkingE_p1_x + (offset_x_parkingareaE * x),
              partkingE_p1_y - (offset_y_parkingareaE * x)),
          LatLng(partkingE_p2_x + (offset_x_parkingareaE * x),
              partkingE_p2_y - (offset_y_parkingareaE * x)),
          LatLng(partkingE_p3_x + (offset_x_parkingareaE * x),
              partkingE_p3_y - (offset_y_parkingareaE * x)),
          LatLng(partkingE_p4_x + (offset_x_parkingareaE * x),
              partkingE_p4_y - (offset_y_parkingareaE * x)),
        ]);
      }

      for (var x = 0; x < lineBuffer; x++) {
        polygonPoint.add([
          LatLng(partkingBuffer_p1_x - (offset_x_parkingarea * x),
              partkingBuffer_p1_y - (offset_y_parkingarea * x)),
          LatLng(partkingBuffer_p2_x - (offset_x_parkingarea * x),
              partkingBuffer_p2_y - (offset_y_parkingarea * x)),
          LatLng(partkingBuffer_p3_x - (offset_x_parkingarea * x),
              partkingBuffer_p3_y - (offset_y_parkingarea * x)),
          LatLng(partkingBuffer_p4_x - (offset_x_parkingarea * x),
              partkingBuffer_p4_y - (offset_y_parkingarea * x)),
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              selectSite(screensize),
              IconButton(
                onPressed: () {
                  filter_dialog(context, screensize);
                },
                icon: Icon(
                  Icons.search_rounded,
                  color: Color.fromARGB(255, 70, 70, 70),
                ),
              )
            ],
          ),
          load == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: intialLocation,
                      zoom: 20,
                    ),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    markers: markers,
                    // circles: {
                    //   Circle(
                    //     circleId: CircleId("1"),
                    //     center: intialLocation,
                    //     radius: 5,
                    //     strokeWidth: 2,
                    //     fillColor: Color.fromARGB(38, 164, 222, 237),
                    //   ),
                    // },
                    polygons: {
                      Polygon(
                        polygonId: PolygonId("1"),
                        points: polygonPoint_parkarea,
                        strokeWidth: 1,
                        fillColor: Color.fromARGB(110, 233, 228, 228),
                      ),
                      Polygon(
                        polygonId: PolygonId("BufferArea"),
                        points: polygonPoint_bufferArea,
                        strokeWidth: 1,
                        strokeColor: Color.fromARGB(255, 13, 29, 247),
                        fillColor: Color.fromARGB(0, 11, 114, 240),
                      ),
                      ...makeTruckParkingArea(),
                    },
                  ),
                )
        ],
      ),
    );
  }

  void filter_dialog(BuildContext context, double screensize) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Filter data',
                          style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              filter_serial.clear();
                              filter_model.clear();
                            });
                            processTruckDisplay(truckget_instock);
                          },
                          child: Text(
                            'clear',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: screensize,
                    height: 35,
                    child: TextFormField(
                      onChanged: (value) {
                        print('change filter ==> ${filter_serial.text}');
                        processTruckDisplay(truckget_instock);
                      },
                      controller: filter_serial == null ? null : filter_serial,
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        errorStyle: TextStyle(color: Colors.red),
                        hintText: 'Serial',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 215, 214, 214)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: screensize,
                    height: 35,
                    child: TextFormField(
                      onChanged: (value) {
                        print('change filter ==> ${filter_model.text}');
                        processTruckDisplay(truckget_instock);
                      },
                      controller: filter_model == null ? null : filter_model,
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        errorStyle: TextStyle(color: Colors.red),
                        hintText: 'Model',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 215, 214, 214)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Polygon> makeTruckParkingArea() {
    List<Polygon> parklot = [];
    for (var x = 0; x < totalLot; x++) {
      parklot.add(Polygon(
        consumeTapEvents: true,
        polygonId: PolygonId(x.toString()),
        points: polygonPoint[x],
        strokeWidth: 1,
        geodesic: true,
        fillColor: fillBG[x],
        onTap: () {
          Flushbar(
            margin: EdgeInsets.only(bottom: 80),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            message: indexTruckDataInPark[x - 1] == 'null'
                ? 'พื้นที่วางหมายเลข $x'
                : 'Truck reffer ${truckget_instock[int.parse(indexTruckDataInPark[x - 1]) - 1].serial}',
            messageColor: Colors.black,
            duration: Duration(seconds: 5),
            leftBarIndicatorColor: Color.fromARGB(255, 215, 5, 5),
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Color.fromARGB(255, 216, 32, 8),
            ),
          ).show(context);

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     duration: Duration(seconds: 1),
          //     content: GestureDetector(
          //         onTap: () =>
          //             ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             indexTruckDataInPark[x - 1] == 'null'
          //                 ? Text('Empty Lot Point: $x')
          //                 : Text(
          //                     'Truck reffer=> ${indexTruckDataInPark[x - 1]}'),
          //             Icon(
          //               Icons.close_rounded,
          //               color: Colors.white,
          //             )
          //           ],
          //         )),
          //     behavior: SnackBarBehavior.floating,
          //     margin: EdgeInsets.only(bottom: 30.0, left: 10, right: 10),
          //   ),
          // );
        },
      ));
    }
    return parklot;
  }

  Container selectSite(double screensize) {
    return Container(
      width: screensize * 0.8,
      constraints: BoxConstraints(maxWidth: 800),
      child: DropdownButton(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(
          Icons.arrow_downward_rounded,
          size: 10,
        ),
        elevation: 16,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        underline: Container(
          height: 2,
          color: Color.fromARGB(255, 145, 15, 6),
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: GestureDetector(
                  onTap: () =>
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Not yet support this feature'),
                          Text('ฟังก์ชั่นนี้กำลังอยู่ในระหว่างพัฒนา')
                        ],
                      ),
                      Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      )
                    ],
                  )),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
            ),
          );
        },
        items: list
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Container(
                      alignment: Alignment.centerLeft, child: Text(value)),
                ))
            .toList(),
      ),
    );
  }
}
