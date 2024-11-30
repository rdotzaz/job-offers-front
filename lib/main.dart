import 'package:flutter/material.dart';
import 'package:oferty_pracy/utils/hive_adapter.dart';
import 'package:oferty_pracy/view/home.dart';

void main() async {
  await HiveDatabaseAdapter.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
