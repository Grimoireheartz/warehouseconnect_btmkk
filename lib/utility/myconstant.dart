import 'package:flutter/material.dart';

class MyConstant {
  static String routeAuthen = '/authenpage';
  static String routeCustomerHome = '/customer_homepage';
  static String routeRegister = '/registerpage';
  static String routeRegiste = '/registerpage';
  static String routeUserSetting = '/usersetting';
  static String routeInternalHome = '/internalhome';
  static String routeUsermanagement = '/usermanagement';
  static String routeAddTruckToSite = '/addtrucktosite';
  static String routeQRscanner = '/qrscanner';
  static String routeQRgenerator = 'qrgenerator';
  static String routeTruckDetail = '/truckdetail';
  static String routeParkingQRGen = '/parkingQRGen';
  static String routeScanQRstorage = '/scanQRstorage';
  static String routeAddTruckCatalog = '/addtruckcatalog';
  static List<String> imgDesc_NewTruck = [
    'ReachTruck H2',
    'LPE',
    'OSE250',
    'SWE',
    'SWE100'
  ];
  static List<String> img_NewTruck = [
    'assets/RREH2_1.png,assets/RREH2_2.png,assets/RREH2_3.png,assets/RREH2_4.png,',
    'assets/LPE_1.png,assets/LPE_2.png,assets/LPE_3.png,assets/LPE_4.png,',
    'assets/OSE250_1.png,assets/OSE250_2.png,assets/OSE250_3.png,assets/OSE250_4.png,',
    'assets/SWE_1.png,assets/SWE_2.png,assets/SWE_3.png,assets/SWE_4.png,',
    'assets/SHE100_1.png,assets/SHE100_2.png,assets/SHE100_3.png,assets/SHE100_4.png,'
  ];

  static String applogo = 'assets/logo_app.png';
  static String appbg = 'assets/appbg.jpg';
  static String tyro_topview = 'assets/tyro_topview.png';
  static String pic_rre = 'assets/RRE.jpg';
  static String pic_lwe = 'assets/LWE.jpg';
  static String pic_truckicon = 'assets/truckicon.png';
  static String applogo_rmbg = 'assets/logo_app-rmbg.png';
  static String key_db = 'Te2537';
  static String apikey_db = '865fceeff57f78a01cb28fa901349d58';
  static String domain_warecondb =
      'https://www.btmexpertsales.com/warehouse_connect_dbapi/';
  static String routeCampainpage = '/campainhistory';
  static String routeCampainForm = '/campainform';
  static String routeCampaigDetail = '/campaigndetail';
  // static String pic_campaign = 'assets/campign.png';

  TextStyle h3style_bl() => TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  TextStyle h2style_bl() => TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}
