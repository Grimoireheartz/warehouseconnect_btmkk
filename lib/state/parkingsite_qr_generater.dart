import 'dart:convert';

import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/sitelist_model.dart';
import '../utility/myconstant.dart';

class ParkingQRGen extends StatefulWidget {
  const ParkingQRGen({super.key});

  @override
  State<ParkingQRGen> createState() => _ParkingQRGenState();
}

class _ParkingQRGenState extends State<ParkingQRGen> {
  List<String> list = [];
  bool load = false;
  String? dropdownValue;
  String? dropdownPrkPosiValue;
  List<List<String>> parkinglot_posi = [];
  int indexSite = 0;
  String generateDataInfo = '';
  @override
  void initState() {
    getSiteList();
    // TODO: implement initState
    super.initState();
  }

  Future getSiteList() async {
    setState(() {
      load = true;
    });

    String apiPath =
        '${MyConstant.domain_warecondb}/select_sitelist.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}';

    await Dio().get(apiPath).then((value) {
      print(value);
      for (var datasite in jsonDecode(value.data)) {
        SiteListModel siteListModel = SiteListModel.fromMap(datasite);
        print('print site ==>>> ${siteListModel.location_name}');

        List<String> parking_arr = ['blank'];
        if (siteListModel.parking_lot.length > 0) {
          if (int.parse(siteListModel.parking_lot) > 0) {
            for (var x = 1; x <= int.parse(siteListModel.parking_lot); x++) {
              parking_arr.add(x.toString());
            }
          }
        }
        setState(() {
          list.add(siteListModel.location_name);
          if (parking_arr.length > 0) {
            parkinglot_posi.add(parking_arr);
          }
        });
      }
      setState(() {
        dropdownValue = list.first;
        dropdownPrkPosiValue = parkinglot_posi.first.first;
      });
    }).then((value) {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Parking QR Generater'),
      ),
      body: load == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      width: screensize * 0.4,
                      constraints: BoxConstraints(maxWidth: 80),
                      child: Image.asset(MyConstant.applogo_rmbg),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: screensize * 0.8,
                        child: Text(
                          'Warehouse Name',
                          style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                    selectSite(screensize),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: screensize * 0.8,
                        child: Text(
                          'Storage position',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        )),
                    selectPrkposi(screensize),
                    SizedBox(
                      height: 10,
                    ),
                    generateDataInfo.length > 0
                        ? Container(
                            width: screensize * 0.8,
                            child: Column(
                              children: [
                                CustomPaint(
                                  painter: QrPainter(
                                      data: generateDataInfo,
                                      options: const QrOptions(
                                          shapes: QrShapes(
                                              darkPixel:
                                                  QrPixelShapeRoundCorners(
                                                      cornerFraction: .5),
                                              frame: QrFrameShapeRoundCorners(
                                                  cornerFraction: .25),
                                              ball: QrBallShapeRoundCorners(
                                                  cornerFraction: .25)),
                                          colors: QrColors(
                                              dark: QrColorLinearGradient(
                                                  colors: [
                                                Color.fromARGB(255, 255, 0, 0),
                                                Color.fromARGB(255, 26, 26, 26),
                                              ],
                                                  orientation:
                                                      GradientOrientation
                                                          .leftDiagonal)))),
                                  size: const Size(350, 350),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Data: $generateDataInfo",
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  dropdownPrkPosiValue.toString(),
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 235, 2, 2)),
                                ),
                                // Displat position
                                Text(
                                  'Storage position',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
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
            int index1 = list.indexWhere(((site) => site == value));

            indexSite = index1;
            dropdownPrkPosiValue = parkinglot_posi[indexSite][0];
          });
          generateQR();
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

  Container selectPrkposi(double screensize) {
    return Container(
      width: screensize * 0.8,
      constraints: BoxConstraints(maxWidth: 800),
      child: DropdownButton(
        isExpanded: true,
        value: dropdownPrkPosiValue,
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
            dropdownPrkPosiValue = value!;
          });
          generateQR();
        },
        items: parkinglot_posi[indexSite]
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Container(
                      alignment: Alignment.centerLeft, child: Text(value)),
                ))
            .toList(),
      ),
    );
  }

  Future<Null> generateQR() async {
    String sitename = dropdownValue.toString();
    String parkposition = dropdownPrkPosiValue.toString();
    print('site=>${sitename} , posi=> $parkposition');

    if (parkposition != 'blank') {
      setState(() {
        generateDataInfo =
            'warehouseconnect_qrprkposi?site=${sitename}&parkposi=${parkposition}';
      });
    } else {
      generateDataInfo = '';
    }
  }
}
