import 'package:btm_warehouseconnect/body/layoutmap.dart';
import 'package:btm_warehouseconnect/body/myfleet_internal.dart';
import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  String user_firstname = '';
  String user_email = '';
  int indexPosition = 0;

  List<Widget> widgets = [
    LayoutMap(),
    MyfleetInternal(),
    LayoutMap(),
    LayoutMap(),
    LayoutMap(),
  ];

  List<IconData> icons = [
    Icons.home_outlined,
    Icons.location_on_outlined,
    Icons.assignment_outlined,
    Icons.chat,
    Icons.more_horiz_outlined
  ];

  List<String> titles = ['Home', 'FindTruck', 'WorkOrder', 'Chat', 'Other'];

  List<String> titles_thai = [
    'หน้าหลัก',
    'ไซต์ฉัน',
    'แจ้งซ่อม',
    'สนทนา',
    'อื่นๆ'
  ];

  List<Color> textcolor = [
    Color.fromARGB(255, 233, 78, 6),
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];
  List<Color> bgAlert = [
    Color.fromARGB(0, 255, 255, 255),
    Color.fromARGB(0, 255, 255, 255),
    Color.fromARGB(0, 255, 255, 255),
    Color.fromARGB(0, 255, 255, 255),
    Color.fromARGB(0, 255, 255, 255),
  ];

  List<BottomNavigationBarItem> bottomNavigationBarItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserinfo();

    int i = 0;
    for (var item in titles) {
      bottomNavigationBarItems.add(
        createBottomNavigationBarItem(
            icons[i], item, titles_thai[i], textcolor[i], bgAlert[i]),
      );
      i++;
    }
  }

  Future getuserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_firstname = preferences.getString('firstname')!;
      user_email = preferences.getString('email')!;
    });
    // print('userFname: $user_firstname');
  }

  BottomNavigationBarItem createBottomNavigationBarItem(IconData iconData,
          String string, String thaistring, Color textco, Color disalert) =>
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            Container(
              width: 60,
              child: Column(
                children: [
                  Icon(iconData),
                  Text(
                    string,
                    style: TextStyle(color: textco, fontSize: 12),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: new Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: disalert,
                  borderRadius: BorderRadius.circular(30),
                ),
                constraints: BoxConstraints(
                  minWidth: 20,
                  minHeight: 10,
                ),
                child: new Text(
                  '',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        label: thaistring,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              MyConstant.applogo_rmbg,
              width: 60,
            ),
          ],
        ),
        leadingWidth: 80,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MyConstant.routeUserSetting);
              },
              icon: Icon(
                Icons.account_circle_outlined,
                size: 30,
                color: Color.fromARGB(255, 109, 107, 107),
              ),
            ),
            Text(
              user_firstname,
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 241, 70, 2),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          Container(
            width: 80,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyConstant.routeQRscanner);
                },
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Color.fromARGB(255, 88, 87, 87),
                  size: 30,
                )),
          )
        ],
      ),
      body: widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          color: Color.fromARGB(255, 233, 78, 6),
          size: 30,
        ),
        unselectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 145, 145, 145)),
        selectedItemColor: Color.fromARGB(255, 233, 78, 6),
        unselectedItemColor: Color.fromARGB(255, 145, 145, 145),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: indexPosition,
        items: bottomNavigationBarItems,
        onTap: (value) {
          setState(() {
            indexPosition = value;
            textcolor[indexPosition] = Color.fromARGB(255, 233, 78, 6);
            for (int x = 0; x < 5; x++) {
              if (x != indexPosition) {
                textcolor[x] = Color.fromARGB(255, 145, 145, 145);
              }
            }
            bottomNavigationBarItems.clear();
            int i = 0;
            for (var item in titles) {
              bottomNavigationBarItems.add(
                createBottomNavigationBarItem(
                    icons[i], item, titles_thai[i], textcolor[i], bgAlert[i]),
              );
              i++;
            }
          });
        },
      ),
    );
  }
}
