import 'dart:convert';

import 'package:btm_warehouseconnect/model/truckinfo_model.dart';
import 'package:btm_warehouseconnect/state/truck_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/sitelist_model.dart';
import '../utility/myconstant.dart';

class AddTruckFromScan extends StatefulWidget {
  final TruckInfoModel truckDetail;
  const AddTruckFromScan({super.key, required this.truckDetail});

  @override
  State<AddTruckFromScan> createState() => _AddTruckFromScanState();
}

class _AddTruckFromScanState extends State<AddTruckFromScan> {
  TruckInfoModel? truckToAdd;
  List<String> list = [];
  bool load = true;
  String? dropdownValue;

  @override
  void initState() {
    setState(() {
      truckToAdd = widget.truckDetail;
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
        // print('print site ==>>> ${siteListModel.location_name}');
        setState(() {
          list.add(siteListModel.location_name);
        });
      }
      setState(() {
        dropdownValue = list.first;
      });
    }).then((value) {
      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add truck to site'),
      ),
      body: load == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  selectSite(screensize),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: screensize * 0.8,
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Serial: ',
                              style: TextStyle(),
                            ),
                            Text('Model:'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              truckToAdd!.serial_no,
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(truckToAdd!.item_no,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: screensize * 0.8,
                    constraints: BoxConstraints(maxWidth: 800),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Color.fromARGB(255, 158, 250, 193),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          String data_serial = '${truckToAdd!.serial_no},';
                          String data_model = '${truckToAdd!.item_no},';
                          String data_site = dropdownValue.toString();
                          print('Serial => $data_serial');
                          print('Model => $data_model');
                          print('Site => $data_site');
                          String apiPath =
                              '${MyConstant.domain_warecondb}/insert_truckinstock.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&serial=$data_serial&model=$data_model&site=$data_site';
                          await Dio().get(apiPath).then((value) {
                            print(value);

                            if (value.toString() == 'successfully') {
                              Navigator.pop(context);
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
                            }
                          });
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
                  )
                ],
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
          setState(() {
            dropdownValue = value;
          });
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
