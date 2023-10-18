// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class Dining_page extends StatefulWidget {
  const Dining_page({super.key});

  @override
  State<Dining_page> createState() => _Dining_pageState();
}

class _Dining_pageState extends State<Dining_page> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Dining is in progress")),
    );
  }
}
