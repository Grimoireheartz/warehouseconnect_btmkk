import 'package:btm_warehouseconnect/model/truckinstock_model.dart';
import 'package:flutter/material.dart';

class TruckDetail extends StatefulWidget {
  final TruckInStock truckInStock;
  const TruckDetail({super.key, required this.truckInStock});

  @override
  State<TruckDetail> createState() => _TruckDetailState();
}

class _TruckDetailState extends State<TruckDetail> {
  TruckInStock? truckDetail;

  @override
  void initState() {
    truckDetail = widget.truckInStock;
    print(truckDetail);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    double screensizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Truck Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: screensize,
                height: 400,
                child: ModelViewer(src: 'assets/forklift.glb'),
                // BabylonJSViewer(src: 'assets/uutyut.stl'),
              ),
              Container(
                padding: EdgeInsets.all(8),
                width: screensize * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color.fromARGB(255, 201, 201, 201),
                  //     Color.fromARGB(255, 255, 255, 255),
                  //   ],
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 81, 81, 81).withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'General Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 20,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              popform(context, screensize);
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Serial:'),
                            Text('Model:'),
                            Text('Location:'),
                            Text('Status:'),
                            Text('Model Year:'),
                            Text('Price:'),
                            Text('Description:')
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(truckDetail!.serial),
                              Text('${trimModel(truckDetail!.model_item)}'),
                              Text(truckDetail!.site),
                              Text(truckDetail!.truck_status),
                              Text(truckDetail!.model_year),
                              Text(truckDetail!.price),
                              Text(truckDetail!.price),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void popform(BuildContext context, double screensize) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              width: screensize,
              child: Column(
                children: [
                  TextFormField(
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
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      prefixIcon: Icon(
                        Icons.assignment_ind_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(),
                  TextFormField(),
                  TextFormField(),
                  TextFormField(),
                  TextFormField(),
                  TextFormField(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String trimModel(String model_get) {
    String modelModify = model_get.substring(0, 2);
    // print(model_get);
    if (modelModify == 'UR') {
      // print(model_get);
      modelModify = model_get.replaceFirst(RegExp('UR'), '');
    } else if (modelModify == 'UB') {
      // print(model_get);
      modelModify = model_get.replaceFirst(RegExp('UB'), '');
    }

    return modelModify;
  }
}
