import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DatasheetViewer extends StatefulWidget {
  final String datasheetmodel;
  const DatasheetViewer({super.key, required this.datasheetmodel});

  @override
  State<DatasheetViewer> createState() => _DatasheetViewerState();
}

class _DatasheetViewerState extends State<DatasheetViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Data sheet'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
                child: SfPdfViewer.network(
                    '${MyConstant.domain_warecondb}/datasheet/datasheet_rreh2.pdf')),
          ),
        ],
      ),
    );
  }
}
