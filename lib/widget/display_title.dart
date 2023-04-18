import 'package:btm_warehouseconnect/utility/myconstant.dart';
import 'package:flutter/material.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const ShowTitle({
    Key? key,
    required this.title,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStyle == null ? MyConstant().h3style_bl() : textStyle,
    );
  }
}
