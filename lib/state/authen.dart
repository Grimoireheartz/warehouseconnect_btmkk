import 'dart:convert';

import 'package:btm_warehouseconnect/model/user_model.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenPage extends StatefulWidget {
  const AuthenPage({super.key});

  @override
  State<AuthenPage> createState() => _AuthenPageState();
}

class _AuthenPageState extends State<AuthenPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_pass = TextEditingController();
  bool statusRedEye = true;

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              height: screensizeHeight,
              // height: screensizeHeight - 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MyConstant.appbg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                        Color.fromARGB(255, 41, 41, 41).withOpacity(0.8)
                      ],
                    ),
                  ),
                  constraints: BoxConstraints(maxHeight: 650, maxWidth: 600),
                  width: screensize * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          width: screensize * 0.4,
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Image.asset(MyConstant.applogo_rmbg),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: screensize * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Warehouse connect By BTM',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                        inputUserName(screensize),
                        inputPassWord(screensize),
                        btnLogIn(screensize),
                        btnRegistor(screensize),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container btnLogIn(double sreensize) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 50,
      width: sreensize * 0.6,
      constraints: BoxConstraints(maxWidth: 500),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            getUserLogin();
            // getUserloginwithfirebase();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log in',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'เข้าสู่ระบบ',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container inputUserName(double sreensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: sreensize * 0.6,
      constraints: BoxConstraints(maxWidth: 500),
      child: TextFormField(
        controller: user_email == null ? null : user_email,
        validator: (value) {
          if (value!.isEmpty) {
            return '** โปรดกรอกข้อมูล Email';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 12),
          hintText: 'Email',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          labelStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Container btnRegistor(double sreensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      width: sreensize * 0.6,
      constraints: BoxConstraints(maxWidth: 500),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 64, 63, 63),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeRegister);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ลงทะเบียน',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container inputPassWord(double sreensize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: sreensize * 0.6,
      constraints: BoxConstraints(maxWidth: 500),
      child: TextFormField(
        controller: user_pass == null ? null : user_pass,
        validator: (value) {
          if (value!.isEmpty) {
            return '** โปรดกรอกข้อมูล Password';
          } else {
            return null;
          }
        },
        obscureText: statusRedEye,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 12),
          hintText: 'Password',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(
            Icons.key,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                statusRedEye = !statusRedEye;
              });
            },
            icon: statusRedEye
                ? Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                  ),
          ),
          labelStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Future getUserLogin() async {
    String data_email = user_email.text.toLowerCase();
    String data_password = user_pass.text;

    String apiPath =
        '${MyConstant.domain_warecondb}/select_authenuser.php?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&email=$data_email&password=$data_password';
    print('email: $data_email pass: $data_password');

    await Dio().get(apiPath).then((value) async {
      if (value.toString() == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email/Password incorrect - ข้อมูลไม่ถูกต้อง'),
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
      } else {
        for (var data in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(data);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('firstname', userModel.firstname);
          preferences.setString('lastname', userModel.lastname);
          preferences.setString('email', userModel.email);
          preferences.setString('phonenumber', userModel.phone_number);
          preferences.setString('companyname', userModel.companyname);
          preferences.setString('userType', userModel.user_type);

          if (userModel.user_type == 'customer') {
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeCustomerHome, (route) => false);
          } else if (userModel.user_type == 'internal') {
            print('navigation: internal homepage');
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeInternalHome, (route) => false);
          }
        }
      }
    });
  }
}
