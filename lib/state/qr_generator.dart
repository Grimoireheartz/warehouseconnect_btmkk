import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';

import '../model/truckinstock_model.dart';

class QRgenerator extends StatefulWidget {
  final TruckInStock truckInStock;
  const QRgenerator({super.key, required this.truckInStock});

  @override
  State<QRgenerator> createState() => _QRgeneratorState();
}

class _QRgeneratorState extends State<QRgenerator> {
  TextEditingController truckdata_serial = TextEditingController();
  TextEditingController truckdata_model = TextEditingController();
  TruckInStock? truckDetail;
  final formKey = GlobalKey<FormState>();

  String generateDataInfo = '';

  @override
  void initState() {
    truckDetail = widget.truckInStock;
    // TODO: implement initState
    super.initState();

    print('Truck serial : ${truckDetail!.serial}');
    setState(() {
      generateDataInfo = 'warehouseconnectbybtm?sn=${truckDetail!.serial}';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('QR Information'),
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
