import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';

class MyfleetInternal extends StatefulWidget {
  const MyfleetInternal({super.key});

  @override
  State<MyfleetInternal> createState() => _MyfleetInternalState();
}

class _MyfleetInternalState extends State<MyfleetInternal> {
  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
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
                    Navigator.pushNamed(
                        context, MyConstant.routeAddTruckToSite);
                  },
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Truck',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'เพิ่มข้อมูลรถยก',
                        style: TextStyle(fontSize: 12, color: Colors.black),
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
