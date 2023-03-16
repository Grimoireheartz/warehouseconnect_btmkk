import 'dart:convert';

import 'package:btm_warehouseconnect/model/user_model.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({super.key});

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  String user_firstname = '';
  String user_type = '';
  String? customerView;
  bool load = true;

  @override
  void initState() {
    getuserdata();
    // TODO: implement initState
    super.initState();
  }

  Future<Null> getuserdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cusViewGetdata = preferences.getString('customerView');

    setState(() {
      user_type = preferences.getString('userType')!;
      print('user type => $user_type');
      if (cusViewGetdata?.isNotEmpty ?? true) {
        customerView = cusViewGetdata;
      }
      print('cusViewer => $customerView');
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          'User Setting',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: load
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  generalinfo(screensize),
                  reauthentication(screensize),
                  user_type == 'internal'
                      ? Column(
                          children: [
                            usermanagment(screensize),
                            customerview(screensize),
                          ],
                        )
                      : Container(),
                  logout(screensize),
                ],
              ),
            )),
    );
  }

  Container generalinfo(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      constraints: BoxConstraints(maxWidth: 600),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.account_circle,
          color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account information',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              'ข้อมูลทั่วไป',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container customerview(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      constraints: BoxConstraints(maxWidth: 600),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.published_with_changes_outlined,
          color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();

          if (customerView?.isEmpty ?? true) {
            preferences.setString('customerView', 'on');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: GestureDetector(
                    onTap: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CustomerView ON'),
                        Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        )
                      ],
                    )),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeCustomerHome, (route) => false);
          } else if (customerView == 'on') {
            preferences.setString('customerView', 'off');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: GestureDetector(
                    onTap: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CustomerView OFF'),
                        Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        )
                      ],
                    )),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
              ),
            );

            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeInternalHome, (route) => false);
          } else if (customerView == 'off') {
            preferences.setString('customerView', 'on');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: GestureDetector(
                    onTap: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CustomerView ON'),
                        Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        )
                      ],
                    )),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeCustomerHome, (route) => false);
          }
        },
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer view - $customerView',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              'มุมมองของลูกค้า',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //usermanagment
  Container usermanagment(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      constraints: BoxConstraints(maxWidth: 600),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.supervised_user_circle_outlined,
          color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeUsermanagement);
        },
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User management',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              'จัดการบัญชีผู้ใช้งาน',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container reauthentication(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      constraints: BoxConstraints(maxWidth: 600),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.rotate_left_rounded,
          color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String? userType = preferences.getString('userType');
          String? userEmail = preferences.getString('email');

          String apiPath =
              '${MyConstant.domain_warecondb}/reauthentication.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&email=$userEmail';
          // print('email: $data_email pass: $data_password');'

          await Dio().get(apiPath).then((value) async {
            print(' Data -> $value');
            for (var data in json.decode(value.data)) {
              UserModel userModel = UserModel.fromMap(data);
              print('User type -> ${userModel.user_type}');

              if (userModel.user_type == userType) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: GestureDetector(
                        onTap: () =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Your account data up to date'),
                            Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            )
                          ],
                        )),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
                  ),
                );
              } else if (userModel.user_type == 'customer') {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString('userType', userModel.user_type);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: GestureDetector(
                        onTap: () =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Now your user type is Customer'),
                            Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            )
                          ],
                        )),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
                  ),
                );
                Navigator.pushNamed(context, MyConstant.routeCustomerHome);
              } else if (userModel.user_type == 'internal') {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString('userType', userModel.user_type);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: GestureDetector(
                        onTap: () =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Now your user type is Internal'),
                            Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            )
                          ],
                        )),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 40.0, left: 10, right: 10),
                  ),
                );
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeInternalHome, (route) => false);
              }
            }
          });

          // print('User Email: $userEmail');
        },
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reauthentication',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              'ตรวจสอบสิทธิของบัญชีการใช้งานอีกครั้ง',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container logout(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      constraints: BoxConstraints(maxWidth: 600),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.logout_outlined,
          color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear().then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false),
              );
        },
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log out',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              'ออกจากระบบ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
