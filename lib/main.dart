import 'package:btm_warehouseconnect/state/authen.dart';
import 'package:btm_warehouseconnect/state/customer_home.dart';
import 'package:btm_warehouseconnect/state/register.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? initailRoute;
final Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (BuildContext context) => AuthenPage(),
  MyConstant.routeCustomerHome: (BuildContext context) => CustomerHome(),
  MyConstant.routeRegister: (BuildContext context) => RegisterPage(),
};

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? userType = preferences.getString('usertype');

  if (userType?.isEmpty ?? true) {
    initailRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else if (userType == 'customer') {
    initailRoute = MyConstant.routeCustomerHome;
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
