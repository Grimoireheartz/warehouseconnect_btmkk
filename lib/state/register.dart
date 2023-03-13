import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';

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
  TextEditingController user_firstname_th = TextEditingController();
  TextEditingController user_lastname = TextEditingController();
  TextEditingController user_lastname_th = TextEditingController();
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
                              hintText: 'ชื่อจริง (ภาษาอังกฤษ)',
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
                              hintText: 'นามสกุล (ภาษาอังกฤษ)',
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
                                return '** โปรดกรอกรหัสพนักงาน';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: 'ชื่อบริษัท',
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
                              hintText: 'เบอร์โทรติดต่อ',
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
                              hintText: 'อีเมลล์',
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
                              hintText: 'รหัสผ่าน',
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
                              hintText: 'ยืนยันรหัสผ่าน',
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
                              // await requestRegis(context);
                            },
                            child: Text(
                              'ลงทะเบียน',
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
}
