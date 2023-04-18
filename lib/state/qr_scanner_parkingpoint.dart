import 'dart:io' show Platform;

import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';

import '../utility/myconstant.dart';

class ScanQRParkPoint extends StatefulWidget {
  final TruckInStock truckInStock;
  const ScanQRParkPoint({super.key, required this.truckInStock});

  @override
  State<ScanQRParkPoint> createState() => _ScanQRParkPointState();
}

class _ScanQRParkPointState extends State<ScanQRParkPoint> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool findData = false;
  TruckInStock? trucToUpdateDetail;

  @override
  void initState() {
    trucToUpdateDetail = widget.truckInStock;
    // TODO: implement initState
    super.initState();
  }

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Scan Storage Location point'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                      ],
                    )
                  : Text('No Data'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        // print('sfasfsfa ${scanData.code.toString()}');
        result = scanData;
      });

      if (findData == false) {
        if (scanData.code.toString().length > 2) {
          String siteToAdd = '';
          String serailToAdd = '';
          String posiToAdd = '';
          if (scanData.code.toString().contains('warehouseconnect_qrprkposi')) {
            setState(() {
              findData = true;
            });
            siteToAdd = scanData.code
                .toString()
                .split('site=')[1]
                .split('&parkposi=')[0];
            posiToAdd = scanData.code
                .toString()
                .split('site=')[1]
                .split('&parkposi=')[1];
            print('Site to add => ${siteToAdd}');
            print('Posi to add => ${posiToAdd}');

            buildDialogTruckStock(trucToUpdateDetail!, siteToAdd, posiToAdd);
          }
        }
      }
    });
  }

  void buildDialogTruckStock(TruckInStock truckData, String wh, String point) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Update Storage Point',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                          'Warehouse:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Storage Point:',
                          style: TextStyle(fontSize: 14),
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
                          wh,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          point,
                          style: TextStyle(fontSize: 14),
                        ),
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
                    onPressed: () async {
                      String update_serial = truckData.serial.toString();
                      String update_site = wh;
                      String update_parkposi = point;
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
                          Navigator.pop(context);
                          Navigator.pop(context);
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
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text(
                      'Update Storage Point',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )))
          ],
        );
      },
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
