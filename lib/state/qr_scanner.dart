import 'dart:convert';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:btm_warehouseconnect/model/truckinfo_model.dart';
import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:btm_warehouseconnect/state/add_truck_fromscan.dart';
import 'package:btm_warehouseconnect/state/truck_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'dart:io' show Platform;

import '../model/sitelist_model.dart';
import '../utility/myconstant.dart';

class QRscanner extends StatefulWidget {
  const QRscanner({super.key});

  @override
  State<QRscanner> createState() => _QRscannerState();
}

class _QRscannerState extends State<QRscanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String oldSerial = '';
  bool findData = false;
  String searchLoad = 'Not detect';
  String nothingString = 'detect';

  @override
  void initState() {
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
        title: Text('QR code, Barcode Scanner'),
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
                        Text(searchLoad),
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
          String serialToFind = scanData.code.toString();
          if (scanData.code.toString().contains('warehouseconnectbybtm')) {
            serialToFind = scanData.code.toString().split('sn=')[1];
          }
          setState(() {
            searchLoad = 'Loading......find:${serialToFind}';
          });

          if (oldSerial != serialToFind) {
            setState(() {
              findData = true;
            });
            String apiPath =
                '${MyConstant.domain_warecondb}/select_truckbyserial.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${serialToFind}';

            await Dio().get(apiPath).then((value) async {
              print('$value');
              if (value.toString() != 'null') {
                for (var data in jsonDecode(value.data)) {
                  TruckInStock truckData = TruckInStock.fromMap(data);
                  setState(() {
                    findData = true;
                  });
                  print('find truck info ${truckData.model_item}');

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TruckDetail(truckInStock: truckData),
                    ),
                  );

                  // buildDialogTruckStock(truckData);
                }
              } else {
                serialToFind = serialToFind.replaceAll(' ', '');
                if (serialToFind.length > 8) {
                  serialToFind = serialToFind.substring(1, 8);
                }
                String apiPath =
                    '${MyConstant.domain_warecondb}/select_truckinfo.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=$serialToFind';

                print('API_Path : ${apiPath}');

                await Dio().get(apiPath).then((value) {
                  print('Information with NAV Data ==> ${value}');
                  if (value.toString() != 'null') {
                    print('is Mull');
                    for (var data in jsonDecode(value.data)) {
                      TruckInfoModel truckInfoModel =
                          TruckInfoModel.fromMap(data);

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTruckFromScan(truckDetail: truckInfoModel),
                        ),
                      );
                    }
                  } else {
                    Flushbar(
                      margin: EdgeInsets.only(bottom: 20),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      message: 'Not find with this data',
                      messageColor: Colors.black,
                      duration: Duration(seconds: 10),
                      leftBarIndicatorColor: Color.fromARGB(255, 215, 5, 5),
                      icon: Icon(
                        Icons.info_outline,
                        size: 28.0,
                        color: Color.fromARGB(255, 216, 32, 8),
                      ),
                    ).show(context);
                    setState(() {
                      findData = false;
                    });
                  }
                });
              }
            });
          }

          oldSerial = serialToFind;
        }
      }
    });
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
