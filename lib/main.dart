import 'package:btm_warehouseconnect/state/add_truck_tosite.dart';
import 'package:btm_warehouseconnect/state/authen.dart';
import 'package:btm_warehouseconnect/state/customer_home.dart';
import 'package:btm_warehouseconnect/state/internal_home.dart';
import 'package:btm_warehouseconnect/state/qr_generator.dart';
import 'package:btm_warehouseconnect/state/qr_scanner.dart';
import 'package:btm_warehouseconnect/state/register.dart';
import 'package:btm_warehouseconnect/state/user_management.dart';
import 'package:btm_warehouseconnect/state/user_setting.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// uploade string test

String? initailRoute;
final Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (BuildContext context) => AuthenPage(),
  MyConstant.routeCustomerHome: (BuildContext context) => CustomerHome(),
  MyConstant.routeRegister: (BuildContext context) => RegisterPage(),
  MyConstant.routeUserSetting: (BuildContext context) => UserSetting(),
  MyConstant.routeInternalHome: (BuildContext context) => InternalHome(),
  MyConstant.routeQRscanner: (BuildContext context) => QRscanner(),
  MyConstant.routeQRgenerator: (BuildContext context) => QRgenerator(),
  MyConstant.routeUsermanagement: (BuildContext context) => UserManagement(),
  MyConstant.routeAddTruckToSite: (BuildContext context) => AddTruckToSite(),
};

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? userType = preferences.getString('userType');

  try {
    if (kIsWeb) {
      // running on the web!
      await Firebase.initializeApp(
          options: FirebaseOptions(
        apiKey: 'AIzaSyCfhL-4uEipzox-ehpXUmPsAYDKnY5z2ig',
        appId: '1:632282316706:web:33f1cc61054ea25f9d7cfb',
        messagingSenderId: '632282316706',
        projectId: 'warehouseconnect-9df42',
        storageBucket: 'warehouseconnect-9df42.appspot.com',
      )).then((value) async {
        FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        FirebaseMessaging.instance.getToken().then((value) async {
          print('## Firebase Token ==> $value');
        });
      });
    } else {
      await Firebase.initializeApp().then((value) async {
        FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        FirebaseMessaging.instance.getToken().then((value) async {
          print('## Firebase Token ==> $value');
          if (Platform.isAndroid) {
            // Android-specific code
            print('Android Platfrom');
          } else if (Platform.isIOS) {
            // iOS-specific code
            print('IOS Plarform');
          }
        });
      });
    }
  } catch (e) {
    print(e);
  }

  if (userType?.isEmpty ?? true) {
    initailRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else if (userType == 'customer') {
    initailRoute = MyConstant.routeCustomerHome;
    runApp(MyApp());
  } else if (userType == 'internal') {
    initailRoute = MyConstant.routeInternalHome;
    runApp(MyApp());
  }
  print('Warehouse connnect route to ==> ${initailRoute}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initailRoute,
      title: 'Warehouse Connec',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
