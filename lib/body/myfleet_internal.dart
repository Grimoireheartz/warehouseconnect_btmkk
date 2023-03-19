import 'dart:convert';

import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:btm_warehouseconnect/state/truck_detail.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyfleetInternal extends StatefulWidget {
  const MyfleetInternal({super.key});

  @override
  State<MyfleetInternal> createState() => _MyfleetInternalState();
}

class _MyfleetInternalState extends State<MyfleetInternal> {
  List<String> list = <String>['BT_Khonkaen', 'BT_Phatthanakan67', 'BT_Onnut'];
  String? dropdownValue;
  int countTruckOnsite = 0;
  List<TruckInStock> truckget_instock = [];

  List<Image> imageTruckShow = [];

  @override
  void initState() {
    setState(() {
      dropdownValue = list.first;
    });
    // TODO: implement initState
    super.initState();
    gettruckbysite();
  }

  Future gettruckbysite() async {
    truckget_instock.clear();
    int countGet = 0;
    String apiPath =
        '${MyConstant.domain_warecondb}/select_truckbysite.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&site=$dropdownValue';
    await Dio().get(apiPath).then((value) {
      print(value);
      if (value.toString() != 'error') {
        for (var truck in jsonDecode(value.data)) {
          TruckInStock truckInStock = TruckInStock.fromMap(truck);
          print(truckInStock.serial);
          countGet++;
          setState(() {
            truckget_instock.add(truckInStock);
            if (truckInStock.model_item.contains('RRE') == true) {
              imageTruckShow.add(Image.asset(MyConstant.pic_rre));
            } else if (truckInStock.model_item.contains('LWE') == true) {
              imageTruckShow.add(Image.asset(MyConstant.pic_lwe));
            } else {
              imageTruckShow.add(Image.asset(MyConstant.pic_truckicon));
            }
          });
        }
        setState(() {
          countTruckOnsite = countGet;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            addTruckBtn(screensize, context),
            instockTitle(screensize),
            selectSite(screensize),
            ..._truckonsite(screensize),
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
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
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

  Container instockTitle(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      constraints: BoxConstraints(maxWidth: 800),
      width: screensize * 0.9,
      child: Text(
        'TRUCK IN STOCK',
        style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container addTruckBtn(double screensize, BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10),
      constraints: BoxConstraints(maxWidth: 800),
      width: screensize * 0.9,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: Icon(
            Icons.add,
            size: 35,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, MyConstant.routeAddTruckToSite);
          },
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Truck',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                'เพิ่มข้อมูลรถยก',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          )),
    );
  }

  List<Widget> _truckonsite(screensize) {
    List<Widget> truckonsiteList = [];
    for (int x = 0; x < countTruckOnsite; x++) {
      truckonsiteList.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          constraints: BoxConstraints(maxWidth: 800),
          width: screensize * 0.9,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.centerLeft,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TruckDetail(truckInStock: truckget_instock[x]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    child: imageTruckShow[x],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Serial: ${truckget_instock[x].serial}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Model: ${trimModel(truckget_instock[x].model_item, x)}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Price: ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return truckonsiteList;
  }

  String trimModel(String model_get, int index) {
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
}
