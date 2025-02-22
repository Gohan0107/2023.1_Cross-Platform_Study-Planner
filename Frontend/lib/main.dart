import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/AllPages/home_page.dart';
import 'package:frontend/AllPages/home_page_admin.dart';
import 'package:frontend/AllPages/home_page_teacher.dart';
import 'package:frontend/AllPages/routes_page.dart';
import 'package:frontend/AuthPage/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(primarySwatch: Colors.amber),
      builder: EasyLoading.init(),
    );
  }
}
