import 'dart:convert';
import 'dart:ui';

import 'package:btm_warehouseconnect/model/campaignmodel.dart';
import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:btm_warehouseconnect/state/campaign_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utility/myconstant.dart';

class Campaignpage extends StatefulWidget {
  const Campaignpage({super.key});

  @override
  State<Campaignpage> createState() => _CampaignpageState();
}

class _CampaignpageState extends State<Campaignpage> {
  String user_firstname = '';
  String user_email = '';
  int indexPosition = 0;
  List<String> imageCampaign = [];
  List<CampaignModel> history_campaign = [];
  int countTruckOnsite = 0;
  int showimgIndex = 0;
  bool load = false;

  @override
  void initState() {
    Campaignall();
    // TODO: implement initState
    super.initState();
  }

  Future<Null> Campaignall() async {
    history_campaign.clear();
    imageCampaign.clear();
    countTruckOnsite = 0;
    String apiPath =
        '${MyConstant.domain_warecondb}/warehouseconnect_data2/select_campaignoutput.php';
    print(apiPath);
    await Dio().get(apiPath).then((value) {
      print('return data form database===> $value');
      for (var campaign in jsonDecode(value.data)) {
        CampaignModel Campaign = CampaignModel.fromMap(campaign);
        print(Campaign.promo_name);
        countTruckOnsite++;

        String cacheImg = MyConstant.pic_truckicon;
        String imgGet = Campaign.picture;

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
          history_campaign.add(Campaign);
          imageCampaign.add(cacheImg);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Campaign Management'),
        foregroundColor: Colors.black,
      ),
      body: load
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  addCampaignDB(screensize, context),
                  historyTitle(screensize),
                  ...showallpromotion(screensize),
                ],
              ),
            ),
    );
  }

  List<Widget> showallpromotion(screensize) {
    List<Widget> showallpromotion = [];
    if (countTruckOnsite != 0) {
      for (int x = 0; x < countTruckOnsite; x++) {
        showallpromotion.add(
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
                          CampaignDetail(Campaign: history_campaign[x])),
                ).then((value) {
                  Campaignall();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 40,
                      child: imageCampaign[x].contains('assets') == true
                          ? Icon(Icons.image)
                          : FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  '${MyConstant.domain_warecondb}warehouseconnect_data2/showcampaignimage.php?url=${imageCampaign[x]}',
                            ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PromotionName: ${history_campaign[x].promo_name}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'CampaignURL: ${history_campaign[x].url}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'StartCampaign: ${history_campaign[x].stdate}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'EndCampaign: ${history_campaign[x].enddate}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      showallpromotion.add(Container(
        child: Text('Empty Data'),
      ));
    }

    return showallpromotion;
  }

  Container historyTitle(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      constraints: BoxConstraints(maxWidth: 800),
      width: screensize * 0.9,
      child: Text(
        'History',
        style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container addCampaignDB(double screensize, BuildContext context) {
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
            Navigator.pushNamed(context, MyConstant.routeCampainForm)
                .then((value) {
              print("return to historial");
              Campaignall();
            });
          },
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Campaigns',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                'เพิ่มข้อมูลแคมเปญ',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          )),
    );
  }
}
