import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

import '../model/sitelist_model.dart';
import '../model/truckinstock_model.dart';
import '../utility/myconstant.dart';

class TruckLocaliz extends StatefulWidget {
  final TruckInStock truckInStock;
  const TruckLocaliz({super.key, required this.truckInStock});

  @override
  State<TruckLocaliz> createState() => _TruckLocalizState();
}

class _TruckLocalizState extends State<TruckLocaliz> {
  TruckInStock? truckinfothispage;
  LatLng intialLocation = LatLng(16.287200, 102.786700);
  bool load = false;
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerbitmap = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = {};

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

  String? dropdownValue;
  List<String> list = [];

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

  int lineA = 12;
  int lineB = 10;
  int lineC = 16;
  int lineD = 16;
  int lineE = 16;
  int lineBuffer = 40;
  int totalLot = 0;
  int totalLotWthBuf = 0;

  List<Color> fillBG = [];
  List<String> indexTruckDataInPark = [];
  List<List<LatLng>> polygonPoint = [];

  String saveLatLngpoint = '';

  @override
  void initState() {
    truckinfothispage = widget.truckInStock;
    getsiteinfo();
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
    // TODO: implement initState
    super.initState();
  }

  Future<Null> getsiteinfo() async {
    setState(() {
      load = true;
    });
    markers.clear();
    markers
        .addLabelMarker(LabelMarker(
      label: "BTM_KhonkaenWH",
      markerId: MarkerId("idString"),
      position: LatLng(16.287200, 102.786622),
      backgroundColor: Color.fromARGB(255, 159, 11, 3),
    ))
        .then(
      (value) {
        setState(() {});
      },
    );

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
      gettruckinfo();
      setState(() {
        load = false;
      });
    });
  }

  Future<Null> gettruckinfo() async {
    int countGet = 0;
    int buffercount = totalLot - lineBuffer - 1;
    String apiPath =
        '${MyConstant.domain_warecondb}/select_truckbyserial.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${truckinfothispage!.serial}';
    await Dio().get(apiPath).then((value) {
      print(value);
      if (value.toString() != 'error') {
        // truckget_instock.clear();
        for (var truck in jsonDecode(value.data)) {
          TruckInStock truckInStock = TruckInStock.fromMap(truck);
          countGet++;
          print(truckInStock.serial);
          print(truckInStock.parking_posi);
          print(truckInStock.site);

          if (truckInStock.parking_posi.length > 0 &&
              truckInStock.parking_posi != 'blank' &&
              truckInStock.site == 'BT_Khonkaen') {
            if (truckInStock.parking_posi.contains('LatLng')) {
              print('Detect latlong ==> ${truckInStock.parking_posi}');

              String latlngGet = truckInStock.parking_posi;

              latlngGet = latlngGet.replaceAll('LatLng(', '');
              latlngGet = latlngGet.replaceAll(' ', '');
              latlngGet = latlngGet.replaceAll(')', '');

              double latitude = double.parse(latlngGet.split(',')[0]);
              double longitude = double.parse(latlngGet.split(',')[1]);

              LatLng getlalng = LatLng(latitude, longitude);

              print('Conver latlong ==> $getlalng');
              markers
                  .addLabelMarker(LabelMarker(
                onTap: () {},
                textStyle: TextStyle(fontSize: 26, color: Colors.black),
                label: truckInStock.serial,
                markerId: MarkerId('Point:${countGet.toString()}'),
                position: getlalng,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                draggable: true,
                onDragEnd: (value) {
                  print(value);
                  saveLatLngpoint = value.toString();
                },
              ))
                  .then(
                (value) {
                  setState(() {});
                },
              );
            } else {
              int indexPosi = int.parse(truckInStock.parking_posi) - 1;
              setState(() {
                fillBG[indexPosi] = Color.fromARGB(255, 245, 95, 84);
                indexTruckDataInPark[indexPosi] = countGet.toString();
                print('Position Get ==> ${polygonPoint[indexPosi][3]}');
                saveLatLngpoint = polygonPoint[indexPosi][3].toString();
              });

              markers
                  .addLabelMarker(LabelMarker(
                onTap: () {},
                textStyle: TextStyle(fontSize: 26, color: Colors.black),
                label: truckInStock.serial,
                markerId: MarkerId('Point:${countGet.toString()}'),
                position: polygonPoint[indexPosi][3],
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                draggable: true,
                onDragEnd: (value) {
                  print(value);
                  saveLatLngpoint = value.toString();
                },
              ))
                  .then(
                (value) {
                  setState(() {});
                },
              );
            }
          } else {
            buffercount++;
            setState(() {
              fillBG[buffercount] = Color.fromARGB(255, 245, 95, 84);
              indexTruckDataInPark[buffercount] = countGet.toString();
              print('Position Get ==> ${polygonPoint[buffercount][3]}');
            });

            markers
                .addLabelMarker(LabelMarker(
              textStyle: TextStyle(fontSize: 26, color: Colors.black),
              label: truckInStock.serial,
              markerId: MarkerId('Point:${countGet.toString()}'),
              position: polygonPoint[buffercount][3],
              backgroundColor: Color.fromARGB(255, 182, 231, 255),
              draggable: true,
              onDragEnd: (value) {
                print(value);
                saveLatLngpoint = value.toString();
              },
            ))
                .then(
              (value) {
                setState(() {});
              },
            );
          }
        }
      }
    }).then((value) {
      load = false;
    });
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
      print('sfasfa');

      for (var x = 0; x < lineBuffer; x++) {
        print('sfasfa');
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'ระบุจุดจัดเก็บด้วย Google map',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 5),
                width: 100,
                height: 35,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 252, 250),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    onPressed: () async {
                      String update_serial =
                          truckinfothispage!.serial.toString();
                      String update_site = truckinfothispage!.site.toString();
                      String update_parkposi = saveLatLngpoint;
                      print('LatLong ==> ${update_parkposi}');

                      String apiPath =
                          '${MyConstant.domain_warecondb}/update_truckStoragepoint.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=$update_serial&site=$update_site&parkposi=$update_parkposi';
                      await Dio().get(apiPath).then((value) {
                        print(value);
                        if (value.toString() == 'successfully') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: GestureDetector(
                                  onTap: () => ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar(),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Update Storage point successfully'),
                                      Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                  bottom: 30.0, left: 10, right: 10),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: GestureDetector(
                                  onTap: () => ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar(),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Fail to update Storage point'),
                                      Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                  bottom: 30.0, left: 10, right: 10),
                            ),
                          );
                        }
                      });
                    },
                    icon: Icon(
                      Icons.save_alt_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      'บันทึก',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          selectSite(screensize),
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
