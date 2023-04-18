import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:btm_warehouseconnect/model/sitelist_model.dart';
import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:btm_warehouseconnect/state/truck_detail.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MyfleetInternal extends StatefulWidget {
  const MyfleetInternal({super.key});

  @override
  State<MyfleetInternal> createState() => _MyfleetInternalState();
}

class _MyfleetInternalState extends State<MyfleetInternal> {
  List<String> list = [];
  String? dropdownValue;
  int countTruckOnsite = 0;
  List<TruckInStock> truckget_instock = [];

  List<String> imageTruckShow = [];

  bool load = false;

  @override
  void initState() {
    getSiteList();
    // setState(() {
    //   dropdownValue = list.first;
    // });
    // TODO: implement initState
    super.initState();
    // gettruckbysite();
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
        setState(() {
          list.add(siteListModel.location_name);
        });
      }
      setState(() {
        dropdownValue = list.first;
      });
      gettruckbysite();
    }).then((value) {
      load = false;
    });
  }

  Future gettruckbysite() async {
    int countGet = 0;
    String apiPath =
        '${MyConstant.domain_warecondb}/select_truckbysite.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&site=$dropdownValue';
    await Dio().get(apiPath).then((value) {
      print(value);
      if (value.toString() != 'null') {
        print('True condition $value');
        truckget_instock.clear();
        imageTruckShow.clear();
        for (var truck in jsonDecode(value.data)) {
          TruckInStock truckInStock = TruckInStock.fromMap(truck);
          print(truckInStock.serial);
          countGet++;

          String cacheImg = MyConstant.pic_truckicon;
          String imgGet = truckInStock.picture;

          if (imgGet.length > 0) {
            print('Image path => $imgGet');
            var imgGet_arr = imgGet.split(',');
            int count = 0;
            for (var data in imgGet_arr) {
              if (data.length > 0) {
                print('Img file : $data');
                if (count == 0) {
                  setState(() {
                    cacheImg = data;
                  });
                }

                count++;
              }
            }
          }

          setState(() {
            countTruckOnsite = countGet;
            truckget_instock.add(truckInStock);
            imageTruckShow.add(cacheImg);
          });
        }
        setState(() {
          countTruckOnsite = countGet;
        });
      } else {
        truckget_instock.clear();
        setState(() {
          countTruckOnsite = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
            gettruckbysite();
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
            Navigator.pushNamed(context, MyConstant.routeAddTruckToSite)
                .then((value) {
              gettruckbysite();
            });
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
    if (countTruckOnsite != 0) {
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
                ).then((value) {
                  gettruckbysite();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 40,
                      // child: imageTruckShow[x],
                      child: imageTruckShow[x].contains('assets') == true
                          ? Image.asset(imageTruckShow[x])
                          : FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  '${MyConstant.domain_warecondb}showimgweb.php?url=${[
                                x
                              ]}',
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle('Serial'),
                        Text(
                          '${truckget_instock[x].serial}',
                          style: TextStyle(color: Colors.black),
                        ),
                        buildTitle('Model'),
                        SizedBox(
                          width: 150,
                          height: 15,
                          child: AutoSizeText(
                            '${trimModel(truckget_instock[x].model_item, x)}',
                            style: TextStyle(color: Colors.black),
                            minFontSize: 14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTitle('Price'),
                        Text(
                          '${truckget_instock[x].price}',
                          style: TextStyle(color: Colors.black),
                        ),
                        buildTitle('Parking Position'),
                        SizedBox(
                          width: 80,
                          height: 15,
                          child: AutoSizeText(
                            '${truckget_instock[x].parking_posi}',
                            minFontSize: 14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black),
                          ),
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
    } else {
      truckonsiteList.add(Container(
        child: Text('Empty Data'),
      ));
    }

    return truckonsiteList;
  }

  Text buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 10, color: Colors.black),
    );
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
