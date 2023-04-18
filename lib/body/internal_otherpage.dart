import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class InternalOther extends StatefulWidget {
  const InternalOther({super.key});

  @override
  State<InternalOther> createState() => _InternalOtherState();
}

class _InternalOtherState extends State<InternalOther> {
  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            buildQRGenerator(screensize, context),
            buildAddTruckCatalog(screensize, context),
            buildMarketingManagement(screensize, context),
          ],
        ),
      ),
    );
  }

  Container buildMarketingManagement(double screensize, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      constraints: BoxConstraints(maxWidth: 600),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.my_library_books_rounded,
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
          Navigator.pushNamed(context, MyConstant.routeCampainpage);
        },
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marketing Management',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            Text(
              'จัดการแคมเปญ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildQRGenerator(double screensize, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, MyConstant.routeParkingQRGen);
          },
          icon: Icon(
            Icons.location_on_sharp,
            color: Colors.black,
          ),
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Warehouse QR Generate',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'สร้าง QR code ของตำแหน่งจอดในไซต์',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          )),
    );
  }

  Container buildAddTruckCatalog(double screensize, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 45,
      width: screensize * 0.95,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, MyConstant.routeAddTruckCatalog);
          },
          icon: Icon(
            LineIcons.folderPlus,
            color: Colors.black,
          ),
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Truck Catalog',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'เพิ่มข้อมูลแคตตาล๊อกรถยก',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          )),
    );
  }
}
