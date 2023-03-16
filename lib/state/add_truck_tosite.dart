import 'package:flutter/material.dart';

class AddTruckToSite extends StatefulWidget {
  const AddTruckToSite({super.key});

  @override
  State<AddTruckToSite> createState() => _AddTruckToSiteState();
}

class _AddTruckToSiteState extends State<AddTruckToSite> {
  List<String> list = <String>['BT_Khonkaen', 'BT_Phatthanakan67', 'BT_Onnut'];
  String? dropdownValue;

  int truckserialCount = 1;

  List<TextEditingController> truckdata_serial = [
    for (int i = 1; i <= 11; i++) TextEditingController()
  ];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      dropdownValue = list.first;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Add Truck to site'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: screensize * 0.8,
                    constraints: BoxConstraints(maxWidth: 800),
                    child: DropdownButton(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.arrow_downward_rounded,
                        size: 10,
                      ),
                      elevation: 16,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 145, 15, 6),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: list
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(value)),
                              ))
                          .toList(),
                    ),
                  ),
                  Container(
                    width: screensize * 0.8,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (truckserialCount < 10) {
                                truckserialCount++;
                                print(truckserialCount);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: GestureDetector(
                                        onTap: () =>
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Limited to 10 items'),
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
                            });
                          },
                          icon: Icon(Icons.add_circle_outline_rounded,
                              color: Colors.black),
                          label: Text(
                            'Add',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ),
                  ..._inputTruckSerial(screensize),
                  Container(
                    width: screensize * 0.8,
                    constraints: BoxConstraints(maxWidth: 800),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 120, 1, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Check Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _inputTruckSerial(screensize) {
    List<Widget> truckserialList = [];

    for (int x = 1; x <= truckserialCount; x++) {
      truckserialList.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: screensize * 0.8,
          constraints: BoxConstraints(maxWidth: 500),
          child: TextFormField(
            controller:
                truckdata_serial[x] == null ? null : truckdata_serial[x],
            validator: (value) {
              if (value!.isEmpty) {
                return '** โปรดกรอก Serial';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              errorStyle: TextStyle(color: Colors.red),
              hintText: 'Serial Number',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 104, 103, 103)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              prefixIcon: Icon(
                Icons.info_outline,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return truckserialList;
  }
}
