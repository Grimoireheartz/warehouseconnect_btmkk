import 'package:flutter/material.dart';
import '../utility/myconstant.dart';

class Orderpage extends StatefulWidget {
  const Orderpage({super.key});

  @override
  State<Orderpage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  bool load = false;
  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Order History'),
        foregroundColor: Colors.black,
      ),
      body: load
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  addNewOrder(screensize, context),
                  historyOrdertitle(screensize),
                ],
              ),
            ),
    );
  }

  Container historyOrdertitle(double screensize) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      constraints: BoxConstraints(maxWidth: 800),
      width: screensize * 0.9,
      child: Text(
        'History',
        style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container addNewOrder(double screensize, BuildContext context) {
    return Container(
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
          onPressed: () {},
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Order Cast',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                'เพิ่มรายการสินค้า',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          )),
    );
  }
}
