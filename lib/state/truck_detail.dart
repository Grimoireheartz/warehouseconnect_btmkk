import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:btm_warehouseconnect/state/datasheet_viewer.dart';
import 'package:btm_warehouseconnect/state/qr_generator.dart';
import 'package:btm_warehouseconnect/state/qr_scanner_parkingpoint.dart';
import 'package:btm_warehouseconnect/state/truck_localizationwthmap.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/sitelist_model.dart';
import '../utility/myconstant.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class TruckDetail extends StatefulWidget {
  final TruckInStock truckInStock;
  const TruckDetail({super.key, required this.truckInStock});

  @override
  State<TruckDetail> createState() => _TruckDetailState();
}

class _TruckDetailState extends State<TruckDetail> {
  TruckInStock? truckDetail;
  final formKey = GlobalKey<FormState>();
  TextEditingController truckData_serial = TextEditingController();
  TextEditingController truckData_model = TextEditingController();
  TextEditingController truckData_location = TextEditingController();
  TextEditingController truckData_status = TextEditingController();
  TextEditingController truckData_modelYear = TextEditingController();
  TextEditingController truckData_price = TextEditingController();
  TextEditingController truckData_noteinfo = TextEditingController();
  TextEditingController truckData_parkingposition = TextEditingController();
  TextEditingController newtruckImg_select = TextEditingController();

  List<String> sitelist = [];
  List<List<String>> parkinglot_posi = [];
  int indexParkSite = 0;

  String? dropdownValue;

  List<File?> img_files = [];

  int showimgIndex = 0;

  File? file;

  List<String> cacheImg = ['null', 'null', 'null', 'null'];

  List<Uint8List> webImageArr = [for (var x = 0; x <= 2; x++) Uint8List(8)];

  bool load = true;
  int changeSite = 0;

  List<String> listImgName = [];
  List<String> listImgFile = [];
  String? dropdownValue_imgNewtruck;

  @override
  void initState() {
    for (var i = 0; i < 4; i++) {
      img_files.add(null);
    }
    truckDetail = widget.truckInStock;
    setState(() {
      truckData_serial.text = truckDetail!.serial;
      truckData_model.text = truckDetail!.model_item;
      truckData_location.text = truckDetail!.site;
      truckData_status.text = truckDetail!.truck_status;
      truckData_modelYear.text = truckDetail!.model_year;
      truckData_price.text = truckDetail!.price;
      truckData_noteinfo.text = truckDetail!.note_info;
    });
    getSiteList();
    for (var imgData in MyConstant.imgDesc_NewTruck) {
      setState(() {
        listImgName.add(imgData);
      });
    }
    for (var imgData in MyConstant.img_NewTruck) {
      setState(() {
        listImgFile.add(imgData);
      });
    }
    setState(() {
      newtruckImg_select.text = listImgFile.first;
      dropdownValue_imgNewtruck = listImgName.first;
    });

    // TODO: implement initState
    super.initState();
  }

  Future gettruckdata_byserial() async {
    String apiPath =
        '${MyConstant.domain_warecondb}/select_truckbyserial.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${truckDetail!.serial}';

    await Dio().get(apiPath).then((value) {
      if (value.toString().length > 0) {
        for (var data in jsonDecode(value.data)) {
          TruckInStock truckInStock = TruckInStock.fromMap(data);
          // print('Set new model => ${truckInStock.site}');

          setState(() {
            truckData_model.text = truckInStock.model_item;
            truckData_location.text = truckInStock.site;
            truckData_status.text = truckInStock.truck_status;
            truckData_modelYear.text = truckInStock.model_year;
            truckData_price.text = truckInStock.price;
            truckData_noteinfo.text = truckInStock.note_info;
            truckInStock.parking_posi.length == 0 ||
                    truckInStock.parking_posi.contains('LatLng') == true
                ? truckData_parkingposition.text = 'blank'
                : truckData_parkingposition.text = truckInStock.parking_posi;
          });
          String imgGet = truckInStock.picture;
          for (var x = 0; x < 4; x++) {
            cacheImg[x] = 'null';
          }

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
          print('Site list => $sitelist');
          print('Truck on site ${truckData_location.text}');
          int index1 =
              sitelist.indexWhere(((site) => site == truckData_location.text));
          print('index of site ==> ${index1}');
          setState(() {
            indexParkSite = index1;
          });
        }
      }
    }).then((value) {
      setState(() {
        load = false;
      });
    });
  }

  Future getSiteList() async {
    String apiPath =
        '${MyConstant.domain_warecondb}/select_sitelist.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}';

    await Dio().get(apiPath).then((value) {
      print(value);
      for (var datasite in jsonDecode(value.data)) {
        SiteListModel siteListModel = SiteListModel.fromMap(datasite);
        print('print site ==>>> ${siteListModel.location_name}');
        print('Num of parking lodt =>> ${siteListModel.parking_lot}');
        List<String> parking_arr = ['blank'];
        if (siteListModel.parking_lot.length > 0) {
          if (int.parse(siteListModel.parking_lot) > 0) {
            for (var x = 1; x <= int.parse(siteListModel.parking_lot); x++) {
              parking_arr.add(x.toString());
            }
          }
        }
        setState(() {
          sitelist.add(siteListModel.location_name);
          if (parking_arr.length > 0) {
            parkinglot_posi.add(parking_arr);
          }
        });
      }
      setState(() {
        dropdownValue = sitelist.first;
      });
      print('Location posi ==> ${parkinglot_posi}');
    }).then((value) {
      gettruckdata_byserial();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Truck Details'),
        actions: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 35,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScanQRParkPoint(truckInStock: truckDetail!),
                          ),
                        ).then((value) => gettruckdata_byserial());
                      },
                      icon: Icon(
                        Icons.qr_code_scanner_rounded,
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    child: Text(
                      'STR Point',
                      style: TextStyle(fontSize: 10),
                    ),
                  )
                ],
              ),
              PopupMenuButton<Menu>(
                icon: Icon(
                  Icons.more_vert_outlined,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                offset: Offset(0, 50),
                onSelected: (Menu item) async {
                  if (item.name == 'itemOne') {
                    print('choose item => ${item.name}');
                    deleteTruckDialog(context);
                  } else if (item.name == 'itemTwo') {
                    print('choose item => ${item.name}');
                    setNewTruckImg();
                  } else if (item.name == 'itemThree') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TruckLocaliz(truckInStock: truckDetail!)),
                    );
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<Menu>>[
                  const PopupMenuItem(
                    child: Text(
                      'Delete Truck',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: Menu.itemOne,
                  ),
                  const PopupMenuItem(
                    child: Text(
                      'Use NewTruck Img',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: Menu.itemTwo,
                  ),
                  const PopupMenuItem(
                    child: Text(
                      'ระบุตำแหน่งด้วย Google map',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: Menu.itemThree,
                  ),
                  // const PopupMenuItem(
                  //   child: Text('Delete'),
                  //   value: Menu.itemTwo,
                  // ),
                ],
              )
            ],
          )
        ],
      ),
      body: load
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    // Container(
                    //   width: screensize,
                    //   height: 400,
                    //   child: ModelViewer(src: 'assets/forklift.glb'),
                    // ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 900),
                      width: screensize,
                      height: 400,
                      child: imgShowWidget(showimgIndex),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: screensize * 0.9,
                      constraints: BoxConstraints(maxWidth: 900),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showimgIndex = 0;
                                });
                              },
                              child: cacheImg[0] == 'null'
                                  ? Icon(Icons.image_outlined)
                                  : cacheImg[0].toString().contains('assets') ==
                                          true
                                      ? Image.asset(cacheImg[0])
                                      : FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              '${MyConstant.domain_warecondb}showimgweb.php?url=${cacheImg[0]}',
                                        ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showimgIndex = 1;
                                });
                              },
                              child: cacheImg[1] == 'null'
                                  ? Icon(Icons.image_outlined)
                                  : cacheImg[1].toString().contains('assets') ==
                                          true
                                      ? Image.asset(cacheImg[1])
                                      : FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              '${MyConstant.domain_warecondb}showimgweb.php?url=${cacheImg[1]}',
                                        ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showimgIndex = 2;
                                });
                              },
                              child: cacheImg[2] == 'null'
                                  ? Icon(Icons.image_outlined)
                                  : cacheImg[2].toString().contains('assets') ==
                                          true
                                      ? Image.asset(cacheImg[2])
                                      : FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              '${MyConstant.domain_warecondb}showimgweb.php?url=${cacheImg[2]}',
                                        ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showimgIndex = 3;
                                });
                              },
                              child: cacheImg[3] == 'null'
                                  ? Icon(Icons.image_outlined)
                                  : cacheImg[3].toString().contains('assets') ==
                                          true
                                      ? Image.asset(cacheImg[3])
                                      : FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              '${MyConstant.domain_warecondb}showimgweb.php?url=${cacheImg[3]}',
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 900),
                      padding: EdgeInsets.all(8),
                      width: screensize * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        // gradient: LinearGradient(
                        //   begin: Alignment.topRight,
                        //   end: Alignment.bottomLeft,
                        //   colors: [
                        //     Color.fromARGB(255, 201, 201, 201),
                        //     Color.fromARGB(255, 255, 255, 255),
                        //   ],
                        // ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 81, 81, 81)
                                .withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'General Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
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
                                    popEditform(context, screensize);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Serial:'),
                                  Text('Model:'),
                                  Text('Location:'),
                                  Text('Parking point:'),
                                  Text('Status:'),
                                  Text('Model Year:'),
                                  Text('Price:'),
                                  Text('Description:')
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(truckDetail!.serial),
                                    Text('${trimModel(truckData_model.text)}'),
                                    Text(truckData_location.text),
                                    SizedBox(
                                      width: 120,
                                      height: 15,
                                      child: AutoSizeText(
                                        '${truckData_parkingposition.text}',
                                        minFontSize: 14,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Text(truckData_status.text),
                                    Text(truckData_modelYear.text),
                                    Text(truckData_price.text),
                                    Text(truckData_noteinfo.text),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        // gradient: LinearGradient(
                        //   begin: Alignment.topRight,
                        //   end: Alignment.bottomLeft,
                        //   colors: [
                        //     Color.fromARGB(255, 201, 201, 201),
                        //     Color.fromARGB(255, 255, 255, 255),
                        //   ],
                        // ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 81, 81, 81)
                                .withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: screensize * 0.9,
                      height: 30,
                      constraints: BoxConstraints(maxWidth: 900),
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QRgenerator(truckInStock: truckDetail!),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.qr_code_rounded,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Generate QR code information',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 81, 81, 81)
                                .withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: screensize * 0.9,
                      height: 30,
                      constraints: BoxConstraints(maxWidth: 900),
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DatasheetViewer(datasheetmodel: 'rre'),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.insert_drive_file_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Data sheet',
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void deleteTruckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Are you sure to delete this truck from app?',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('คุณแน่ใจใช่ไหมที่จะต้องการลบข้อมูลของรถยกคันนี้')
                  ],
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  String apiPath =
                      '${MyConstant.domain_warecondb}/delete_truckinDB.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${truckData_serial.text}';
                  await Dio().get(apiPath).then((value) {
                    print(value);
                    if (value.toString() == 'delete_successfully') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delete successfully'),
                                  Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                              bottom: 40.0, left: 10, right: 10),
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Error!! Please try again'),
                                  Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                              bottom: 40.0, left: 10, right: 10),
                        ),
                      );
                    }
                  });
                },
                child: Text('Confirm'))
          ],
        );
      },
    );
  }

  void popEditform(BuildContext context, double screensize) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: AlertDialog(
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    String update_serial = truckData_serial.text;
                    String update_model = truckData_model.text;
                    String update_site = truckData_location.text;
                    String update_status = truckData_status.text;
                    String update_modelYear = truckData_modelYear.text;
                    String update_price = truckData_price.text;
                    String update_noteinfo = truckData_noteinfo.text;
                    String update_parkposi = truckData_parkingposition.text;

                    String apiPath =
                        '${MyConstant.domain_warecondb}/update_truckinfo.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=$update_serial&model=$update_model&site=$update_site&status=$update_status&modelyear=$update_modelYear&price=$update_price&note=$update_noteinfo&parkposi=$update_parkposi';
                    await Dio().get(apiPath).then((value) {
                      print(value);
                      if (value.toString() == 'successfully') {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: GestureDetector(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Update successfully'),
                                    Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                bottom: 40.0, left: 10, right: 10),
                          ),
                        );
                        setState(() {
                          changeSite = 0;
                        });
                        gettruckdata_byserial();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: GestureDetector(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Error to update.'),
                                    Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                bottom: 40.0, left: 10, right: 10),
                          ),
                        );
                      }
                    });
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 79, 78, 78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
            content: SingleChildScrollView(
              child: Container(
                width: screensize,
                constraints: BoxConstraints(maxWidth: 900),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Edit truck information',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Serial:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_serial(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Model:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_model(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Site:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_siteselect(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Parking Position:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_parklotselect(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Status:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_status(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Model Year:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_modelyear(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Price:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_price(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Note:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_noteinfo(),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextFormField editForm_noteinfo() {
    return TextFormField(
      maxLines: 3,
      controller: truckData_noteinfo == null ? null : truckData_noteinfo,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Description',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
    );
  }

  TextFormField editForm_price() {
    return TextFormField(
      controller: truckData_price == null ? null : truckData_price,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Price',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
    );
  }

  TextFormField editForm_modelyear() {
    return TextFormField(
      controller: truckData_modelYear == null ? null : truckData_modelYear,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Model Year',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
    );
  }

  TextFormField editForm_status() {
    return TextFormField(
      readOnly: true,
      controller: truckData_status == null ? null : truckData_status,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Status',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
    );
  }

  DropdownButtonFormField<String> editForm_siteselect() {
    return DropdownButtonFormField(
      value: truckData_location.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
      items: sitelist
          .map((value) => DropdownMenuItem(
                value: value,
                child: Container(
                    alignment: Alignment.centerLeft, child: Text(value)),
              ))
          .toList(),
      onChanged: (value) {
        truckData_location.text = value!;
        setState(() {
          truckData_parkingposition.text = 'blank';
          changeSite = 1;
          print('onChange ==> $changeSite !!!');
        });
      },
      onTap: () {},
    );
  }

  Widget editForm_parklotselect() {
    return DropdownButtonFormField(
      value: truckData_parkingposition.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
      items: parkinglot_posi[indexParkSite]
          .map((value) => DropdownMenuItem(
                value: value,
                child: Container(
                    alignment: Alignment.centerLeft, child: Text(value)),
              ))
          .toList(),
      onChanged: (value) {
        if (changeSite == 0) {
          truckData_parkingposition.text = value!;
        } else {
          truckData_parkingposition.text = 'blank';
          Flushbar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            message: 'โปรดอัพเดทไซต์ก่อนเลือกตำแหน่งจอด',
            messageColor: Colors.black,
            duration: Duration(seconds: 5),
            leftBarIndicatorColor: Color.fromARGB(255, 215, 5, 5),
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Color.fromARGB(255, 216, 32, 8),
            ),
          ).show(context);
        }
        print('park lot ==> ${truckData_parkingposition.text}');
      },
    );
  }

  TextFormField editForm_model() {
    return TextFormField(
      controller: truckData_model == null ? null : truckData_model,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Model',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
    );
  }

  TextFormField editForm_serial() {
    return TextFormField(
      controller: truckData_serial == null ? null : truckData_serial,
      readOnly: true,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Serial',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color.fromARGB(255, 215, 214, 214)),
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
    );
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click from  ==>> $index');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Choose your image location'),
          subtitle: Text('โปรดเลือกแหล่งที่อยู่รูปภาพ'),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (kIsWeb) {
                    print('This is web platform');
                    final ImagePicker _picker = ImagePicker();
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      var selected = await image.readAsBytes();
                      webImageArr[index] = selected;
                      // print('select local file ==>$webImage');
                      img_files[index] = File('a');
                    }
                  } else {
                    processImagePicker(ImageSource.camera, index);
                  }
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  if (kIsWeb) {
                    print('This is web platform');
                    final ImagePicker _picker = ImagePicker();
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      var selected = await image.readAsBytes();
                      webImageArr[index] = selected;
                      // print('select local file ==>$webImage');
                      img_files[index] = File('a');
                    }
                  } else {
                    processImagePicker(ImageSource.gallery, index);
                  }
                },
                child: Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(result!.path);
        img_files[index] = file;
      });
      uploadImg(index);
    } catch (e) {}
  }

  Future<Null> uploadImg(int index) async {
    int ran = Random().nextInt(10000000);
    String paths = '';
    int dateNow = DateTime.now().microsecondsSinceEpoch;

    String filetype = img_files[index]!
        .path
        .split('.')[img_files[index]!.path.split('.').length - 1];

    print('file type : ${filetype}');

    String nameFile =
        'truck${truckData_serial.text}_${index}_${dateNow}.${filetype}';
    paths = 'truck_instock_img/$nameFile';

    Map<String, dynamic> map = {};
    map['file'] = await MultipartFile.fromFile(img_files[index]!.path,
        filename: nameFile);

    FormData data = FormData.fromMap(map);

    String apiSaveReqPic =
        '${MyConstant.domain_warecondb}/update_truckimg.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${truckData_serial.text}&path=$paths';

    await Dio().post(apiSaveReqPic, data: data).then((value) async {
      print('Upload Statius ==> ${value}');
      gettruckdata_byserial();
    });
  }

  Container imgShowWidget(int index) {
    return Container(
      child: Column(
        children: [
          Container(
              height: 20,
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 10, top: 10),
              child: cacheImg[index] == 'null'
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        chooseSourceImageDialog(index);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: ListTile(
                              leading: Icon(Icons.info_outline),
                              title: Text('Are you sure?'),
                              subtitle: Text('คุณแน่ใจใช่ไหมว่าต้องการลบ'),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      print('URL => ${cacheImg[index]}');
                                      String apiPath =
                                          '${MyConstant.domain_warecondb}/delete_truckpic.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${truckData_serial.text}&filename=${cacheImg[index]}';

                                      await Dio().get(apiPath).then((value) {
                                        print(value);
                                        Navigator.pop(context);
                                        gettruckdata_byserial();
                                      });
                                    },
                                    child: Text('Confirm'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.black),
                      ),
                    )),
          InteractiveViewer(
            maxScale: 20,
            child: Container(
                height: 370,
                child: Container(
                  child: InkWell(
                    child: cacheImg[index] == 'null'
                        ? Icon(Icons.image_outlined)
                        : cacheImg[index].toString().contains('assets') == true
                            ? Image.asset(cacheImg[index])
                            : FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image:
                                    // 'https://www.btmexpertsales.com/warehouse_connect_dbapi/showimgweb.php?url=truck_instock_img/truck6113439_0_1679730003655899.jpg'
                                    '${MyConstant.domain_warecondb}showimgweb.php?url=${cacheImg[index]}',
                              ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  String trimModel(String model_get) {
    String modelModify = model_get.substring(0, 2);
    // print(model_get);
    if (modelModify == 'UR') {
      // print(model_get);
      modelModify = model_get.replaceFirst(RegExp('UR'), '');
    } else if (modelModify == 'UB') {
      // print(model_get);
      modelModify = model_get.replaceFirst(RegExp('UB'), '');
    }

    return modelModify;
  }

  Future<Null> setNewTruckImg() async {
    double screensize = MediaQuery.of(context).size.width;
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
                    'Use New Truck Image',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 40,
                  child: DropdownButtonFormField(
                    value: dropdownValue_imgNewtruck,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
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
                    items: listImgName
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(value)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue_imgNewtruck = value!;
                      });

                      print('value ==> $value');

                      int index1 =
                          listImgName.indexWhere(((site) => site == value));
                      newtruckImg_select.text = listImgFile[index1];
                      print(newtruckImg_select.text);
                    },
                  ),
                )
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
                      String apiPath =
                          '${MyConstant.domain_warecondb}/update_truckimgNewTruck.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=${truckData_serial.text}&path=${newtruckImg_select.text}';
                      print(apiPath);

                      await Dio().get(apiPath).then((value) {
                        print(value);
                        gettruckdata_byserial();
                        Navigator.pop(context);
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
}
