import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';

class QRgenerator extends StatefulWidget {
  const QRgenerator({super.key});

  @override
  State<QRgenerator> createState() => _QRgeneratorState();
}

class _QRgeneratorState extends State<QRgenerator> {
  TextEditingController truckdata_serial = TextEditingController();
  TextEditingController truckdata_model = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String generateDataInfo = '';

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('QR Generator'),
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: screensize * 0.7,
                    constraints: BoxConstraints(maxWidth: 500),
                    child: TextFormField(
                      controller:
                          truckdata_serial == null ? null : truckdata_serial,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '** โปรดกรอก Serial';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                        errorStyle: TextStyle(color: Colors.red),
                        hintText: 'Serial Number',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 104, 103, 103)),
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: screensize * 0.7,
                    constraints: BoxConstraints(maxWidth: 500),
                    child: TextFormField(
                      controller:
                          truckdata_model == null ? null : truckdata_model,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '** โปรดกรอก Model';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                        errorStyle: TextStyle(color: Colors.red),
                        hintText: 'Truck model',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 104, 103, 103)),
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
                          String data = '&sn=' +
                              truckdata_serial.text +
                              '&model=' +
                              truckdata_model.text;
                          // print(data);
                          setState(() {
                            generateDataInfo = data;
                          });
                        }
                      },
                      child: Text(
                        'Generate QR code',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomPaint(
                    painter: QrPainter(
                        data: generateDataInfo,
                        options: const QrOptions(
                            shapes: QrShapes(
                                darkPixel: QrPixelShapeRoundCorners(
                                    cornerFraction: .5),
                                frame: QrFrameShapeRoundCorners(
                                    cornerFraction: .25),
                                ball: QrBallShapeRoundCorners(
                                    cornerFraction: .25)),
                            colors: QrColors(
                                dark: QrColorLinearGradient(
                                    colors: [
                                  Color.fromARGB(255, 255, 0, 0),
                                  Color.fromARGB(255, 26, 26, 26),
                                ],
                                    orientation:
                                        GradientOrientation.leftDiagonal)))),
                    size: const Size(350, 350),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Data: $generateDataInfo")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
