import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:btm_warehouseconnect/utility/show_image.dart';
import 'package:btm_warehouseconnect/utility/show_progress.dart';
import 'package:btm_warehouseconnect/widget/display_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:line_icons/line_icon.dart';

import '../utility/myconstant.dart';

class CampaignForm extends StatefulWidget {
  const CampaignForm({super.key});

  @override
  State<CampaignForm> createState() => _CampaignFormState();
}

class _CampaignFormState extends State<CampaignForm> {
  TextEditingController _newdate = TextEditingController();
  TextEditingController _Enddate = TextEditingController();
  TextEditingController _PromoName = TextEditingController();
  TextEditingController _Promodetail = TextEditingController();
  TextEditingController _URL = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Uint8List webImage = Uint8List(8);
  List<Uint8List> webImageArr = [for (var x = 0; x <= 2; x++) Uint8List(8)];
  List<File?> files = [];
  File? file;

  @override
  void initState() {
    // setState(() {
    //   dropdownValue = list.first;
    // });
    // TODO: implement initState
    for (var i = 0; i < 5; i++) {
      files.add(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Campaign Form'),
        foregroundColor: Colors.black,
      ),
      body:
          // ? ShowProgress()
          GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InputPictureCampaign(screensize),
                InputPromotionName(screensize),
                InputPromotionDetail(screensize),
                InputURL(screensize),
                InputStartDatePromotion(screensize, context),
                InputEndDatePromotion(screensize, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 800),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 120, 1, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          int fileLength = 0;
                          int dateNow = DateTime.now().microsecondsSinceEpoch;
                          int countFile = 0;
                          String paths = '';

                          for (var item in files) {
                            if (item != null) {
                              fileLength++;

                              int i = Random().nextInt(10000000);
                              String filetype = item!.path
                                  .split('.')[item.path.split('.').length - 1];
                              String nameFile =
                                  'campaignmarketing${i}_${dateNow}_${countFile}.${filetype}';
                              // print('## Attachfile ==> ${item.path}');

                              paths += 'campaign_img/$nameFile' + ',';
                              Map<String, dynamic> map = {};
                              map['file'] = await MultipartFile.fromFile(
                                  item.path,
                                  filename: nameFile);

                              FormData data = FormData.fromMap(map);

                              String apiSaveReqPic =
                                  '${MyConstant.domain_warecondb}warehouseconnect_data2/insert_imagen.php';

                              print(apiSaveReqPic);
                              await Dio()
                                  .post(apiSaveReqPic, data: data)
                                  .then((value) async {
                                print("upload success $value");
                              });
                            }
                          }

                          // print('## File Lenght ==> $fileLength');

                          if (formKey.currentState!.validate()) {
                            String data_promoname = _PromoName.text;
                            String data_promodetail = _Promodetail.text;
                            String data_newdate = _newdate.text;
                            String data_enddate = _Enddate.text;
                            String data_url = _URL.text;

                            print('data1 = ${data_promoname}');
                            print('data2 = ${data_promodetail}');
                            print('data3 = ${data_newdate}');
                            print('data4 = ${data_enddate}');
                            print('data5 = ${data_url}');
                            print('data6 =${paths}');

                            String apiPath =
                                '${MyConstant.domain_warecondb}/warehouseconnect_data2/insert_campaign.php?campaignname=${data_promoname}&campaigndetail=${data_promodetail}&campaignimg=${paths}&campaignurl=${data_url}&campaignstartdate=${data_newdate}&campaignenddate=${data_enddate}';
                            print(apiPath);
                            await Dio().get(apiPath).then((value) {
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
                                          Text('Add data success! '),
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
                            });
                            //  {
                            //   print(value);
                            // });
                          }
                        },
                        child: Text(
                          'Add New Campaign',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Container InputPictureCampaign(double screensize) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.only(top: 20),
      width: screensize * 0.8,
      constraints: BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildAddImage1(),
              buildAddImage2(),
              buildAddImage3(),
            ],
          ),
        ],
      ),
    );
  }

  Container buildAddImage1() {
    return Container(
      width: 60,
      child: InkWell(
        onTap: () => chooseSourceImageDialog(0),
        child: files[0] == null
            ? Icon(
                Icons.image,
                size: 100,
              )
            : kIsWeb
                ? Image.memory(
                    webImageArr[0],
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    files[0]!,
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }

  Container buildAddImage2() {
    return Container(
      width: 60,
      child: InkWell(
        onTap: () => chooseSourceImageDialog(1),
        child: files[1] == null
            ? Icon(
                Icons.image,
                size: 100,
              )
            : kIsWeb
                ? Image.memory(
                    webImageArr[1],
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    files[1]!,
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }

  Container buildAddImage3() {
    return Container(
      width: 60,
      child: InkWell(
        onTap: () => chooseSourceImageDialog(2),
        child: files[2] == null
            ? Icon(
                Icons.image,
                size: 100,
              )
            : kIsWeb
                ? Image.memory(
                    webImageArr[2],
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    files[2]!,
                    fit: BoxFit.cover,
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
          leading: ShowImage(
            path: MyConstant.pic_rre,
          ),
          title: ShowTitle(
              title: 'Source Image ${index + 1} ?',
              textStyle: MyConstant().h2style_bl()),
          subtitle: ShowTitle(
              title: 'Please Tab on Camera or Gallery',
              textStyle: MyConstant().h3style_bl()),
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
                      files[index] = File('a');
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
                      files[index] = File('a');
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
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Row InputEndDatePromotion(double screensize, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: screensize * 0.8,
          child: TextFormField(
            controller: _Enddate,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_today_rounded),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                errorStyle: TextStyle(color: Colors.red),
                hintText: 'Select date to End',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(Icons.info_outline_rounded)),
            onTap: () async {
              DateTime? pickeddate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));

              if (pickeddate != null) {
                setState(() {
                  _Enddate.text = DateFormat('dd/MM/yyyy').format(pickeddate);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Row InputStartDatePromotion(double screensize, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: screensize * 0.8,
          child: TextFormField(
            controller: _newdate,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_today_rounded),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                errorStyle: TextStyle(color: Colors.red),
                hintText: 'Select date on Start',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(Icons.info_outline_rounded)),
            onTap: () async {
              DateTime? pickeddate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));

              if (pickeddate != null) {
                setState(() {
                  _newdate.text = DateFormat('dd/MM/yyyy').format(pickeddate);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Row InputURL(double screensize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: screensize * 0.8,
          child: TextFormField(
            controller: _URL,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                errorStyle: TextStyle(color: Colors.red),
                hintText: 'URL',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(Icons.info_outline_rounded)),
          ),
        ),
      ],
    );
  }

  Row InputPromotionDetail(double screensize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: screensize * 0.8,
          child: TextFormField(
            controller: _Promodetail,
            maxLines: 3,
            validator: (value) {
              if (value!.isEmpty) {
                return '** โปรดกรอก รายละเอียดของโปรโมชั่น';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                errorStyle: TextStyle(color: Colors.red),
                hintText: 'Enter promotion description',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(Icons.info_outline_rounded)),
          ),
        ),
      ],
    );
  }

  Row InputPromotionName(double screensize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: screensize * 0.8,
          constraints: BoxConstraints(maxWidth: 800),
          child: TextFormField(
            controller: _PromoName,
            validator: (value) {
              if (value!.isEmpty) {
                return '** โปรดกรอก ชื่อของโปรโมชั่น';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                errorStyle: TextStyle(color: Colors.red),
                hintText: 'Promotion Names',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(Icons.info_outline_rounded)),
          ),
        ),
      ],
    );
  }
}
