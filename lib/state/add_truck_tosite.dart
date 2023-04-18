import 'dart:convert';

import 'package:btm_warehouseconnect/model/truckinfo_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/sitelist_model.dart';
import '../utility/myconstant.dart';

class AddTruckToSite extends StatefulWidget {
  const AddTruckToSite({super.key});

  @override
  State<AddTruckToSite> createState() => _AddTruckToSiteState();
}

class _AddTruckToSiteState extends State<AddTruckToSite> {
  List<String> list = [];
  String? dropdownValue;
  bool load = false;
  bool haveChangeInput = false;

  int truckserialCount = 1;

  List<TextEditingController> truckdata_serial = [
    for (int i = 1; i <= 11; i++) TextEditingController()
  ];
  List<Icon> truckicon_display = [
    for (int i = 1; i <= 11; i++)
      Icon(
        Icons.info_outline,
        color: Colors.black,
      )
  ];
  List<BorderSide> truckbordercolors_display = [
    for (int i = 1; i <= 11; i++) BorderSide(color: Colors.grey)
  ];
  List<String> truckGetData_model = [for (int i = 1; i <= 11; i++) ''];

  List<TruckInfoModel> truckData_toAdd = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getSiteList();
    // setState(() {
    //   dropdownValue = list.first;
    // });
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
        // print('print site ==>>> ${siteListModel.location_name}');
        setState(() {
          list.add(siteListModel.location_name);
        });
      }
      setState(() {
        dropdownValue = list.first;
      });
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
        title: Text('Add Truck to site'),
      ),
      body: load
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Container(
                    height: screensizeHeight,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
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
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)),
                            underline: Container(
                              height: 2,
                              color: Color.fromARGB(255, 145, 15, 6),
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: list
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(value)),
                                    ))
                                .toList(),
                          ),
                        ),
                        Container(
                          width: screensize * 0.8,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (truckserialCount < 10) {
                                      truckserialCount++;
                                      print(truckserialCount);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: GestureDetector(
                                              onTap: () =>
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar(),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Limited to 10 items'),
                                                  Icon(
                                                    Icons.close_rounded,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )),
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.only(
                                              bottom: 40.0,
                                              left: 10,
                                              right: 10),
                                        ),
                                      );
                                    }
                                  });
                                },
                                icon: Icon(Icons.add_circle_outline_rounded,
                                    color: Colors.black),
                                label: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ),
                        ..._inputTruckSerial(screensize),
                        Container(
                          width: screensize * 0.8,
                          constraints: BoxConstraints(maxWidth: 800),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 120, 1, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                String truckSerialSearch = '';
                                truckData_toAdd.clear();
                                int countdata = 0;
                                for (var x = 1; x <= truckserialCount; x++) {
                                  if (truckdata_serial[x].text.length > 0) {
                                    truckSerialSearch +=
                                        truckdata_serial[x].text + ',';
                                  }
                                }
                                if (truckSerialSearch.length > 0) {
                                  setState(() {
                                    load = true;
                                  });
                                  print('Truck Search: $truckSerialSearch');

                                  String apiPath =
                                      '${MyConstant.domain_warecondb}/select_truckinfo.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=$truckSerialSearch';

                                  await Dio().get(apiPath).then((value) {
                                    if (value.toString() == 'null') {
                                      print('is Mull');
                                      for (var x = 1;
                                          x <= truckserialCount;
                                          x++) {
                                        setState(() {
                                          truckicon_display[x] = Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          );

                                          truckbordercolors_display[x] =
                                              BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 207, 11, 11));
                                        });
                                      }
                                    } else {
                                      // print(value);
                                      for (var x = 1;
                                          x <= truckserialCount;
                                          x++) {
                                        setState(() {
                                          truckicon_display[x] = Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          );

                                          truckbordercolors_display[x] =
                                              BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 207, 11, 11));
                                        });
                                      }

                                      for (var dataTruck
                                          in jsonDecode(value.data)) {
                                        TruckInfoModel truckInfoModel =
                                            TruckInfoModel.fromMap(dataTruck);
                                        countdata++;
                                        print(
                                            'Data truck Model =>${truckInfoModel.serial_no} => ${truckInfoModel.item_no}');

                                        for (var x = 1;
                                            x <= truckserialCount;
                                            x++) {
                                          if (truckdata_serial[x].text ==
                                              truckInfoModel.serial_no) {
                                            setState(() {
                                              truckGetData_model[x] =
                                                  truckInfoModel.item_no;

                                              var detectSerial = truckData_toAdd
                                                  .any((element) =>
                                                      element.serial_no ==
                                                      truckInfoModel.serial_no);

                                              if (detectSerial) {
                                                print('Detect serial');
                                              } else {
                                                print('No detect serial');
                                                truckData_toAdd
                                                    .add(truckInfoModel);
                                              }

                                              truckicon_display[x] = Icon(
                                                Icons.check,
                                                color: Color.fromARGB(
                                                    255, 4, 196, 33),
                                              );

                                              truckbordercolors_display[x] =
                                                  BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 4, 202, 21));
                                            });
                                          }
                                        }
                                      }
                                    }
                                    setState(() {
                                      load = false;
                                      haveChangeInput = false;
                                    });
                                  });
                                }
                              },
                              child: Text(
                                'Check Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screensize * 0.8,
              constraints: BoxConstraints(maxWidth: 800),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: Color.fromARGB(255, 158, 250, 193),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (haveChangeInput == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Please check info first.'),
                                      Text('โปรดกดตรวจสอบข้อมูลก่อน')
                                    ],
                                  ),
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
                    } else {
                      // print('Length => ${truckData_toAdd.length}');
                      if (truckData_toAdd.length > 0) {
                        String insertData_serial = '';
                        String insertData_model = '';
                        String insertData_site = dropdownValue!;
                        for (var truck in truckData_toAdd) {
                          // print(truck.serial_no);
                          insertData_serial += truck.serial_no + ',';
                          insertData_model += truck.item_no + ',';
                        }
                        print('Serial => $insertData_serial');

                        String apiPath =
                            '${MyConstant.domain_warecondb}/insert_truckinstock.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=$insertData_serial&model=$insertData_model&site=$insertData_site';

                        await Dio().get(apiPath).then((value) {
                          print(value);
                          if (value.toString() == 'successfully') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: GestureDetector(
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Save truck successfully'),
                                            Text(
                                                'เพิ่มข้อมูลไปยังไซต์เรียบร้อย')
                                          ],
                                        ),
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: GestureDetector(
                                    onTap: () => ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Have truck existing'),
                                            Text('พบรถยกอยู่แล้ว')
                                          ],
                                        ),
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: GestureDetector(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Not found truck to insert.'),
                                        Text(
                                            'ไม่พบข้อมูลที่ถูกต้องสำหรับบันทึกไปยังไซต์')
                                      ],
                                    ),
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
                    }
                  },
                  icon: Icon(
                    Icons.save_alt,
                    size: 30,
                    color: Colors.black,
                  ),
                  label: Container(
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save truck to site',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'บันทึกข้อมูลไปยังไซต์',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _inputTruckSerial(screensize) {
    List<Widget> truckserialList = [];

    for (int x = 1; x <= truckserialCount; x++) {
      truckserialList.add(
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              width: screensize * 0.8,
              constraints: BoxConstraints(maxWidth: 500),
              child: TextFormField(
                controller:
                    truckdata_serial[x] == null ? null : truckdata_serial[x],
                validator: (value) {
                  if (value!.isEmpty) {
                    return '** โปรดกรอก Serial';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    haveChangeInput = true;
                    for (var x = 1; x <= truckserialCount; x++) {
                      setState(() {
                        truckicon_display[x] = Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        );

                        truckbordercolors_display[x] =
                            BorderSide(color: Colors.grey);
                      });
                    }
                  });
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    errorStyle: TextStyle(color: Colors.red),
                    hintText: 'Serial Number',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: truckbordercolors_display[x]),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    prefixIcon: truckicon_display[x]),
              ),
            ),
            truckGetData_model[x].length > 0
                ? Container(
                    width: screensize * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Model: ${truckGetData_model[x]}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      );
    }

    return truckserialList;
  }
}
