import 'package:flutter/material.dart';

class InternalHome extends StatefulWidget {
  const InternalHome({super.key});

  @override
  State<InternalHome> createState() => _InternalHomeState();
}

class _InternalHomeState extends State<InternalHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internal Home'),
      ),
    );
  }
}
