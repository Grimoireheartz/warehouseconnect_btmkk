import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<String> departmentList = ['Sales & Marketing'];
  TextEditingController select_department = TextEditingController();

  final formKey = GlobalKey<FormState>();

  TextEditingController user_firstname = TextEditingController();
  TextEditingController user_lastname = TextEditingController();
  TextEditingController user_phonenum = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_password = TextEditingController();
  TextEditingController user_passwordagain = TextEditingController();
  TextEditingController user_companyname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 58, 58, 58),
        title: Text('Register - ลงทะเบียนเพื่อเข้าใช้งาน'),
        toolbarHeight: 50,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              height: screensizeHeight - 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MyConstant.appbg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: screensize * 0.8,
                  constraints: BoxConstraints(maxHeight: 800, maxWidth: 600),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 250, 241, 241).withOpacity(0.95),
                        Color.fromARGB(255, 245, 186, 186).withOpacity(0.95)
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: Text(
                            '* กรอกรายละเอียดด้านล่างให้ครบถ้วน เพื่อสมัครใช้งาน Warehouse connect',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            controller:
                                user_firstname == null ? null : user_firstname,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกชื่อจริง(ภาษาอังกฤษ)';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'ชื่อจริง - FirstName',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.assignment_ind_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            controller:
                                user_lastname == null ? null : user_lastname,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกนามสกุล(ภาษาอังกฤษ)';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'นามสกุล - LastName',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.assignment_ind_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            controller: user_companyname == null
                                ? null
                                : user_companyname,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกชื่อบริษัท';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'ชื่อบริษัท - Company',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.contacts_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            controller:
                                user_phonenum == null ? null : user_phonenum,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกเบอร์โทรติดต่อ';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'เบอร์โทรติดต่อ - Tell',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            controller: user_email == null ? null : user_email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกอีเมลล์';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'อีเมลล์ - Email',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            obscureText: true,
                            controller:
                                user_password == null ? null : user_password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกรหัสผ่าน';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'รหัสผ่าน - Password',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextFormField(
                            obscureText: true,
                            controller: user_passwordagain == null
                                ? null
                                : user_passwordagain,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '** โปรดกรอกยืนยันรหัสผ่าน';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'ยืนยันรหัสผ่าน - Confirm Pass.',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: screensize * 0.7,
                          constraints: BoxConstraints(maxWidth: 500),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (user_password.text ==
                                    user_passwordagain.text) {
                                  await requestRegis();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: GestureDetector(
                                          onTap: () =>
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Password Not Match - รหัสผ่านไม่ตรงกัน'),
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
                              }
                            },
                            child: Text(
                              'ลงทะเบียน - Register',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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

  Future<Null> requestRegis() async {
    String data_fname = user_firstname.text;
    String data_lname = user_lastname.text;
    String data_email = user_email.text;
    data_email = data_email.toLowerCase();
    String data_phone = user_phonenum.text;
    String data_password = user_password.text;
    String data_company = user_companyname.text;
    String data_usertype = 'customer';

    String apiPath =
        '${MyConstant.domain_warecondb}insert_userdata.php/?key_db=${MyConstant.key_db}&apikey=${MyConstant.apikey_db}&email=$data_email&firstname=$data_fname&lastname=$data_lname&companyname=$data_company&password=$data_password&phone_number=$data_phone&usertype=$data_usertype';
    await Dio().get(apiPath).then((value) async {
      print('from Server => $value');
      if (value.toString() == 'successfully') {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('firstname', data_fname);
        preferences.setString('lastname', data_lname);
        preferences.setString('email', data_email);
        preferences.setString('phonenumber', data_phone);
        preferences.setString('companyname', data_company);
        preferences.setString('userType', data_usertype);

        print(
            'fname: $data_fname lastname: $data_lname email: $data_email phone: $data_phone');

        Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.routeCustomerHome, (route) => false);
      } else if (value.toString() == 'HaveUser_exist') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'This email already exists - พบอีเมลล์นี้ลงทะเบียนอยู่แล้ว'),
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
      }
    });
  }
}
