import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';

class MyfleetCustomer extends StatefulWidget {
  const MyfleetCustomer({super.key});

  @override
  State<MyfleetCustomer> createState() => _MyfleetCustomerState();
}

class _MyfleetCustomerState extends State<MyfleetCustomer> {
  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 10),
              constraints: BoxConstraints(maxWidth: 800),
              width: screensize * 0.9,
              child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.qr_code_2_rounded,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, MyConstant.routeQRgenerator);
                  },
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Generate truck information QR code',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'สร้าง QR code ของข้อมูลรถยก',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
