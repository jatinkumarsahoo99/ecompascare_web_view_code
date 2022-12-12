import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/second.controller.dart';

class SecondScreen extends GetView<SecondController> {
  const SecondScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecondScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SecondScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
