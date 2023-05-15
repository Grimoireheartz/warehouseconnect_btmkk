import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:btm_warehouseconnect/body/layoutmap.dart';
import 'package:btm_warehouseconnect/model/campaignmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../utility/myconstant.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

enum Menu { itemOne }

class CampaignDetail extends StatefulWidget {
  final CampaignModel Campaign;
  const CampaignDetail({super.key, required this.Campaign});

  @override
  State<CampaignDetail> createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
  CampaignModel? CampaignDetail;
  final formKey = GlobalKey<FormState>();
  TextEditingController campaign_id = TextEditingController();
  TextEditingController campaign_name = TextEditingController();
  TextEditingController campaign_detail = TextEditingController();
  TextEditingController campaign_url = TextEditingController();
  TextEditingController campaign_startdate = TextEditingController();
  TextEditingController campaign_enddate = TextEditingController();
  TextEditingController campaign_presentdate = TextEditingController();
  TextEditingController campaign_notifications = TextEditingController();
  TextEditingController campaign_notificationstime = TextEditingController();
  dynamic dropdownValue;
  List<File?> img_files = [];
  int showimgIndex = 0;
  File? file;
  List<String> cacheImg = ['null', 'null', 'null', 'null'];
  List<String> weekly = [
    '',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> monthly = [
    '',
    "The date on 1",
    "The date on 2",
    "The date on 3",
    "The date on 4",
    "The date on 5",
    "The date on 6",
    "The date on 7",
    "The date on 8",
    "The date on 9",
    "The date on 10",
    "The date on 11",
    "The date on 12",
    "The date on 13",
    "The date on 14",
    "The date on 15",
    "The date on 16",
    "The date on 17",
    "The date on 18",
    "The date on 19",
    "The date on 20",
    "The date on 21",
    "The date on 22",
    "The date on 23",
    "The date on 24",
    "The date on 25",
    "The date on 26",
    "The date on 27",
    "The date on 28",
    "The date on 29",
    "The date on 30",
    "The date on 31"
  ];
  List<String> SelectedChoice = ["Weekly", "Monthly"];
  List<Uint8List> webImageArr = [for (var x = 0; x <= 2; x++) Uint8List(8)];
  bool load = true;

  @override
  void initState() {
    for (var i = 0; i < 4; i++) {
      img_files.add(null);
    }
    // TODO: implement initState
    CampaignDetail = widget.Campaign;
    setState(() {
      campaign_id.text = CampaignDetail!.id;
      campaign_name.text = CampaignDetail!.promo_name;
      campaign_detail.text = CampaignDetail!.promo_detial;
      campaign_url.text = CampaignDetail!.url;
      campaign_startdate.text = CampaignDetail!.stdate;
      campaign_enddate.text = CampaignDetail!.enddate;
      campaign_presentdate.text = CampaignDetail!.present_datecampaign;
      campaign_notifications.text = CampaignDetail!.notifications;
      campaign_notificationstime.text = CampaignDetail!.notifications_time;
    });

    GetCampaign();

    print(CampaignDetail!.promo_name);
    super.initState();
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future GetCampaign() async {
    String apiPath =
        '${MyConstant.domain_warecondb}/warehouseconnect_data2/select_campaignname.php?promoname=${campaign_name.text}';

    await Dio().get(apiPath).then((value) {
      if (value.toString().length > 0) {
        for (var data in jsonDecode(value.data)) {
          CampaignModel Campaign = CampaignModel.fromMap(data);

          String imgGet = Campaign.picture;

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
        }
      }
    }).then((value) {
      setState(() {
        load = false;
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
          title: Text('CampaignEdit'),
          actions: [
            PopupMenuButton<Menu>(
              icon: Icon(Icons.more_vert_outlined),
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
                  print('Choose item => ${item.name} ');
                  deleteCampaignDialog(context);
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<Menu>>[
                const PopupMenuItem(
                  child: Text(
                    'Delete Campaign',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: Menu.itemOne,
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
                                    : cacheImg[0]
                                                .toString()
                                                .contains('assets') ==
                                            true
                                        ? Image.asset(cacheImg[0])
                                        : FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image:
                                                '${MyConstant.domain_warecondb}warehouseconnect_data2/showcampaignimage.php?url=${cacheImg[0]}',
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
                                    : cacheImg[1]
                                                .toString()
                                                .contains('assets') ==
                                            true
                                        ? Image.asset(cacheImg[1])
                                        : FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image:
                                                '${MyConstant.domain_warecondb}warehouseconnect_data2/showcampaignimage.php?url=${cacheImg[1]}',
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
                                    : cacheImg[2]
                                                .toString()
                                                .contains('assets') ==
                                            true
                                        ? Image.asset(cacheImg[2])
                                        : FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image:
                                                '${MyConstant.domain_warecondb}warehouseconnect_data2/showcampaignimage.php?url=${cacheImg[2]}',
                                          ),
                              ),
                            )
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
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 81, 81, 81)
                                    .withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Campaign Information',
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
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Promotion Name:'),
                                      SizedBox(
                                        height: 55,
                                        child: Text('Promotion Detail:'),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: Text('Link url:'),
                                      ),
                                      Text('Promotion Start:'),
                                      Text('Promotion End: '),
                                      Text('Promotion Update: '),
                                      Text('Notification:'),
                                      Text('NotificationTime:'),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(campaign_name.text),
                                      SizedBox(
                                        width: 150,
                                        height: 55,
                                        child: AutoSizeText(
                                          campaign_detail.text,
                                          minFontSize: 14,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        height: 20,
                                        child: AutoSizeText(
                                          campaign_url.text,
                                          minFontSize: 14,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Text(campaign_startdate.text),
                                      Text(campaign_enddate.text),
                                      Text(campaign_presentdate.text),
                                      Text(campaign_notifications.text),
                                      Text(campaign_notificationstime.text)
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }

  Container imgShowWidget(int index) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 20,
            alignment: Alignment.bottomRight,
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
                            title: Text('Are you sure ?'),
                            subtitle: Text('คุณแน่ใจใช่ไหมว่าต้องการลบ'),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    print('URL => ${cacheImg[index]}');
                                    String apiPath =
                                        '${MyConstant.domain_warecondb}/warehouseconnect_data2/delete_campaignpic.php?promoname=${campaign_name.text}&filename=${cacheImg[index]}';

                                    await Dio().get(apiPath).then((value) {
                                      print(value);
                                      Navigator.pop(context);
                                      GetCampaign();
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
                  ),
          ),
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
                                    '${MyConstant.domain_warecondb}warehouseconnect_data2/showcampaignimage.php?url=${cacheImg[index]}',
                              ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void deleteCampaignDialog(BuildContext contex) {
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
                      'Are you sure to delete this campaign from app?',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('คุณแน่ใจใช่ไหมที่จะต้องการลบข้อมูลของแคมเปญอันนี้')
                  ],
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  String apiPath =
                      '${MyConstant.domain_warecondb}warehouseconnect_data2/delete_campaignDB.php?id=${campaign_id.text}';
                  await Dio().get(apiPath).then((value) {
                    print("Before");
                    print(value);
                    print("Next step");
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
                  String update_id = campaign_id.text;
                  String update_promoname = campaign_name.text;
                  String update_promodetail = campaign_detail.text;
                  String update_url = campaign_url.text;
                  String update_startdate = campaign_startdate.text;
                  String update_enddate = campaign_enddate.text;
                  String update_presentdate = campaign_presentdate.text;
                  String update_notifications = campaign_notifications.text;
                  String update_notificationtime =
                      campaign_notificationstime.text;

                  String apiPath =
                      '${MyConstant.domain_warecondb}/warehouseconnect_data2/update_campaigninfo.php?id=$update_id&promoname=$update_promoname&promadetail=$update_promodetail&url=$update_url&startdate=$update_startdate&enddate=$update_enddate&presentdate=$update_presentdate&notifications=$update_notifications&notificationstime=$update_notificationtime';
                  print(apiPath);
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
                ),
              ),
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
                          'Edit Campaign Information.',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'PromotionName:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_PromoName(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'PromotionDetail:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_Promodeatil(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Link url:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_campaignurl(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Promotion Start',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_startcampaign(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Promotion End:',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_endcampaign(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Update Promotion: ',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      editForm_campaignpresentdate(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Notifications',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      editForm_select(),
                      SizedBox(
                        height: 5,
                      ),
                      editFrom_campaignnotiweekly(),
                      SizedBox(
                        height: 5,
                      ),
                      editForm_campaignnotificationtime(),
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

  Container editForm_select() {
    return Container(
      alignment: Alignment.center,
      child: DropdownButtonFormField(
        value: 'Weekly',
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
        items: SelectedChoice.map((value) => DropdownMenuItem(
              value: value,
              child: Container(
                  alignment: Alignment.centerLeft, child: Text(value)),
            )).toList(),
        onChanged: (value) {
          setState(() {
            dropdownValue = value;
            if (dropdownValue == 'Weekly') {
              weekly = [
                '',
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ];
            } else {
              weekly = monthly;
            }
            print(weekly);
          });
        },
      ),
    );
  }

  TextFormField editForm_PromoName() {
    return TextFormField(
      controller: campaign_name == null ? null : campaign_name,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'PromotionName',
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

  TextFormField editForm_Promodeatil() {
    return TextFormField(
      maxLines: 5,
      controller: campaign_detail == null ? null : campaign_detail,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'PromotionDetail',
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

  TextFormField editForm_campaignurl() {
    return TextFormField(
      maxLines: 2,
      controller: campaign_url == null ? null : campaign_url,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Link URL',
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

  Container editForm_startcampaign() {
    return Container(
      child: TextFormField(
        controller: campaign_startdate == null ? null : campaign_startdate,
        // initialValue: truckData_serial.text,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.calendar_today_rounded),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          errorStyle: TextStyle(color: Colors.red),
          hintText: 'Promotion Start',
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
        onTap: () async {
          DateTime? pickeddate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101));

          if (pickeddate != null) {
            setState(() {
              campaign_startdate.text =
                  DateFormat('dd/MM/yyyy').format(pickeddate);
            });
          }
        },
      ),
    );
  }

  TextFormField editForm_endcampaign() {
    return TextFormField(
        controller: campaign_enddate == null ? null : campaign_enddate,
        // initialValue: truckData_serial.text,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.calendar_today_rounded),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          errorStyle: TextStyle(color: Colors.red),
          hintText: 'Promotion End',
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
        onTap: () async {
          DateTime? pickeddate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101));

          if (pickeddate != null) {
            setState(() {
              campaign_enddate.text =
                  DateFormat('dd/MM/yyyy').format(pickeddate);
            });
          }
        });
  }

  TextFormField editForm_campaignpresentdate() {
    return TextFormField(
      controller: campaign_presentdate == null ? null : campaign_presentdate,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Date Posting Promotion',
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
      onTap: () async {
        TimeOfDay? newTime = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());

        if (newTime != null) {
          setState(() {
            String formattedTime = DateFormat('hh:mm a').format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                newTime.hour,
                newTime.minute,
              ),
            );
            campaign_presentdate.text = formattedTime;
          });
        }
      },
    );
  }

  DropdownButtonFormField<String> editFrom_campaignnotiweekly() {
    return DropdownButtonFormField(
      // value: campaign_notifications.text,
      value: '',
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
      items: weekly
          .map((value) => DropdownMenuItem(
                value: value,
                child: Container(
                    alignment: Alignment.centerLeft, child: Text(value)),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          campaign_notifications.text = value!;
        });
      },
    );
  }

  DropdownButtonFormField editFrom_campaignnotimonthly() {
    return DropdownButtonFormField(
      value: '1',
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
      items: monthly
          .map((value) => DropdownMenuItem(
                value: value,
                child: Container(
                    alignment: Alignment.centerLeft, child: Text(value)),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          campaign_notifications.text = value;
        });
      },
    );
  }

  TextFormField editForm_campaignnotificationtime() {
    return TextFormField(
      controller: campaign_notificationstime == null
          ? null
          : campaign_notificationstime,
      // initialValue: truckData_serial.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        errorStyle: TextStyle(color: Colors.red),
        hintText: 'Hour : Minute AM/PM',
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
      onTap: () async {
        TimeOfDay? newTime = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        if (newTime != null) {
          setState(() {
            String formattedTime = DateFormat('hh:mm a').format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                newTime.hour,
                newTime.minute,
              ),
            );
            campaign_notificationstime.text = formattedTime;
          });
        }
      },
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

    String nameFile = 'campaignmarketing${ran}_${index}_${dateNow}.${filetype}';
    paths += 'campaign_img/$nameFile';

    Map<String, dynamic> map = {};
    map['file'] = await MultipartFile.fromFile(img_files[index]!.path,
        filename: nameFile);

    FormData data = FormData.fromMap(map);

    String apiSaveReqPic =
        '${MyConstant.domain_warecondb}/warehouseconnect_data2/update_campaignimg.php?promoname=${campaign_name.text}&path=$paths';

    print('Upload picture to database success!');
    await Dio().post(apiSaveReqPic, data: data).then((value) async {
      print('Upload Statius ==> ${value}');

      GetCampaign();
    });
  }
}
